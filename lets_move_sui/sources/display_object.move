#[allow(unused_field)]
module lets_move_sui::display_object {
    use sui::object::{UID};
    use std::string::{String, utf8};
    use sui::tx_context::TxContext;
    use sui::package::Publisher;
    use sui::display;

    public struct MyObject has key {
        id: UID,
        num_value: u64,
        strign_value: String,
    }
    public fun create_display_object(publisher: &Publisher, ctx: &mut TxContext): display::Display<MyObject>{
        let mut display_object = display::new<MyObject>(publisher, ctx);
        display::add_multiple(
        &mut display_object,
        vector[
                utf8(b"num_value"),
                utf8(b"string_value"),
            ],
        vector[
                utf8(b"Value: {nums_value}"),
                utf8(b"Description: {string_value}"),
            ],
        );
        display::update_version(&mut display_object);
        display_object
    }
}