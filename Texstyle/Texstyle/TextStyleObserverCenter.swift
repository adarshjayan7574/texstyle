//
//  Copyright © 2020 Rosberry. All rights reserved.
//

protocol TextStyleObserver: AnyObject {
    func textStyleDidChange(_ textStyle: TextStyle)
}

class ObjectWrapper<T>: NSObject {
    var pointer: UnsafePointer<T>?
    var object: T? {
        return _object as? T
    }
    private weak var _object: AnyObject?

    init(_ object: T) {
        super.init()
        let object = object as AnyObject
        self._object = object
        withUnsafePointer(to: object) { pointer in
            self.pointer = pointer as? UnsafePointer<T>
        }
    }

    func isReferenced(to object: T) -> Bool {
        guard self._object == nil else {
            return self._object === (object as AnyObject)
        }
        var isEqual = false
        withUnsafePointer(to: object) { pointer in
            isEqual = self.pointer == pointer
        }
        return isEqual
    }
}

final class TextStyleObserverCenter {

    static let shared: TextStyleObserverCenter = .init()
    var observers: [ObjectWrapper<TextStyle>: [ObjectWrapper<TextStyleObserver>]] = [:]

    private init() {
    }

    func add(_ observer: TextStyleObserver, for textStyle: TextStyle) {
        let wrapper = ObjectWrapper(textStyle)
        var array = observers[wrapper] ?? []
        let isObservingAlready = array.contains { wrapper in
            wrapper.object === observer
        }
        guard isObservingAlready == false else {
            return
        }
        array.append(ObjectWrapper(observer))
        observers[wrapper] = array
        textStyle.observerCenter = self
    }

    func remove(_ observer: TextStyleObserver) {
        observers.keys.forEach { wrapper in
            observers[wrapper]?.removeAll { wrapper in
                wrapper.isReferenced(to: observer)
            }
        }
    }

    func remove(_ textStyle: TextStyle) {
        for wrapper in observers.keys where wrapper.isReferenced(to: textStyle) {
            observers.removeValue(forKey: wrapper)
        }
    }

    func notify(for textStyle: TextStyle) {
        for (wrapper, observers) in observers where wrapper.isReferenced(to: textStyle) {
            observers.forEach { wrapper in
                wrapper.object?.textStyleDidChange(textStyle)
            }
        }
    }
}
