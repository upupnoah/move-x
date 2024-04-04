// Note: like rust, its based on module, not file
//       you can have multiple modules in a file

#[allow(unused_field, lint(self_transfer), duplicate_alias)]
module lets_move_sui::sui_fren_v2 {
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{TxContext};
    use sui::event;
    use sui::transfer;
    use sui::types;
    use sui::package::{Self, Publisher};
    use sui::display;
    use std::string::{String, utf8};

    // friends
    // friend lets_move_sui::fren_summer;

    // Store ability allows a struct to be part of other structs. 
    public struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    public struct MintEvent has copy, drop {
        id: ID,
    }

    public(package) fun mint(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext): SuiFren {
        let uid = object::new(ctx);
        let id = object::uid_to_inner(&uid);
        let sui_fren = SuiFren {
            id: uid,
            generation,
            birthdate,
            attributes,
        };
        // transfer::transfer(sui_fren, tx_context::sender(ctx));
        event::emit(MintEvent {
            id,
        });
        // Recommended return object, enhanced composability.
        sui_fren
    }

    public(package) fun create(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext): SuiFren {
        SuiFren {
            id: object::new(ctx),
            generation,
            birthdate,
            attributes,
        }
    }

    public struct GiftBox has key {
        id: UID,
        inner: SuiFren,
        candies: vector<Candy>,
    }

    public struct Candy has store, drop {
        value: u64,
    }

    // witness and publisher_object
    public struct SUI_FREN_V2 has drop {}

    const ENotOneTimeWitness: u64 = 0;

    
    fun init(witness: SUI_FREN_V2, ctx: &mut TxContext) {
        assert!(types::is_one_time_witness(&witness), ENotOneTimeWitness);
        let publisher_object = package::claim(witness, ctx);
        transfer::public_transfer(publisher_object, tx_context::sender(ctx));
    }

    public fun add_display(publisher: &Publisher, ctx: &mut TxContext) {
        let mut display_object = display::new<SuiFren>(publisher, ctx);
        display::add_multiple(
            &mut display_object,
            vector[
                utf8(b"id"),
                utf8(b"generation"),
                utf8(b"birthdate"),
                utf8(b"attributes"),
            ],
            vector[
                utf8(b"id: {id}"),
                utf8(b"generation: {generation}"),
                utf8(b"birthdate: {birthdate}"),
                utf8(b"all attributes: {attributes}"),
            ]
        );
        display::update_version(&mut display_object);
        transfer::public_transfer(display_object, tx_context::sender(ctx));
    }

}

module lets_move_sui::fren_summer {
    use std::string::String;
    // use sui::tx_context::{Self, TxContext};
    // use sui::object::{UID};
    // use sui::transfer;

    // use other module
    use lets_move_sui::sui_fren_v2::{Self, SuiFren, Candy};

    public struct GiftBox has key {
        id: UID,
        inner: SuiFren,
        candies: vector<Candy>,
    }

    // public fun open_box(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
    //     sui_fren_v2::mint(generation, birthdate, attributes, ctx);
    // }

    entry fun open_box(gift_box: GiftBox, ctx: &TxContext) {
        let GiftBox {
            id, 
            inner, 
            candies: _,
        } = gift_box;
        object::delete(id);
        transfer::public_transfer(inner, tx_context::sender(ctx));
    }

    entry fun create_gift(generation: u64, birthdate: u64, attributes: vector<String>, ctx: &mut TxContext) {
        let fren = sui_fren_v2::create(generation, birthdate, attributes, ctx);
        let gift_box = GiftBox {
            id: object::new(ctx),
            inner: fren,
            candies: vector[],
        };
        transfer::transfer(gift_box, tx_context::sender(ctx));
    }

    entry fun wrap_fren(fren: SuiFren, ctx: &mut TxContext) {
        let gift_box = GiftBox {
            id: object::new(ctx),
            inner: fren,
            candies: vector[],
        };
        transfer::transfer(gift_box, tx_context::sender(ctx));
    }

    // Create gifts, there is a weekly quantity limit.
    public struct GiftWeekConfig has key {
        id: UID,
        limit: u64,
    }

    entry fun create_week(limit: u64, ctx: &mut TxContext) {
        let gift_week_config = GiftWeekConfig {
            id: object::new(ctx),
            limit,
        };
        transfer::freeze_object(gift_week_config);
    }
}