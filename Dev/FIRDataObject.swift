import Firebase

class FIRDataObject: NSObject {
    
    let snapshot: FIRDataSnapshot
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    
    required init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
        for child in (snapshot.children.allObjects as? [FIRDataSnapshot])! {
                if responds(to: Selector(child.key)){
                    setValue(child.value, forKey: child.key)
                }
        }
    }
}

protocol FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference { get }
}

extension FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
}
