import QuickJSNG

class QJSContext {
  // RC pin to ensure it doesn't get freed from under us
  let runtime: QJSRuntime

  internal let inner: OpaquePointer

  internal init(runtime: QJSRuntime, inner: OpaquePointer) {
    self.runtime = runtime
    self.inner = inner
  }

  convenience init(runtime: QJSRuntime) {
    self.init(runtime: runtime, inner: runtime.newRawContext())
    // set the runtime as the opaque, and manage the opaque (if needed) in swift-land
    JS_SetContextOpaque(inner, UnsafeMutableRawPointer(mutating: bridge(obj: self)))
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
    if bool {
      return jsTrue
    } else {
      return jsFalse
    }
  }

  func value(int32: Int32) -> QJSValue {
    return value(int32: int32, tag: .int)
  }

  func value(float64: Float64) -> QJSValue {
    return value(u: JSValueUnion(float64: float64), tag: .float64)
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

  func eval(code: String, filename: String = "input", flags: Int32 = 0) -> QJSValue {
    let result = code.utf8CString.withUnsafeBytes { bytes in
      let byteCountWithoutFinalNull = bytes.count - 1
      return filename.withCString { filename in
        return JS_Eval(self.inner, bytes.baseAddress, byteCountWithoutFinalNull, filename, flags)
      }
    }
    return value(inner: result)
  }
}
