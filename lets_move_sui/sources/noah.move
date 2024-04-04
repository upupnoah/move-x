#[allow(unused_variable, unused_function, unused_mut_parameter, unused_field, unused_assignment, unused_use)]
module lets_move_sui::noah {
    // use sui::object::{Self, UID};
    // use sui::tx_context::{Self, TxContext};
    // use sui::transfer;
    // use std::vector;
    use std::string::{String, utf8};

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

    public fun noah_test(ctx: &mut TxContext) {
        let mut values = vector[1, 2, 3, 4, 5];
        // modify the vector
        let third_element =vector::borrow_mut(&mut values, 2);
        *third_element = 100;
    }

    public struct NestedStruct has store {
        value: u64,
        doubleNested: DoubleNestedStruct,
    }

    public struct DoubleNestedStruct has store {
        value: u64,
    }

    public struct Container has key {
        id: UID,
        nested: NestedStruct,
    }

    public struct Field1 has key {
        id: UID,
    }
    public struct Demo {
        field1: Field1,
    }

    public struct A has key, store {
        id: UID,
        name: String,
    }

    // public struct B has key {
    //     id: UID,
    //     a: A,
    // }

    public fun delete_id(ctx: &mut TxContext) {
        // let A {
        //     id,
        //     name,
        // } = aObject;
        // let mut a =  A {
        //     id: object::new(ctx),
        //     name: utf8(b"hello"),
        // };
        // object::delete(a.id);
    }
}