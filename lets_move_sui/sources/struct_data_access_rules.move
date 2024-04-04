// Note: In Move, only the modules that define a struct can freely access its fields.
// If other modules need to access a field, it'd need to do so through the original module's getter function:

#[allow(unused_use)]
module lets_move_sui::a {
    // use sui::object::{Self, UID};
    public struct MyData has key {
        id: UID,
        value: u64,
    }

    // this works
    public fun get_value_from_reference(object: &MyData): u64 {
        object.value
    }

    // this works
    public fun get_value_from_mut_reference(object: &mut MyData): u64 {
        object.value
    }
}

#[allow(unused_use)]
module lets_move_sui::b {
    use lets_move_sui::a::MyData;

    // This doesn't work
    // public fun get_value(object: &MyData): u64 {
    //     object.value
    // }
}