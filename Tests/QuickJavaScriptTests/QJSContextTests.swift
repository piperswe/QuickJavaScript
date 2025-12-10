import Testing

@testable import QuickJavaScript

@Suite struct QJSContextTests {
  @Test func canCreateContext() {
    let runtime = QJSRuntime()
    let context = QJSContext(runtime: runtime)
    _ = context.inner
    #expect(context.runtime === runtime)
  }

  @Test func canGetNull() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let nullValue = context.null
    #expect(nullValue.tag == .null)
    #expect(nullValue.description == "null")
  }

  @Test func canGetUndefined() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let undefinedValue = context.undefined
    #expect(undefinedValue.tag == .undefined)
    #expect(undefinedValue.description == "undefined")
  }

  @Test func canGetBooleanValues() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let falseValue = context.jsFalse
    let trueValue = context.jsTrue
    #expect(falseValue.tag == .bool)
    #expect(trueValue.tag == .bool)
    #expect(falseValue.description == "false")
    #expect(trueValue.description == "true")
  }

  @Test func canCreateBoolFromSwiftBool() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let trueValue = context.value(bool: true)
    let falseValue = context.value(bool: false)
    #expect(trueValue.description == "true")
    #expect(falseValue.description == "false")
  }

  @Test func canCreateInt32Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.tag == .int)
    #expect(value.int32() == 42)
    #expect(value.description == "42")
  }

  @Test func canCreateNegativeInt32Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: -123)
    #expect(value.tag == .int)
    #expect(value.int32() == -123)
    #expect(value.description == "-123")
  }

  @Test func canCreateFloat64Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(float64: 3.14159)
    #expect(value.tag == .float64)
    #expect(value.float64() == 3.14159)
  }

  @Test func canCreateShortBigIntValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(shortBigInt: 1000)
    #expect(value.tag == .shortBigint)
    #expect(value.shortBigInt() == 1000)
  }

  @Test func canCreateStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "Hello, World!")
    #expect(value.tag == .string)
    #expect(value.string() == "Hello, World!")
    #expect(value.description == "Hello, World!")
  }

  @Test func canCreateEmptyStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "")
    #expect(value.tag == .string)
    #expect(value.string() == "")
  }

  @Test func canCreateUnicodeStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "Hello 👋 世界 🌍")
    #expect(value.tag == .string)
    #expect(value.string() == "Hello 👋 世界 🌍")
  }

  @Test func canEvalSimpleExpression() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "1 + 1")
    #expect(result.int32() == 2)
    #expect(result.description == "2")
  }

  @Test func canEvalWithCustomFilename() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "2 * 3", filename: "test.js")
    #expect(result.int32() == 6)
  }

  @Test func canEvalStringExpression() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "'Hello' + ' ' + 'World'")
    #expect(result.string() == "Hello World")
  }
}
