module lets_move_sui::ticket_module {
    use sui::clock::{Self, Clock};
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    public struct Ticket has key {
        id: UID,
        expiration_time: u64,
    }

    // public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
    //     let ticket = Ticket {
    //         id: object::new(ctx),
    //         expiration_time: clock::timestamp_ms(clock),
    //     };
    //     // An owned object is created and owned by the sender of this transaction.
    //     // tx_context::sender(ctx) returns the address of the user who sends this transaction.
    //     transfer::transfer(ticket, tx_context::sender(ctx));
    //     // transfer::share_object(ticket);
    // }

    // public fun clip_ticket(ticket: Ticket) {
    //     let Ticket {
    //         id,
    //         expiration_time: _,
    //     } = ticket;
    //     object::delete(id);
    // }

    // event
    public struct CreateTicketEvent has copy, drop {
        id: ID,
    }

    public struct ClipTicketEvent has copy, drop {
        id: ID,
    }
    
    public fun create_ticket(ctx: &mut TxContext, clock: &Clock) {
        let uid = object::new(ctx);
        let id = object::uid_to_inner(&uid);
        let ticket = Ticket {
            id: uid,
            expiration_time: clock::timestamp_ms(clock),
        };
        transfer::transfer(ticket, tx_context::sender(ctx));
        event::emit(CreateTicketEvent {
            id,
        });
    }

    public fun clip_ticket(ticket: Ticket) {
        let Ticket {
            id,
            expiration_time: _,
        } = ticket;

        event::emit(ClipTicketEvent {
            id: object::uid_to_inner(&id),
        });
        object::delete(id);
    }



    public fun is_expired(ticket: &Ticket, clock: &Clock): bool {
        ticket.expiration_time <= clock::timestamp_ms(clock)
    }


}