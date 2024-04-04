// Note: tx_context
// 1. epoch_timestamp_ms  fresh_object_address
// 2. tx_context::sender(ctx) -> transaction sender
// don't use as authentication or proof of user's direct intention to call this function
module lets_move_sui::txcontext_object {
    // use sui::object::{Self,UID};
    // use sui::tx_context::{Self, TxContext};

    public struct MyObject has key {
        id: UID,
        value_1: u64,
        value_2: u64,
    }

    public fun create_object(value_1: u64, value_2: u64, ctx: &mut TxContext) {
        let object = MyObject {
            id: object::new(ctx),
            value_1,
            value_2,
        };
        transfer::transfer(object, tx_context::sender(ctx));
    }
}

#[allow(unused_variable, unused_mut_parameter)]
module lets_move_sui::safe_module {
    const ENOT_AUTHORIZED:u64 = 0;
    // friend lets_move_sui::malicious_module;
    public(package) fun claim_rewards(amount: u64, receiver: address, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == @0x12345, ENOT_AUTHORIZED);
        // Send the amount of rewards to the receiver address
    }
}

// claim airdrop rewards to a malicious developer(!!!! dangerous)
module lets_move_sui::malicious_module {
    use lets_move_sui::safe_module;
    const MALICIOUS_DEVELOPER: address = @0x98765;

    public fun airdrop(ctx: &mut TxContext) {
        safe_module::claim_rewards(1000, MALICIOUS_DEVELOPER, ctx);
    }
}