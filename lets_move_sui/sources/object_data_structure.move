#[allow(unused_field, lint(self_transfer), unused_variable, unused_const, unused_use)]
module lets_move_sui::object_data_structure {
    use sui::object::{Self, UID};
    use sui::object_bag::{Self, ObjectBag};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{Self, String};
    use sui::object_table::{Self, ObjectTable};

    public struct SuiFren has key, store {
        id: UID,
        generation: u64,
        birthdate: u64,
        attributes: vector<String>,
    }

    // always 5 inner
    public struct GiftBox_inner has key {
        id: UID,
        inner_1: SuiFren,
        inner_2: SuiFren,
        inner_3: SuiFren,
        inner_4: SuiFren,
        inner_5: SuiFren,
    }

    // always same type of inner
    public struct GitBoxVector has key {
        id: UID,
        frens: vector<SuiFren>,
    }

    // ObjectBag
    public struct MyBag has key {
        id: UID,
        object_bag: ObjectBag,
    }

    public fun create_bag(ctx: &mut TxContext) {
        transfer::transfer(
            MyBag {
            id: object::new(ctx),
            object_bag: object_bag::new(ctx),
        }, 
    tx_context::sender(ctx));
    }

    public fun add_to_bag<SomeObject: key + store>(my_bag: &mut MyBag, key: String, object: SomeObject) {
        object_bag::add(&mut my_bag.object_bag, key, object);
    }

    // ObjectTable
    public struct MyObject has key, store {
        id: UID,
    }
    public struct MyTable has key {
        id: UID,
        table: ObjectTable<String, MyObject>,
    }

    public fun create_table(ctx: &mut TxContext) {
        let my_table = MyTable {
            id: object::new(ctx),
            table: object_table::new(ctx),
        };
        transfer::transfer(my_table, tx_context::sender(ctx));
    }

    public fun add_to_table(my_table: &mut MyTable, key: String, object: MyObject) {
        object_table::add(&mut my_table.table, key, object);
    }
}