import QuickJSNG

class QJSValue: CustomStringConvertible {
  enum Tag {
    case bigint, symbol, string, module, functionBytecode, object, int, bool, null, undefined,
      uninitialized, catchOffset, exception, shortBigint, float64

    static func from(_ inner: Int64) -> Tag {
      switch inner {
      case Int64(JS_TAG_BIG_INT):
        return .bigint
      case Int64(JS_TAG_SYMBOL):
        return .symbol
      case Int64(JS_TAG_STRING):
        return .string
      case Int64(JS_TAG_MODULE):
        return .module
      case Int64(JS_TAG_FUNCTION_BYTECODE):
        return .functionBytecode
      case Int64(JS_TAG_OBJECT):
        return .object
      case Int64(JS_TAG_INT):
        return .int
      case Int64(JS_TAG_BOOL):
        return .bool
      case Int64(JS_TAG_NULL):
        return .null
      case Int64(JS_TAG_UNDEFINED):
        return .undefined
      case Int64(JS_TAG_CATCH_OFFSET):
        return .catchOffset
      case Int64(JS_TAG_EXCEPTION):
        return .exception
      case Int64(JS_TAG_SHORT_BIG_INT):
        return .shortBigint
      case Int64(JS_TAG_FLOAT64):
        return .float64

      case Int64(JS_TAG_UNINITIALIZED):
        fallthrough
      default:
        return .uninitialized
      }
    }

    internal var cValue: Int64 {
      switch self {
      case .bigint:
        return Int64(JS_TAG_BIG_INT)
      case .bool:
        return Int64(JS_TAG_BOOL)
      case .catchOffset:
        return Int64(JS_TAG_CATCH_OFFSET)
      case .exception:
        return Int64(JS_TAG_EXCEPTION)
      case .float64:
        return Int64(JS_TAG_FLOAT64)
      case .functionBytecode:
        return Int64(JS_TAG_FUNCTION_BYTECODE)
      case .int:
        return Int64(JS_TAG_INT)
      case .module:
        return Int64(JS_TAG_MODULE)
      case .null:
        return Int64(JS_TAG_NULL)
      case .object:
        return Int64(JS_TAG_OBJECT)
      case .shortBigint:
        return Int64(JS_TAG_SHORT_BIG_INT)
      case .string:
        return Int64(JS_TAG_STRING)
      case .symbol:
        return Int64(JS_TAG_SYMBOL)
      case .undefined:
        return Int64(JS_TAG_UNDEFINED)
      case .uninitialized:
        return Int64(JS_TAG_UNINITIALIZED)
      }
    }
  }

  // RC pin to ensure it doesn't get freed from under us
  let context: QJSContext

  private let inner: JSValue

  let tag: Tag

  internal init(context: QJSContext, inner: JSValue) {
    self.context = context
    self.inner = inner
    self.tag = Tag.from(inner.tag)
  }

  deinit {
    JS_FreeValue(context.inner, inner)
  }

  func int32() -> Int32? {
    if tag == .int {
      return inner.u.int32
    } else {
      return nil
    }
  }

  func float64() -> Float64? {
    if tag == .float64 {
      return inner.u.float64
    } else {
      return nil
    }
  }

  func shortBigInt() -> Int32? {
    if tag == .shortBigint {
      return inner.u.short_big_int
    } else {
      return nil
    }
  }

  var description: String {
    guard let cString = JS_ToCString(context.inner, inner) else {
      return ""
    }
    defer { JS_FreeCString(context.inner, cString) }
    return String(cString: cString)
  }

  func string() -> String? {
    if tag == .string {
      return description
    } else {
      return nil
    }
  }

  func bool() -> Bool? {
    if tag == .bool {
      return inner.u.int32 == 1
    } else {
      return nil
    }
  }

  func isFunction() -> Bool {
    return JS_IsFunction(context.inner, inner)
  }

  var isConstructor: Bool {
    get {
      return JS_IsConstructor(context.inner, inner)
    }
    set {
      JS_SetConstructorBit(context.inner, inner, newValue)
    }
  }

  var isRegExp: Bool {
    return JS_IsRegExp(inner)
  }

  var isMap: Bool {
    return JS_IsMap(inner)
  }

  var isSet: Bool {
    return JS_IsSet(inner)
  }

  var isWeakRef: Bool {
    return JS_IsWeakRef(inner)
  }

  var isWeakSet: Bool {
    return JS_IsWeakSet(inner)
  }

  var isWeakMap: Bool {
    return JS_IsWeakMap(inner)
  }

  var isDataView: Bool {
    return JS_IsDataView(inner)
  }

  var isArray: Bool {
    return JS_IsArray(inner)
  }

  var isProxy: Bool {
    return JS_IsProxy(inner)
  }

  var proxyTarget: QJSValue {
    return QJSValue(context: context, inner: JS_GetProxyTarget(context.inner, inner))
  }

  var proxyHandler: QJSValue {
    return QJSValue(context: context, inner: JS_GetProxyHandler(context.inner, inner))
  }

  var isDate: Bool {
    return JS_IsDate(inner)
  }

  func getProperty(atom: JSAtom) -> QJSValue {
    return QJSValue(context: context, inner: JS_GetProperty(context.inner, inner, atom))
  }

  func setProperty(atom: JSAtom, value: QJSValue) {
    JS_SetProperty(context.inner, inner, atom, JS_DupValue(context.inner, value.inner))
  }

  func getProperty(uint32: UInt32) -> QJSValue {
    return QJSValue(context: context, inner: JS_GetPropertyUint32(context.inner, inner, uint32))
  }

  func setProperty(uint32: UInt32, value: QJSValue) {
    JS_SetPropertyUint32(context.inner, inner, uint32, JS_DupValue(context.inner, value.inner))
  }

  func getProperty(int64: Int64) -> QJSValue {
    return QJSValue(context: context, inner: JS_GetPropertyInt64(context.inner, inner, int64))
  }

  func setProperty(int64: Int64, value: QJSValue) {
    JS_SetPropertyInt64(context.inner, inner, int64, JS_DupValue(context.inner, value.inner))
  }

  func getProperty(str: String) -> QJSValue {
    let val = str.withCString { cString in
      return JS_GetPropertyStr(self.context.inner, self.inner, cString)
    }
    return QJSValue(context: context, inner: val)
  }

  func setProperty(str: String, value: QJSValue) {
    let _ = str.withCString { cString in
      JS_SetPropertyStr(self.context.inner, self.inner, cString, JS_DupValue(self.context.inner, value.inner))
    }
  }

  func hasProperty(_ atom: JSAtom) -> Bool {
    return JS_HasProperty(context.inner, inner, atom) != 0
  }

  var extensible: Bool {
    return JS_IsExtensible(context.inner, inner) != 0
  }

  func preventExtensions() {
    JS_PreventExtensions(context.inner, inner)
  }

  func deleteProperty(_ atom: JSAtom, flags: CInt = 0) {
    JS_DeleteProperty(context.inner, inner, atom, flags)
  }

  var prototype: QJSValue {
    get {
      return QJSValue(context: context, inner: JS_GetPrototype(context.inner, inner))
    }
    set {
      JS_SetPrototype(context.inner, inner, newValue.inner)
    }
  }

  var length: Int64 {
    get {
      var res: Int64 = 0
      JS_GetLength(context.inner, inner, &res)
      return res
    }
    set {
      JS_SetLength(context.inner, inner, newValue)
    }
  }

  func sealObject() {
    JS_SealObject(context.inner, inner)
  }

  func freezeObject() {
    JS_FreezeObject(context.inner, inner)
  }

  var isNaN: Bool {
    return JS_VALUE_IS_NAN(inner)
  }
}
