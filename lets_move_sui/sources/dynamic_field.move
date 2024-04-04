#[allow(unused_field, unused_variable, unused_use)]
module lets_move_sui::dynamic_field {
    use sui::dynamic_field;
    // use sui::object::{Self,UID};
    use std::string::{Self,String};
    // use sui::tx_context::TxContext;
    // use sui::transfer;
    use sui::dynamic_object_field;

    public struct Laptop has key {
        id: UID,
        screen_size: u64, 
        model: u64,
    }

    public struct StickerName has copy, drop, store {
        name: String,
    }
    public struct Sticker has key, store {
        id: UID,
        image_url: String,
    }
    public fun add_attribute(laptop: &mut Laptop, name: String, value: u64) {
        dynamic_field::add(&mut laptop.id, name, value);
    }
    public fun add_sticker(laptop: &mut Laptop, name: String, image_url: String, ctx: &mut TxContext) {
        let sticker_name = StickerName {name};
        let sticker = Sticker {
            id: object::new(ctx),
            image_url};
        // dynamic_field::add(&mut laptop.id, sticker_name, sticker);
        dynamic_field::add(&mut laptop.id,sticker_name, sticker);
        // let _ = string::utf8(b"added sticker");
    }

    public fun read_image_url(laptop: &Laptop, name: String): String {
        let sticker_name = StickerName {name};
        let sticker_reference: &Sticker = dynamic_field::borrow(&laptop.id, sticker_name);
        sticker_reference.image_url
    }

    public fun set_image_url(laptop: &mut Laptop, name: String, new_url: String) {
        let sticker_name = StickerName {name};
        let sticker_mut_reference: &mut Sticker = dynamic_field::borrow_mut(&mut laptop.id, sticker_name);
        sticker_mut_reference.image_url = new_url;
    }

    public fun remove_sticker(laptop: &mut Laptop, name: String) {
        let sticker_name = StickerName {name};
        // dynamic_field::remove<StickerName, Sticker>(&mut laptop.id, sticker_name);
        let sticker = dynamic_field::remove(&mut laptop.id, sticker_name);
        let Sticker {
            id,
            image_url: _,
        } = sticker;
        object::delete(id);
    }

    // a example to manage contracts states
    // public struct PriceConfigs has key {
    //     id: UID,
    //     price_range: vector<u64>,
    // }

    // public struct StoreHours has key {
    //     id: UID,
    //     open_hours: vector<vector<u8>>,
    // }

    // public struct SpecConfigs has key {
    //     id: UID,
    //     specs_range: vector<u64>,
    // }

    // fun init(ctx: &mut TxContext) {
    //     let price_configs = PriceConfigs {
    //         id: object::new(ctx),
    //         price_range: vector[1000, 5000],
    //     };
    //     let store_hours = StoreHours {
    //         id: object::new(ctx),
    //         open_hours: vector[vector[9, 12], vector[1, 5]],
    //     };
    //     let spec_configs = SpecConfigs {
    //         id: object::new(ctx),
    //         specs_range: vector[1000, 10000],
    //     };
    //     transfer::share_object(price_configs);
    //     transfer::share_object(store_hours);
    //     transfer::share_object(spec_configs);
    // }

    // // Too long
    // public fun purchase_laptop(price_configs: &PriceConfigs, store_hours: &SotreHours, spec_configs: &SpecConfigs, laptop: String, price: u64, ctx: &mut TxContext) {

    // }

    public struct StateConfigs has key {
        id: UID,
    }

    const PRICE_CONFIGS: vector<u8> = b"PRICE_CONFIGS";
    public struct PriceConfigs has store {
        price_range: vector<u64>,
    }

    const STORE_HOURS: vector<u8> = b"STORE_HOURS";
    public struct StoreHours has store {
        open_hours: vector<vector<u8>>,
    }

    const SPEC_CONFIGS: vector<u8> = b"SPEC_CONFIGS";
    public struct SpecConfigs has store {
        specs_range: vector<u64>,
    }

    fun init(ctx: &mut TxContext) {
        let mut state_configs = StateConfigs {
            id: object::new(ctx),
        };
        dynamic_field::add(&mut state_configs.id, PRICE_CONFIGS, PriceConfigs {
            price_range: vector[1000, 5000],
        });
        dynamic_field::add(&mut state_configs.id, STORE_HOURS, StoreHours {
            open_hours: vector[vector[9, 12], vector[1, 5]],
        });
        dynamic_field::add(&mut state_configs.id, SPEC_CONFIGS, SpecConfigs {
            specs_range: vector[1000, 10000],
        });
        transfer::share_object(state_configs);
    }

    public fun purchase_laptop(
        state_configs: &StateConfigs, 
        laptop: String, price: u64, 
        ctx: &mut TxContext,
        ) {

    }

    const EXTENSION_1: u64 = 1;
    public struct PurchaseDetails has store {
        customer_name: String,
        street_address: String,
        price: u64,
    }
    public fun add_purchase_details(
        laptop: &mut Laptop, 
        customer_name: String, 
        street_address: String, 
        price: u64
        ) {
        dynamic_field::add(&mut laptop.id, EXTENSION_1, PurchaseDetails {
            customer_name,
            street_address,
            price,
        });
    }

    // We can also use the same pattern to augment an object that has been added as a dynamic object field on another object as well
    public struct StickerPurchaseDetails has store {
        customer_name: String,
        street_address: String,
        price: u64,
    }

    public fun add_sticker_purchase_details(
        laptop: &mut Laptop, 
        sticker_name: String, 
        customer_name: String, 
        street_address: String, 
        price: u64
        ) {
        let sticker: &mut Sticker = dynamic_object_field::borrow_mut(&mut laptop.id, sticker_name);
        dynamic_field::add(&mut sticker.id, EXTENSION_1, StickerPurchaseDetails {
            customer_name,
            street_address,
            price,
        });
    }
}