// System object: Clock
// Two common scenarios:
// 1. get the timestamp for record keeping or emitting events
// 2. generate a pseudo-random number
module lets_move_sui::clock_object {
    use sui::clock::{Self, Clock};
    use sui::event;

    public struct TimeEvent has copy, drop {
        timestamp_ms: u64,
    }
    public entry fun get_time(clock: &Clock) {
        let timestamp_ms = clock::timestamp_ms(clock);
        event::emit(TimeEvent{
            timestamp_ms,
        })
    }

    entry fun flip_coin(clock: &Clock): u64 {
        let timestamp_ms = clock::timestamp_ms(clock);
        timestamp_ms % 2
    }
}