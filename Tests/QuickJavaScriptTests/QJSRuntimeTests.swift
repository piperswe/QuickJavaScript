import Testing

@testable import QuickJavaScript

@Suite struct QJSRuntimeTests {
  @Test func canCreateRuntime() {
    let runtime = QJSRuntime()
    // Just verify the runtime was created successfully
    _ = runtime.inner
  }

  @Test func canSetRuntimeInfo() {
    let runtime = QJSRuntime()
    runtime.setRuntimeInfo("test-runtime")
    // If this doesn't crash, the test passes
  }

  @Test func canSetMemoryLimit() {
    let runtime = QJSRuntime()
    runtime.setMemoryLimit(1024 * 1024 * 10)  // 10MB
    // If this doesn't crash, the test passes
  }

  @Test func canGetAndSetDumpFlags() {
    let runtime = QJSRuntime()
    _ = runtime.dumpFlags
    runtime.dumpFlags = 0x1234
    #expect(runtime.dumpFlags == 0x1234)
  }

  @Test func canGetAndSetGCThreshold() {
    let runtime = QJSRuntime()
    _ = runtime.gcThreshold
    runtime.gcThreshold = 1024 * 256
    #expect(runtime.gcThreshold == 1024 * 256)
  }

  @Test func canSetMaxStackSize() {
    let runtime = QJSRuntime()
    runtime.setMaxStackSize(1024 * 256)
    // If this doesn't crash, the test passes
  }

  @Test func canUpdateStackTop() {
    let runtime = QJSRuntime()
    runtime.updateStackTop()
    // If this doesn't crash, the test passes
  }

  @Test func canRunGC() {
    let runtime = QJSRuntime()
    runtime.runGC()
    // If this doesn't crash, the test passes
  }

  @Test func canCreateContext() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    _ = context.inner
    #expect(context.runtime === runtime)
  }
}
