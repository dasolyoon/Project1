func nextCellStates(currentStates: [[Bool]]) -> [[Bool]] {
    var nextStates = currentStates
    for i in 0..<currentStates.count {
        for j in 0..<currentStates[0].count {
            
            
            var neighborCount = 0

            if i > 0 {
                if j > 0 && currentStates[i-1][j-1] == true { neighborCount = neighborCount + 1 }
                if currentStates[i-1][j] == true { neighborCount = neighborCount + 1 }
                if j < currentStates[i].count - 1 {
                   if currentStates[i-1][j+1] == true { neighborCount = neighborCount + 1 }
                }
            }
            
            if j > 0 && currentStates[i][j-1] == true { neighborCount = neighborCount + 1 }
            if j < currentStates[i].count - 1 {
                if currentStates[i][j+1] == true { neighborCount = neighborCount + 1 }
            }
            
            if i < currentStates.count - 1 {
                if j > 0 && currentStates[i+1][j-1] == true { neighborCount = neighborCount + 1 }
                if currentStates[i+1][j] == true { neighborCount = neighborCount + 1 }
                if j < currentStates[i].count - 1 {
                    if currentStates[i+1][j+1] == true { neighborCount = neighborCount + 1 }
                }
            }
            

            
            if (currentStates[i][j] == true && neighborCount > 1 && neighborCount < 4)
                || currentStates[i][j] == false && neighborCount == 3 {
                nextStates[i][j] = true
            } else { nextStates[i][j] = false }

        }
    }
    return nextStates
}

private class Key<K:Hashable, V> {
    let k: K
    var prev: Key?
    var next: Key?
    
    init(k: K) {
        self.k = k
    }
}

class LRUCache<K:Hashable, V> {
    private var capacity: Int
    
    var hold_values: Dictionary<K, V>
    private var LRUKey: Key<K, V>?
    private var MRUKey: Key<K, V>?
    var keys_held_so_far: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.hold_values = [K:V]()
        self.keys_held_so_far = 0
    }

    /*
    *  Get the value of the key if the key exists in the cache, otherwise return nil.
    */
    func get(k: K) -> V? {
        // IMPLEMENT ME
        if let thisKey = findKey(k) {
        // remove the Key from its original place
            let prv = thisKey.prev
            let nxt = thisKey.next
            prv?.next = nxt
            nxt?.prev = prv
            
            if thisKey.k == LRUKey?.k {
                LRUKey = prv
            }
            make_MRU(thisKey)
        }
        return hold_values[k]
    }

    /*
    * Set or insert the value if the key is not already present.
    * When the cache reached its capacity, it should invalidate the
    * least recently used item before inserting a new item.
    */
    func set(k: K, v: V) {
        // IMPLEMENT ME
        hold_values[k] = v
        // if key exists
        if let thisKey = findKey(k) {
            make_MRU(thisKey)
        }
        // if key doesn't exist
        else {
            // create the new Key
            let thisKey = Key<K, V>(k: k)
            // put it at front
            // if there is already a MRU, replace it
            if MRUKey != nil {
                make_MRU(thisKey)
            }
            // if there is no MRU, that means there was an empty dictionary
            else {
                MRUKey = thisKey
                LRUKey = thisKey
            }
            
            // if capacity is greater
            if keys_held_so_far == capacity {
                // kill off LRU Key
                hold_values.removeValueForKey((LRUKey?.k)!)
                LRUKey = LRUKey?.prev
            }
            
            keys_held_so_far += 1
            
        }
    }
    
    private func findKey(k: K) -> Key<K, V>? {
        var current_key = MRUKey
        
        while current_key != nil {
            if current_key?.k == k {
                return current_key
            }
            current_key = current_key?.next
        }
        return nil
    }
    
    private func make_MRU(thisKey: Key<K, V>) {
        MRUKey?.prev = thisKey
        thisKey.prev = nil
        thisKey.next = MRUKey
        MRUKey = thisKey
    }
}
