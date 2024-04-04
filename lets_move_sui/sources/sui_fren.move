module lets_move_sui::sui_fren {
    // use sui::tx_context::{Self, TxContext};
    // use sui::transfer;
    // use sui::object::{Self};
    use std::string::String;
    // use std::vector; // built-in
    use sui::event;

    public struct AdminCap has key {
        id: UID,
        num_frens: u64,
    }

    public struct SuiFren has key {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    public struct MintEvent has copy, drop {
        id: ID,
    }
    public struct BurnEvent has copy, drop {
        id: ID,
    }

    fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx),
            num_frens: 10^3, // 1000
        };
        transfer::share_object(admin_cap);
    }

    // public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext): SuiFren {
    //     SuiFren {
    //         id: object::new(ctx),
    //         generation,
    //         birthdate,
    //         attributes,
    //     }
    // }
    
    // change the mint function to transfer the object to the sender
    public fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let uid = object::new(ctx);
        let id = object::uid_to_inner(&uid);
        let sui_fren = SuiFren {
            id: uid,
            generation,
            birthdate,
            attributes,
        };
        transfer::transfer(sui_fren, tx_context::sender(ctx));
        event::emit(MintEvent {
            id,
        });
    }

    public fun burn(sui_fren: SuiFren) {
        let SuiFren {
            id,
            generation: _,
            birthdate: _,
            attributes: _,
        } = sui_fren;
        event::emit(BurnEvent {
            id: object::uid_to_inner(&id),
        });
        object::delete(id);
    }
    
    public fun get_attributes(sui_fren: &SuiFren): vector<String> {
        sui_fren.attributes
    }

    public fun update_attributes(sui_fren: &mut SuiFren, attributes: vector<String>) {
        sui_fren.attributes = attributes;
    }
}
