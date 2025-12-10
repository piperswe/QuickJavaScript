import QuickJSNG

typealias QJSFunction = (_ this: QJSValue, _ args: [QJSValue]) -> QJSValue

class QJSContext {
  // RC pin to ensure it doesn't get freed from under us
  let runtime: QJSRuntime

  internal let inner: OpaquePointer
  internal var functions: [QJSFunction] = []

  internal init(runtime: QJSRuntime, inner: OpaquePointer) {
    self.runtime = runtime
    self.inner = inner
  }

  convenience init(runtime: QJSRuntime) {
    self.init(runtime: runtime, inner: runtime.newRawContext())
    // set the runtime as the opaque, and manage the opaque (if needed) in swift-land
    JS_SetContextOpaque(inner, UnsafeMutableRawPointer(mutating: bridge(obj: self)))
  }

  static internal func retrieve(fromOpaque: OpaquePointer) -> QJSContext? {
    guard let me = JS_GetContextOpaque(fromOpaque) else {
      return nil
    }
    return bridge(ptr: me)
  }

  deinit {
    JS_FreeContext(inner)
  }

  internal func value(inner: JSValue) -> QJSValue {
    return QJSValue(context: self, inner: inner)
  }

  internal func value(u: JSValueUnion, tag: QJSValue.Tag) -> QJSValue {
    return value(inner: JSValue(u: u, tag: tag.cValue))
  }

  internal func value(int32: Int32, tag: QJSValue.Tag) -> QJSValue {
    return value(u: JSValueUnion(int32: int32), tag: tag)
  }

  var null: QJSValue {
    return value(int32: 0, tag: .null)
  }

  var undefined: QJSValue {
    return value(int32: 0, tag: .undefined)
  }

  var jsFalse: QJSValue {
    return value(int32: 0, tag: .bool)
  }

  var jsTrue: QJSValue {
    return value(int32: 1, tag: .bool)
  }

  var exception: QJSValue {
    return value(int32: 0, tag: .exception)
  }

  var uninitialized: QJSValue {
    return value(int32: 0, tag: .uninitialized)
  }

  func value(bool: Bool) -> QJSValue {
    return value(inner: JS_NewBool(inner, bool))
  }

  func value(int32: Int32) -> QJSValue {
    return value(inner: JS_NewInt32(inner, int32))
  }

  func value(int64: Int64) -> QJSValue {
    return value(inner: JS_NewInt64(inner, int64))
  }

  func value(float64: Float64) -> QJSValue {
    return value(inner: JS_NewFloat64(inner, float64))
  }

  func value(number: Float64) -> QJSValue {
    return value(inner: JS_NewNumber(inner, number))
  }

  func value(uint32: UInt32) -> QJSValue {
    return value(inner: JS_NewUint32(inner, uint32))
  }

  func value(bigint64: Int64) -> QJSValue {
    return value(inner: JS_NewBigInt64(inner, bigint64))
  }

  func value(biguint64: UInt64) -> QJSValue {
    return value(inner: JS_NewBigUint64(inner, biguint64))
  }

  func value(shortBigInt: Int32) -> QJSValue {
    return value(int32: shortBigInt, tag: .shortBigint)
  }

  func value(string: String) -> QJSValue {
    let val = string.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return JS_NewStringLen(self.inner, bytes.baseAddress, byteCountWithoutFinalNull)
    }
    return value(inner: val)
  }

  func value(function: @escaping QJSFunction, name: String = "")
    -> QJSValue
  {
    let cfunc:
      @convention(c) (OpaquePointer?, JSValue, Int32, UnsafeMutablePointer<JSValue>?, Int32) ->
        JSValue = {
          (
            _ ctx: OpaquePointer?, _ this: JSValue, _ argc: CInt,
            _ argv: UnsafeMutablePointer<JSValue>?,
            _ magic: CInt
          ) in
          guard let ctx = ctx else {
            // TODO: throw an exception
            return JSValue(u: JSValueUnion(int32: 0), tag: Int64(JS_TAG_NULL))
          }
          guard let ctx = QJSContext.retrieve(fromOpaque: ctx) else {
            // TODO: throw an exception
            return JSValue(u: JSValueUnion(int32: 0), tag: Int64(JS_TAG_NULL))
          }
          let fn = ctx.functions[Int(magic)]
          var args: [QJSValue] = []
          if let argv = argv {
            for i in 0..<Int(argc) {
              args.append(ctx.value(inner: argv.advanced(by: i).pointee))
            }
          }
          return fn(ctx.value(inner: this), args).inner
        }
    let magic = functions.count
    functions.append(function)
    let val = name.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return JS_NewCFunctionMagic(
        inner,
        cfunc, bytes.baseAddress, Int32(byteCountWithoutFinalNull),
        JS_CFUNC_generic_magic, Int32(magic))
    }
    return value(inner: val)
  }

  func eval(code: String, filename: String = "input", flags: Int32 = 0) -> QJSValue {
    let result = code.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return filename.withCString { filename in
        return JS_Eval(self.inner, bytes.baseAddress, byteCountWithoutFinalNull, filename, flags)
      }
    }
    return value(inner: result)
  }

  var globalThis: QJSValue {
    return value(inner: JS_GetGlobalObject(inner))
  }

  func newAtom(string: String) -> JSAtom {
    return string.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return JS_NewAtomLen(
        self.inner, bytes.assumingMemoryBound(to: CChar.self).baseAddress, byteCountWithoutFinalNull
      )
    }
  }

  var currentException: QJSValue? {
    let val = value(inner: JS_GetException(inner))
    if val.tag != .uninitialized {
      return val
    } else {
      return nil
    }
  }

  func parse(json: String, filename: String = "file") -> QJSValue {
    return json.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return filename.withCString { filename in
        return self.value(
          inner: JS_ParseJSON(
            self.inner, bytes.assumingMemoryBound(to: CChar.self).baseAddress,
            byteCountWithoutFinalNull, filename
          )
        )
      }
    }
  }
}
