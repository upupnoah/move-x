module starchain_poap::poap {

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    //attributes: key, store, copy, drop
    // in sui, if has key, need to give a id
    
    // cannot give copy, because of UID
    struct StarchainPOAP has key {
        id: UID,
    }

    // Cap is the mint Capability of the POAP
    // key means Have, each field in the struct should has store ability
    // store means can transfer to other people
    struct MintCap has key, store {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        let mint_cap = MintCap {
            id: object::new(ctx),
        };

        // deployer is the sender of the transaction
        // the people who deploy the contract and call the init function
        let deployer = tx_context::sender(ctx);
        transfer::transfer(mint_cap, deployer);
    }

    public fun new_poap(
        _cap: &MintCap, 
        ctx: &mut TxContext
        ): StarchainPOAP {
        StarchainPOAP {
            id: object::new(ctx)
        }
    }

    entry fun create_poap(
        cap: &MintCap, 
        to: address,  
        ctx: &mut TxContext
        ) {
        let poap = new_poap(cap, ctx);
        transfer::transfer(poap, to);
    }

    entry fun create_mint_cap(
        _: &MintCap, 
        to: address, 
        ctx: &mut TxContext
        ) {
        let mint_cap = MintCap {
            id: object::new(ctx),
        };
        transfer::transfer(mint_cap, to);
    }
}