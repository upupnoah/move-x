#[allow(unused_field, lint(self_transfer), unused_variable, unused_const, unused_use, duplicate_alias)]
module lets_move_sui::sui_fren_v3 {
    use sui::dynamic_field::{Self};
    use sui::dynamic_object_field::{Self};
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{TxContext};
    use sui::event;
    use std::string::{Self, String};
    use sui::transfer::{Self, Receiving};
    use sui::object_bag::{Self, ObjectBag};
    use sui::bcs;

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

    // Hat

    const HAT_KEY: vector<u8> = b"HAT";

    public struct Hat has key, store {
        id: UID,
        color: String,
    }

    public fun color_hat(sui_fren: &mut SuiFren, color: String, ctx: &mut TxContext) {
        // if (dynamic_object_field::exists_(&sui_fren.id, string::utf8(HAT_KEY))) {
        //     let hat: &mut Hat = dynamic_field::borrow_mut(&mut sui_fren.id, string::utf8(HAT_KEY));
        //     hat.color = color;
        // } else {
        //     let hat = Hat {
        //         id: object::new(ctx),
        //         color,
        //     };
        //     dynamic_object_field::add(&mut sui_fren.id, string::utf8(HAT_KEY), hat);
        // }

        // transfer ownership to object
        let hat = Hat {
            id: object::new(ctx),
            color,
        };
        transfer::transfer(hat, object::uid_to_address(&sui_fren.id))
    }

    public fun update_hat_color(sui_fren: &mut SuiFren, hat: Receiving<Hat>, color: String, ctx: &mut TxContext) {
        let mut hat = transfer::receive(&mut sui_fren.id, hat);
        hat.color = color;
        transfer::transfer(hat, object::uid_to_address(&sui_fren.id));
    }

    // ExtendHat
    const EXTENSION_1: u64 = 1;

    public struct HatExtension1 has store {
        description: String,
        duration: u64,
    }

    public fun extend_hat(sui_fren: &mut SuiFren, description: String, duration: u64) {
        if (dynamic_object_field::exists_(&sui_fren.id, string::utf8(HAT_KEY))) {
            let hat: &mut Hat = dynamic_field::borrow_mut(&mut sui_fren.id, string::utf8(HAT_KEY));
            dynamic_field::add(&mut hat.id, EXTENSION_1, HatExtension1 {
                description,
                duration,
            });
        };
    }

    public struct SuiFrenV1 has key{
        id: UID,
        power: u64,
    }
    public(package) fun create_random(ctx: &mut TxContext): SuiFrenV1 {
        let object_id = object::new(ctx);
        let bytes = object::uid_to_bytes(&object_id);
        let power = bcs::peel_u64(&mut bcs::new(bytes));
        SuiFrenV1 {
            id: object_id,
            power,
        }
    }
}

#[allow(unused_field, lint(self_transfer), unused_variable, unused_const, unused_use, duplicate_alias)]
module lets_move_sui::fren_summer_v3 {
    use sui::object::{Self, UID};
    use lets_move_sui::sui_fren_v3::{Self, SuiFren, Hat};
    use sui::tx_context::{Self, TxContext};
    use sui::object_table::{Self, ObjectTable};
    use std::string::{Self, String};

    // Update
    public struct GiftBox has key {
        id: UID,
        // object_bag: ObjectBag,
        sui_frens: ObjectTable<u64, SuiFren>,
        hats: ObjectTable<u64, Hat>,
    }

    public fun create_gift_box(ctx: &mut TxContext): GiftBox {
        GiftBox {
            id: object::new(ctx),
            // object_bag: object_bag::new(),
            sui_frens: object_table::new(ctx),
            hats: object_table::new(ctx),
        }
    }

    entry fun wrap_fren(gift_box: &mut GiftBox, fren: SuiFren) {
        // let index = object_bag::length(&gift_box.object_bag);
        // object_bag::add(&mut gift_box.object_bag, index, fren);
        let index = object_table::length(&gift_box.sui_frens);
        object_table::add(&mut gift_box.sui_frens, index, fren);
    }

    entry fun wrap_hat(gift_box: &mut GiftBox, hat: Hat) {
        let index = object_table::length(&gift_box.hats);
        object_table::add(&mut gift_box.hats, index, hat);
    }
}
