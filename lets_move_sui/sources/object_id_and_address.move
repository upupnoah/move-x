#[allow(unused_field, lint(self_transfer), unused_variable, unused_const, unused_use)]
module lets_move_sui::object_id_and_address {
    use sui::object::{Self,UID, ID};
    use sui::address;
    use sui::tx_context::{Self, TxContext};
    use sui::bcs;
    public struct MyObject has key, store {
        id: UID,
    }
    public fun get_object_id_from_address(object_addr: address): ID {
        object::id_from_address(object_addr)
    }

    public fun get_object_address(object: &MyObject): address {
        object::uid_to_address(&object.id)
    }

    // object::new function
    // public fun new(ctx: &mut TxContext): UID {
    //     UID {
    //         id: ID {
    //             bytes: tx_context::fresh_object_address(ctx),
    //         },
    //     }
    // }

    // This can be used as a general source of random values based on usage, but there is potential danger in using it because users may tamper with it.
    // Even generating random numbers using a Clock object is not secure, as the validator can set the timestamp of the Clock object to a value within a small range.
    public fun get_random_value(ctx: &mut TxContext): u64 {
        let object_id = object::new(ctx);
        let bytes = object::uid_to_bytes(&object_id);
        let random_number = bcs::peel_u64(&mut bcs::new(bytes));
        object::delete(object_id);
        random_number
    }
}