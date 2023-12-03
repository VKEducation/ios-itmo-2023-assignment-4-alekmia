import Foundation

class RWLock {
    private var lock = pthread_rwlock_t()
    
    public init() {
        guard pthread_rwlock_init(&lock, nil) == 0 else {
            fatalError("cant create rwlock")
        }
    }
                                  
    deinit {
        pthread_rwlock_destroy(&lock)
    }
    
    @discardableResult
    func writeLock() -> Bool {
        pthread_rwlock_wrlock(&lock) == 0
    }
    
    @discardableResult
    func readLock() -> Bool {
        pthread_rwlock_rdlock(&lock) == 0
    }

    @discardableResult
    func unlock() -> Bool {
        pthread_rwlock_unlock(&lock) == 0
    }
}

class ThreadSafeArray<T>  {
    private var array: [T] = []
    private var rwlock = RWLock()
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index {
        self.rwlock.readLock()
        defer { self.rwlock.unlock() }
        return array.startIndex
    }
    var endIndex: Index {
        self.rwlock.readLock()
        defer { self.rwlock.unlock() }
        return array.endIndex
    }
    
    func append(newElement: Element) {
        self.rwlock.writeLock()
        defer { self.rwlock.unlock() }
        self.array.append(newElement)
    }
    
    func count() -> Int {
        self.rwlock.readLock()
        defer { self.rwlock.unlock() }
        return array.count
    }

    subscript(index: Index) -> Element {
        get {
            self.rwlock.readLock()
            defer { self.rwlock.unlock() }
            return self.array[index]
        }
        set {
            self.rwlock.writeLock()
            defer { self.rwlock.unlock() }
            self.array[index] = newValue
        }
    }

    func index(after i: Index) -> Index {
        self.rwlock.readLock()
        defer { self.rwlock.unlock() }
        return array.index(after: i)
    }
    
    func toString() -> String {
        self.rwlock.readLock()
        defer { self.rwlock.unlock() }
        return "\(array)"
    }
    
    
}
