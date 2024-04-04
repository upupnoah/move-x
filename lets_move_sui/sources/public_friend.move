// Note: The function declared as public(friend) 
// can only be used by the friend module in the same package.

// To use the public (friend) function, you need to first use the corresponding module.
module lets_move_sui::my_other_module {
    use lets_move_sui::my_module;

    public fun do_it(x: u64): bool {
        my_module::friend_only_equal(x)
    }
}

// To allow other modules to use the public (friend) defined by oneself, 
// you need to declare the module name using the friend keyword.
module lets_move_sui::my_module {
    // friend lets_move_sui::my_other_module;

    public(package) fun friend_only_equal(x: u64): bool {
        x == 1000
    }
}