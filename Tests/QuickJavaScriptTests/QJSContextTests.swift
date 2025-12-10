import Testing

@testable import QuickJavaScript

@Suite struct QJSContextTests {
  @Test func canCreateContext() {
    let runtime = QJSRuntime()
    let context = QJSContext(runtime: runtime)
    _ = context.inner
    #expect(context.runtime === runtime)
    #expect(context.currentException == nil)
  }

  @Test func canGetNull() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let nullValue = context.null
    #expect(nullValue.tag == .null)
    #expect(nullValue.description == "null")
    #expect(context.currentException == nil)
  }

  @Test func canGetUndefined() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let undefinedValue = context.undefined
    #expect(undefinedValue.tag == .undefined)
    #expect(undefinedValue.description == "undefined")
    #expect(context.currentException == nil)
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
    #expect(context.currentException == nil)
  }

  @Test func canCreateBoolFromSwiftBool() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let trueValue = context.value(bool: true)
    let falseValue = context.value(bool: false)
    #expect(trueValue.description == "true")
    #expect(falseValue.description == "false")
    #expect(context.currentException == nil)
  }

  @Test func canCreateInt32Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.tag == .int)
    #expect(value.int32() == 42)
    #expect(value.description == "42")
    #expect(context.currentException == nil)
  }

  @Test func canCreateNegativeInt32Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: -123)
    #expect(value.tag == .int)
    #expect(value.int32() == -123)
    #expect(value.description == "-123")
    #expect(context.currentException == nil)
  }

  @Test func canCreateInt64Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int64: 42)
    #expect(value.tag == .int)
    #expect(value.int32() == 42)
    #expect(value.description == "42")
    #expect(context.currentException == nil)
  }

  @Test func canCreateUint32Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(uint32: 42)
    #expect(value.tag == .int)
    #expect(value.int32() == 42)
    #expect(value.description == "42")
    #expect(context.currentException == nil)
  }

  @Test func canCreateBigint64Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(bigint64: 42)
    #expect(value.tag == .shortBigint)
    #expect(value.shortBigInt() == 42)
    #expect(value.description == "42")
    #expect(context.currentException == nil)
  }

  @Test func canCreateBiguint64Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(biguint64: 42)
    #expect(value.tag == .shortBigint)
    #expect(value.shortBigInt() == 42)
    #expect(value.description == "42")
    #expect(context.currentException == nil)
  }

  @Test func canCreateFloat64Value() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(float64: 3.14159)
    #expect(value.tag == .float64)
    #expect(value.float64() == 3.14159)
    #expect(context.currentException == nil)
  }

  @Test func canCreateNumberValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(number: 3)
    #expect(value.tag == .int)
    #expect(value.int32() == 3)
    #expect(context.currentException == nil)
  }

  @Test func canCreateShortBigIntValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(shortBigInt: 1000)
    #expect(value.tag == .shortBigint)
    #expect(value.shortBigInt() == 1000)
    #expect(context.currentException == nil)
  }

  @Test func canCreateStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "Hello, World!")
    #expect(value.tag == .string)
    #expect(value.string() == "Hello, World!")
    #expect(value.description == "Hello, World!")
    #expect(context.currentException == nil)
  }

  @Test func canCreateEmptyStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "")
    #expect(value.tag == .string)
    #expect(value.string() == "")
    #expect(context.currentException == nil)
  }

  @Test func canCreateUnicodeStringValue() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "Hello 👋 世界 🌍")
    #expect(value.tag == .string)
    #expect(value.string() == "Hello 👋 世界 🌍")
    #expect(context.currentException == nil)
  }

  @Test func canEvalSimpleExpression() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "1 + 1")
    #expect(result.int32() == 2)
    #expect(result.description == "2")
    #expect(context.currentException == nil)
  }

  @Test func canEvalWithCustomFilename() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "2 * 3", filename: "test.js")
    #expect(result.int32() == 6)
    #expect(context.currentException == nil)
  }

  @Test func canEvalStringExpression() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "'Hello' + ' ' + 'World'")
    #expect(result.string() == "Hello World")
    #expect(context.currentException == nil)
  }

  @Test func jsonRoundTrip() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let parsed = context.parse(json: "{ \"hello\": \"world\" }")
    #expect(parsed.isObject)
    #expect(parsed.hasProperty(str: "hello"))
    #expect(parsed.getProperty(str: "hello") == context.value(string: "world"))
    let serialized = parsed.jsonStringify()
    #expect(serialized == "{\"hello\":\"world\"}")
  }

  @Test func defineFunction() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let fn = context.value { (this: QJSValue, args: [QJSValue]) in
      if args.count == 2 {
        return context.value(number: args[0].toFloat64() + args[1].toFloat64())
      } else {
        return context.value(number: -1)
      }
    }
    context.globalThis.setProperty(str: "f", value: fn)
    let result = context.eval(code: "f(1, 2)")
    #expect(result == context.value(number: 3))
  }
}
