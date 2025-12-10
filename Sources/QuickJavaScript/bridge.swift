internal func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
  return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

internal func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
  return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

internal func bridgeMutating<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
  return Unmanaged.passUnretained(obj).toOpaque()
}

internal func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
  return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

internal func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
  return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}
