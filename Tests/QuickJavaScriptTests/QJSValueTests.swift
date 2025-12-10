import Testing

@testable import QuickJavaScript

@Suite struct QJSValueTests {
  @Test func tagFromInt32() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.tag == .int)
  }

  @Test func tagFromFloat64() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(float64: 3.14)
    #expect(value.tag == .float64)
  }

  @Test func tagFromString() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "test")
    #expect(value.tag == .string)
  }

  @Test func tagFromNull() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.null
    #expect(value.tag == .null)
  }

  @Test func tagFromUndefined() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.undefined
    #expect(value.tag == .undefined)
  }

  @Test func tagFromBool() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.jsTrue
    #expect(value.tag == .bool)
  }

  @Test func int32ReturnsNilForNonInt() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "test")
    #expect(value.int32() == nil)
  }

  @Test func float64ReturnsNilForNonFloat() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.float64() == nil)
  }

  @Test func shortBigIntReturnsNilForNonBigInt() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.shortBigInt() == nil)
  }

  @Test func stringReturnsNilForNonString() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(value.string() == nil)
  }

  @Test func descriptionForInt() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 123)
    #expect(value.description == "123")
  }

  @Test func descriptionForFloat() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(float64: 3.5)
    #expect(value.description == "3.5")
  }

  @Test func descriptionForString() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(string: "test string")
    #expect(value.description == "test string")
  }

  @Test func descriptionForNull() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.null
    #expect(value.description == "null")
  }

  @Test func descriptionForUndefined() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.undefined
    #expect(value.description == "undefined")
  }

  @Test func descriptionForBool() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let trueValue = context.jsTrue
    let falseValue = context.jsFalse
    #expect(trueValue.description == "true")
    #expect(falseValue.description == "false")
  }

  @Test func isFunctionDetectsFunction() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let function = context.eval(code: "(function() {})")
    #expect(function.isFunction())
  }

  @Test func isFunctionReturnsFalseForNonFunction() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(!value.isFunction())
  }

  @Test func isConstructorDetectsConstructor() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let constructor = context.eval(code: "(class MyClass {})")
    #expect(constructor.isConstructor)
  }

  @Test func canSetConstructorBit() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let function = context.eval(code: "(function() {})")
    function.isConstructor = true
    #expect(function.isConstructor)
  }

  @Test func isArrayDetectsArray() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let array = context.eval(code: "[1, 2, 3]")
    #expect(array.isArray)
  }

  @Test func isArrayReturnsFalseForNonArray() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let object = context.eval(code: "({a: 1})")
    #expect(!object.isArray)
  }

  @Test func isRegExpDetectsRegExp() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let regex = context.eval(code: "/test/")
    #expect(regex.isRegExp)
  }

  @Test func isMapDetectsMap() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let map = context.eval(code: "new Map()")
    #expect(map.isMap)
  }

  @Test func isSetDetectsSet() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let set = context.eval(code: "new Set()")
    #expect(set.isSet)
  }

  @Test func isWeakMapDetectsWeakMap() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let weakMap = context.eval(code: "new WeakMap()")
    #expect(weakMap.isWeakMap)
  }

  @Test func isWeakSetDetectsWeakSet() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let weakSet = context.eval(code: "new WeakSet()")
    #expect(weakSet.isWeakSet)
  }

  @Test func isWeakRefDetectsWeakRef() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let weakRef = context.eval(code: "new WeakRef({})")
    #expect(weakRef.isWeakRef)
  }

  @Test func isDataViewDetectsDataView() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let dataView = context.eval(code: "new DataView(new ArrayBuffer(8))")
    #expect(dataView.isDataView)
  }

  @Test func isDateDetectsDate() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let date = context.eval(code: "new Date()")
    #expect(date.isDate)
  }

  @Test func isProxyDetectsProxy() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let proxy = context.eval(code: "new Proxy({}, {})")
    #expect(proxy.isProxy)
  }

  @Test func canGetProxyTarget() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let proxy = context.eval(code: "new Proxy({x: 42}, {})")
    let target = proxy.proxyTarget
    #expect(target.getProperty(str: "x").int32() == 42)
  }

  @Test func canGetProxyHandler() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let proxy = context.eval(code: "new Proxy({}, {get: function() { return 'handler'; }})")
    let handler = proxy.proxyHandler
    #expect(handler.tag == .object)
  }

  @Test func canGetPropertyWithString() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({name: 'test', value: 42})")
    #expect(obj.getProperty(str: "name").string() == "test")
    #expect(obj.getProperty(str: "value").int32() == 42)
  }

  @Test func canSetPropertyWithString() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    obj.setProperty(str: "name", value: context.value(string: "test"))
    #expect(obj.getProperty(str: "name").string() == "test")
  }

  @Test func canGetPropertyWithUInt32() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let array = context.eval(code: "[10, 20, 30]")
    #expect(array.getProperty(uint32: 0).int32() == 10)
    #expect(array.getProperty(uint32: 1).int32() == 20)
    #expect(array.getProperty(uint32: 2).int32() == 30)
  }

  @Test func canSetPropertyWithUInt32() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let array = context.eval(code: "[]")
    array.setProperty(uint32: 0, value: context.value(int32: 100))
    #expect(array.getProperty(uint32: 0).int32() == 100)
  }

  @Test func canGetPropertyWithInt64() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    obj.setProperty(int64: 12345, value: context.value(string: "test"))
    #expect(obj.getProperty(int64: 12345).string() == "test")
  }

  @Test func canSetPropertyWithInt64() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    obj.setProperty(int64: 99999, value: context.value(int32: 777))
    #expect(obj.getProperty(int64: 99999).int32() == 777)
  }

  @Test func canCheckIfPropertyExists() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({name: 'test'})")
    // We can verify property existence by getting it and checking the result
    let existingProp = obj.getProperty(str: "name")
    #expect(existingProp.string() == "test")

    let missingProp = obj.getProperty(str: "nonexistent")
    #expect(missingProp.tag == .undefined)
  }

  @Test func extensibleDetectsExtensibleObject() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    #expect(obj.extensible)
  }

  @Test func canPreventExtensions() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    obj.preventExtensions()
    #expect(!obj.extensible)
  }

  @Test func canDeleteProperty() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    // Use JavaScript to test property deletion
    _ = context.eval(code: "globalThis.testObj = {name: 'test', age: 30}")
    let result = context.eval(code: "delete testObj.name; testObj.name === undefined")
    #expect(result.description == "true")
  }

  @Test func canGetPrototype() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    let proto = obj.prototype
    #expect(proto.tag == .object)
  }

  @Test func canSetPrototype() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({})")
    let newProto = context.eval(code: "({custom: true})")
    obj.prototype = newProto
    let customProp = obj.getProperty(str: "custom")
    #expect(customProp.description == "true")
  }

  @Test func canGetLength() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let array = context.eval(code: "[1, 2, 3, 4, 5]")
    #expect(array.length == 5)
  }

  @Test func canSetLength() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let array = context.eval(code: "[1, 2, 3, 4, 5]")
    array.length = 3
    #expect(array.length == 3)
  }

  @Test func canSealObject() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({a: 1})")
    obj.sealObject()
    #expect(!obj.extensible)
  }

  @Test func canFreezeObject() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let obj = context.eval(code: "({a: 1})")
    obj.freezeObject()
    #expect(!obj.extensible)
  }

  @Test func isNaNDetectsNaN() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let nanValue = context.eval(code: "NaN")
    #expect(nanValue.isNaN)
  }

  @Test func isNaNReturnsFalseForNumber() {
    let runtime = QJSRuntime()
    let context = runtime.newContext()
    let value = context.value(int32: 42)
    #expect(!value.isNaN)
  }
}
