class_name EventScheduler
extends Reference

                                    # TODO: Add to game settings
var _slot_size: int = 7             # Size for each event slot. Values in range [1:7]
var _event_queue: Array = []        # If several events should be triggered during one week, they get into the queue and be called on the next slot start
var _event_pool: Array = []         # Pool of all available events for the scenario

signal event_started(event)


func populate_event_pool(events: Array):
    assert(len(events) > 0, "Events array is empty")
    assert(events[0] is Dictionary, "Event pool expects events in the form of Dictionary")

    for event in events:
        _event_pool.append(event)


func check_day_for_events(day):
    if (day % _slot_size == 0):
        _start_event_slot()


func reset():
    _event_queue.clear()
    _event_pool.clear()


func _start_event_slot():
    _check_events()

    if (len(_event_queue) == 0):
        return
    var event = _event_queue.pop_front()
    emit_signal("event_started", event)


func _check_events():
    var remove_pool: Array = []
    for event in _event_pool:
        if (!_check_event_condition(event)):
            continue
        _event_queue.push_back(event)
        remove_pool.append(event)

    for event in remove_pool:
        _event_pool.remove(event)
        

func _check_event_condition(event) -> bool:
    return event["Predicate"].evaluate()
