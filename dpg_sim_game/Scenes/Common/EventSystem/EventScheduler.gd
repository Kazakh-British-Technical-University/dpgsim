class_name EventScheduler

var _slot_size: int = 7             # Size for each event slot. Values in range [1:7]
var _event_queue: Array = []        # If several events should be triggered during one week, they get into the queue and be called on the next slot start
var _event_pool: Array = []         # Pool of all available events for the scenario

var _main_session: MainSession


func _init(main_session: MainSession):
    _main_session = main_session


func populate_event_pool(events: Array):
    assert(len(events) > 0, "Events array is empty")
    assert(events[0] is Dictionary, "Event pool expects events in the form of Dictionary")

    for event in events:
        _event_pool.append(event)


func check_events():
    var remove_pool: Array = []
    for event in _event_pool:
        if (!check_event_condition(event)):
            continue
        _event_queue.append(event)
        remove_pool.append(event)

    for event in remove_pool:
        _event_pool.remove(event)
        


func check_event_condition(event) -> bool:
    return event["Predicate"].evaluate()
