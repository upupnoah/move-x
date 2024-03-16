#[allow(unused_variable, unused_function, unused_mut_parameter)]
module lets_move_sui::noah {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::vector;

    public struct Noah has key {
        id: UID,
        generation: u64,
        birthdate: u64,
    }

    public fun create_noah(ctx: &mut TxContext){
        let noah = Noah {
            id: object::new(ctx),
            generation: 0,
            birthdate: 0,
        };
        transfer::transfer(noah, tx_context::sender(ctx));
    }

    fun noah_test(ctx: &mut TxContext) {
        let mut values = vector[1, 2, 3, 4, 5];
        // modify the vector
        let third_element =vector::borrow_mut(&mut values, 2);
        *third_element = 100;
    }
}