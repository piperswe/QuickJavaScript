//
//  QJSRuntime.swift
//  QuickJS-NG-SwiftPM
//
//  Created by Piper McCorkle on 12/9/25.
//

import Foundation
import QuickJSNG

class QJSRuntime {
  internal let inner: OpaquePointer

  // these exist as RC pins to ensure their lifetimes are long enough
  private var runtimeInfo: Data? = nil

  internal init(inner: OpaquePointer) {
    self.inner = inner
  }

  convenience init() {
    self.init(inner: JS_NewRuntime())
    // set the runtime as the opaque, and manage the opaque (if needed) in swift-land
    JS_SetRuntimeOpaque(inner, UnsafeMutableRawPointer(mutating: bridge(obj: self)))
  }

  deinit {
    JS_FreeRuntime(inner)
  }

  func setRuntimeInfo(_ info: String) {
    let runtimeInfo = info.data(using: .utf8, allowLossyConversion: true)!
    self.runtimeInfo = runtimeInfo
    runtimeInfo.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
      JS_SetRuntimeInfo(inner, bytes.baseAddress)
    }
  }

  func setMemoryLimit(_ limit: size_t) {
    JS_SetMemoryLimit(inner, limit)
  }

  var dumpFlags: UInt64 {
    get {
      return JS_GetDumpFlags(inner)
    }
    set {
      JS_SetDumpFlags(inner, newValue)
    }
  }

  var gcThreshold: size_t {
    get {
      return JS_GetGCThreshold(inner)
    }
    set {
      JS_SetGCThreshold(inner, newValue)
    }
  }

  // use 0 to disable maximum stack size check
  func setMaxStackSize(_ stack_size: size_t) {
    JS_SetMaxStackSize(inner, stack_size)
  }

  // should be called when changing thread to update the stack top value
  // used to check stack overflow
  func updateStackTop() {
    JS_UpdateStackTop(inner)
  }

  func runGC() {
    JS_RunGC(inner)
  }

  internal func newRawContext() -> OpaquePointer {
    return JS_NewContext(inner)
  }

  func newContext() -> QJSContext {
    return QJSContext(runtime: self)
  }
}
