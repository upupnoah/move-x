module lets_move_sui::color {
    // use sui::transfer;
    // use sui::object::{Self, UID};
    // use sui::tx_context::TxContext;
    public struct ColorObject has key {
        id: UID,
        red: u8,
        green: u8,
        blue: u8,
    }

    public entry fun freeze_owned_object(object:ColorObject) {
        transfer::freeze_object(object)
    }

    public entry fun create_immutable(red: u8, green: u8, blue: u8, ctx: &mut TxContext) {
        let color_object = ColorObject {
            id: object::new(ctx),
            red,
            green,
            blue,
        };
        transfer::freeze_object(color_object);
    }
}