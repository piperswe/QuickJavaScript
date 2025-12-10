internal class QJSFinalizerContainer {
  let inner: QJSFinalizer
  init(_ inner: @escaping QJSFinalizer) {
    self.inner = inner
  }
}
