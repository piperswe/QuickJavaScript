import Testing

@testable import QuickJavaScript

@Suite struct QJSSmokeTests {
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
}
