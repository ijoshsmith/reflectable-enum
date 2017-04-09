
/// Adopted by an enum where each case has
/// an associated struct with similar properties.
protocol ReflectableEnum {
    func value<Value>(of propertyName: String) -> Value
}

extension ReflectableEnum {
    func value<Value>(of propertyName: String) -> Value {
        let selfMirror = Mirror(reflecting: self)
        let structChild = selfMirror.children.first!
        let structMirror = Mirror(reflecting: structChild.value)
        let property = structMirror.children.first {
            return $0.label == propertyName
        }
        let value: Any = property!.value
        return value as! Value
    }
}

enum Contact: ReflectableEnum {
    case addressBookContact(AddressBookContact)
    case faceBookContact(FaceBookContact)
    
    var id:   String { return value(of: #function) }
    var name: String { return value(of: #function) }
}

struct AddressBookContact {
    let id: String
    let name: String
    let phoneNumber: String
}

struct FaceBookContact {
    let id: String
    let name: String
    let username: String
}

let bob = AddressBookContact(
    id: "c1",
    name: "Bob",
    phoneNumber: "5558675309")

let tom = FaceBookContact(
    id: "c2",
    name: "Tom",
    username: "tommyboy")

let contacts = [Contact.addressBookContact(bob),
                Contact.faceBookContact(tom)]

contacts.forEach { print($0.id + " " + $0.name) }
