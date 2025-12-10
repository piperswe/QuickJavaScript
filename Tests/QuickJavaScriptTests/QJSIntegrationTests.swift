import Testing

@testable import QuickJavaScript

@Suite struct QJSIntegrationTests {
  @Test func canRunSimpleJavaScript() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(code: "1 + 1")
    #expect(result.int32() == 2)
    #expect(result.description == "2")
  }

  @Test func canRunMoreComplexJavaScript() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let result = context.eval(
      code: """
          function fib(n) {
            if (n == 0) return 0;
            if (n == 1) return 1;
            return fib(n - 1) + fib(n - 2);
          }

          fib(20)
        """)
    #expect(result.int32() == 6765)
  }

  @Test func canManipulateObjectsFromSwift() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()

    // Create an object in JS
    let obj = context.eval(code: "({})")

    // Set properties from Swift
    obj.setProperty(str: "name", value: context.value(string: "Swift"))
    obj.setProperty(str: "version", value: context.value(int32: 6))
    obj.setProperty(str: "stable", value: context.value(bool: true))

    // Read properties back
    #expect(obj.getProperty(str: "name").string() == "Swift")
    #expect(obj.getProperty(str: "version").int32() == 6)
    #expect(obj.getProperty(str: "stable").bool() == true)
  }

  @Test func canWorkWithArrays() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()

    let array = context.eval(code: "[]")
    array.setProperty(uint32: 0, value: context.value(int32: 10))
    array.setProperty(uint32: 1, value: context.value(int32: 20))
    array.setProperty(uint32: 2, value: context.value(int32: 30))

    #expect(array.length == 3)
    #expect(array.getProperty(uint32: 0).int32() == 10)
    #expect(array.getProperty(uint32: 1).int32() == 20)
    #expect(array.getProperty(uint32: 2).int32() == 30)
  }

  @Test func canCallJavaScriptFunctions() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()

    _ = context.eval(code: "function add(a, b) { return a + b; }")
    let result = context.eval(code: "add(5, 7)")

    #expect(result.int32() == 12)
  }

  @Test func multipleContextsShareRuntime() {
    let runtime = QJSRuntime()
    let context1 = runtime.newContext()
    let context2 = runtime.newContext()

    #expect(context1.runtime === runtime)
    #expect(context2.runtime === runtime)
    #expect(context1.runtime === context2.runtime)
  }

  @Test func memoryManagement() {
    let runtime = QJSRuntime()
    runtime.setMemoryLimit(1024 * 1024 * 50)  // 50MB

    let context = runtime.newContext()

    // Create a large array
    _ = context.eval(code: "let arr = new Array(10000).fill(0)")

    // Run GC
    runtime.runGC()

    // Should still work after GC
    let result = context.eval(code: "arr.length")
    #expect(result.int32() == 10000)
  }

  @Test func errorHandling() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()

    let result = context.eval(code: "throw new Error('test error')")
    #expect(result.tag == .exception)
  }

  @Test func workingWithDifferentTypes() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()

    // Numbers
    let int = context.value(int32: 42)
    let float = context.value(float64: 3.14159)

    // Strings
    let str = context.value(string: "Hello")

    // Booleans
    let bool = context.value(bool: true)

    // null and undefined
    let nullVal = context.null
    let undefinedVal = context.undefined

    #expect(int.int32() == 42)
    #expect(float.float64() == 3.14159)
    #expect(str.string() == "Hello")
    #expect(bool.bool() == true)
    #expect(nullVal.tag == .null)
    #expect(undefinedVal.tag == .undefined)
  }
}
