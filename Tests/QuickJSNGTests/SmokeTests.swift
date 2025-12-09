import Testing
@testable import QuickJSNG

@Test func canRunSimpleJavaScript() async throws {
  let runtime = JS_NewRuntime()
  #expect(runtime != nil)
  defer { JS_FreeRuntime(runtime) }
  let context = JS_NewContext(runtime)
  #expect(context != nil)
  defer { JS_FreeContext(context) }
  let script = "1 + 1"
  let scriptC = script.utf8CString
  let result = scriptC.withUnsafeBytes { bytes in
    let bytesExcludingTrailingNull = bytes.count - 1
    return JS_Eval(context, bytes.baseAddress, bytesExcludingTrailingNull, "input", 0)
  }
  defer { JS_FreeValue(context, result) }
  #expect(!JS_IsException(result))
  if JS_IsException(result) {
    let exception = JS_GetException(context)
    defer { JS_FreeValue(context, exception) }
    if let exceptionCString = JS_ToCString(context, exception) {
      defer { JS_FreeCString(context, exceptionCString) }
      let exceptionString = String(cString: exceptionCString)
      #expect(exceptionString == "")
    }
  }
  #expect(result.tag == JS_TAG_INT)
  #expect(result.u.int32 == 2)
}
