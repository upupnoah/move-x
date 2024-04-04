module lets_move_sui::ticket_module {
    use sui::clock::{Self, Clock};
    // use sui::object::{Self, ID, UID};
    // use sui::transfer;
    // use sui::tx_context::{Self, TxContext};
    use sui::event;

    public struct Ticket has key{
        id: UID,
        expiration_time: u64,
    }

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