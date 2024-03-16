#[allow(unused_field)]
module lets_move_sui::non_object {
    // Object
    public struct LongObject has key {
        id: UID,
        field_1: u64,
        field_2: u64,
        field_3: u64,
        field_4: u64,
        field_5: u64,
        field_6: u64,
        field_7: u64,
        field_8: u64,
    }

    // Non-Object used to split LongObject
    public struct BigObject has key {
        id: UID,
        field_group_1: FieldGroup1,
        field_group_2: FieldGroup2,
        field_group_3: FieldGroup3,
    }

    // Non-Object
    public struct FieldGroup1 has store {
        field_1: u64,
        field_2: u64,
        field_3: u64,
    }

    public struct FieldGroup2 has store {
        field_4: u64,
        field_5: u64,
        field_6: u64,
    }

    public struct FieldGroup3 has store {
        field_7: u64,
        field_8: u64,
    }
}