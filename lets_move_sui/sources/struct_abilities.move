// Note:
// 1. if a structure has the ability to key, then it cannot have the ability to copy
// 2. It's very important to remember that a struct can only have an ability if ALL of its fields have the same ability

#[allow(unused_field, unused_assignment, unused_variable)]
module lets_move_sui::struct_abilities {

    // key:  can be used as a unique identifier for records or objects
    // with the ability of a key, this structure is an object
    public struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }
    // Store ability allows a struct to be part of other structs. 
    public struct NestedStruct has store {
        value: u64,
        doubleNested: DoubleNestedStruct,
    }

    public struct DoubleNestedStruct has store {
        value: u64,
    }
    public struct Container has key {
        id: UID,
        nested: NestedStruct,
    }

    // Copy ability allows a struct to be "copied", which creates an instance of the struct with the same exact field values.
    public struct CopyableStruct has copy, drop {
        value: u64,
    }

    public fun struct_copy(mut original: CopyableStruct) {
        let mut original_copy = original;
        original.value = 1;
        original_copy.value = 2;
        // We now have two CopyableStructs with two different values.
    }

    // Drop ability allows a struct to be implicitly destroyed at the end of a function without having to "destruct"
    public struct HasDrop has drop {}
    public struct DroppableStruct has drop {
        value: u64,
        hasDrop: HasDrop,
    }

    public fun dropable() {
        let droppable = DroppableStruct { 
            value: 1,
            hasDrop: HasDrop {},
        };
        // At the end of this function, droppable would be destroyed.
        // We don't need to explicitly destruct:
        // let DroppableStruct { value: _ } = droppable;
    }
}