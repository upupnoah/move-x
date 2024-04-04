// PTB: programing transaction block
// On Sui Network, PTB allows you to define a set of transactions as a single unit of work. (atomic)

#[allow(duplicate_alias)]
module lets_move_sui::ticket_module_v2 {
    use sui::clock::{Self, Clock};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    public struct Ticket has key {
        id: UID,
        expiration_time: u64,
    }
    
    public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
        let uid = object::new(ctx);
        let ticket = Ticket {
            id: uid,
            expiration_time: clock::timestamp_ms(clock),
        };
        transfer::transfer(ticket, tx_context::sender(ctx));
    }


    // private entry fun 
    // As part of the transaction, it cannot be called in other modules.)
    entry fun clip_ticket(ticket: Ticket) {
        let Ticket {
            id,
            expiration_time: _,
        } = ticket;
        object::delete(id);
    }

    public fun is_expired(ticket: &Ticket, clock: &Clock): bool {
        ticket.expiration_time <= clock::timestamp_ms(clock)
    }

}