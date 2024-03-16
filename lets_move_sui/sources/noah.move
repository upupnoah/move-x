module lets_move_sui::noah {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
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
}