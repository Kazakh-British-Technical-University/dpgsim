class_name EventPredicateFactory

enum PredicateType {
    TIME,
    ACTION,
    MONEY,
    FIT_POINTS,
    INCONSISTENCY_POINTS,
    DEV_POINTS,
    TECH_DEPT_POINTS,
    MARKET_POINTS,
    REJECTION_POINTS,
    TEAM_SIZE,
    SESSION_STAGE,
    EVENT
}


var _main_session: MainSession
var _event_manager: EventManager
var _team_screen: TeamScreen
var _money_node: Money
var _fit_points: PointCounter
var _dev_points: PointCounter
var _market_points: PointCounter


func _init(
    main_session: MainSession,
    event_manager: EventManager, 
    team_screen: TeamScreen, 
    money_node: Money,
    fit_points: PointCounter,
    dev_points: PointCounter,
    market_points: PointCounter):

    _main_session = main_session
    _event_manager = event_manager
    _team_screen = team_screen
    _money_node = money_node
    _fit_points = fit_points
    _dev_points = dev_points
    _market_points = market_points


## Returns appropriate predicate (condition) given type and parameters
func create_predicate(predicate_type: int, parameter: String) -> EventPredicate:
    match predicate_type:

        PredicateType.TIME:
            return TimePredicate.new(parameter.to_int(), _main_session)

        PredicateType.ACTION:
            assert(false, "Not implemented")
            return null

        PredicateType.MONEY:
            return MoneyPredicate.new(parameter.to_int(), _money_node)

        PredicateType.FIT_POINTS:
            return GoodPointsPredicate.new(parameter.to_int(), _fit_points)

        PredicateType.INCONSISTENCY_POINTS:
            return BadPointsPredicate.new(parameter.to_int(), _fit_points)

        PredicateType.DEV_POINTS:
            return GoodPointsPredicate.new(parameter.to_int(), _dev_points)

        PredicateType.TECH_DEPT_POINTS:
            return BadPointsPredicate.new(parameter.to_int(), _dev_points)

        PredicateType.MARKET_POINTS:
            return GoodPointsPredicate.new(parameter.to_int(), _market_points)

        PredicateType.REJECTION_POINTS:
            return BadPointsPredicate.new(parameter.to_int(), _market_points)

        PredicateType.TEAM_SIZE:
            return TeamPredicate.new(parameter.to_int(), _team_screen)

        PredicateType.SESSION_STAGE:
            return StagePredicate.new(parameter.to_int())

        PredicateType.EVENT:
            var separator = "|"
            var params = parameter.split(separator)
            return ParentEventPredicate.new(params[0].to_int(), params[1].to_int(), _event_manager, _main_session)

        _:
            assert(false, "Unsupported predicate type")
            return null
        



## Base class for all event predicates (conditions). 
class EventPredicate:

    ## Checks if event condition criterias are met
    func evaluate() -> bool:
        assert(false, "Cannot use method of an abstract class")
        return false


## Abstract. Compares the target value to particular current value (money, time, etc.)
## Override "_get_current_value()" to check for specific values
## comparison_type: define which operation to use for comparison (use ComparisonType enum from ValuePredicate)
class ValuePredicate:
    
    extends EventPredicate

    enum ComparisonType {
        EQUAL,
        GREATER,
        GREATER_OR_EQUAL,
        LESS,
        LESS_OR_EQUAL
    } 

    var _target_value: int
    var _comparison_type: int


    func _init(target_value: int, comparison_type: int):
        _target_value = target_value
        _comparison_type = comparison_type


    func evaluate() -> bool:
        return _compare(_get_current_value(), _target_value, _comparison_type)


    func _compare(a, b, comparison_type: int) -> bool:
        match comparison_type:
            ComparisonType.EQUAL:
                return a == b
            ComparisonType.GREATER:
                return a > b
            ComparisonType.GREATER_OR_EQUAL:
                return a >= b
            ComparisonType.LESS:
                return a < b
            ComparisonType.LESS_OR_EQUAL:
                return a <= b
            _:
                assert(false, "Invalid comparison type")
                return false

    
    func _get_current_value():
        assert(false, "Cannot use method of an abstract class")


## Checks for a particular week counting from the session’s start
class TimePredicate:

    extends ValuePredicate

    var _main_session: MainSession


    func _init(weeks: int, main_session: MainSession, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(weeks, comparison_type):
        _main_session = main_session
        

    func _get_current_value():
        return int(_main_session.curDays / 7)
        

## TODO: Implement this
## This trigger is for the user’s Actions
class ActionPredicate:

    extends EventPredicate


## Checks for the amount of money player have
class MoneyPredicate:

    extends ValuePredicate

    var _moneyNode: Money


    func _init(target_money: int, moneyNode: Money, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(target_money, comparison_type):
        _moneyNode = moneyNode

    
    func _get_current_value():
        return _moneyNode.total


## Checks for Good Points quantity
class GoodPointsPredicate:

    extends ValuePredicate

    var _point_counter: PointCounter


    func _init(target_points: int, point_counter: PointCounter, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(target_points, comparison_type):
        _point_counter = point_counter


    func _get_current_value():
        return _point_counter.good


## Checks for Bad Points quantity
class BadPointsPredicate:

    extends ValuePredicate

    var _point_counter: PointCounter


    func _init(target_points: int, point_counter: PointCounter, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(target_points, comparison_type):
        _point_counter = point_counter


    func _get_current_value():
        return _point_counter.bad


## Checks for total amount of crew members
class TeamPredicate:

    extends ValuePredicate

    var _team_screen: TeamScreen


    func _init(target_team_size: int, team_screen: TeamScreen, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(target_team_size, comparison_type):
        _team_screen = team_screen


    func _get_current_value():
        return _team_screen.teamSize


## Checks for a particular session stage (phase)
class StagePredicate:

    extends ValuePredicate


    func _init(target_stage: int, comparison_type: int = ComparisonType.GREATER_OR_EQUAL).(target_stage, comparison_type):
        pass


    func _get_current_value():
        return global.curPhaseIndex


## A particular event was triggered
class ParentEventPredicate:

    extends EventPredicate

    var _event_manager: EventManager
    var _main_session: MainSession
    var _parent_event_id: int
    var _delay_weeks: int

    var _is_parent_event_triggered: bool
    var _parent_event_triggered_day: int


    func _init(parent_event_id: int, delay_weeks: int, event_manager: EventManager, main_session: MainSession):
        _parent_event_id = parent_event_id
        _delay_weeks = delay_weeks
        _event_manager = event_manager
        _main_session = main_session


    func evaluate() -> bool:
        if (!_is_parent_event_triggered):
            check_parent_event()
            return false
        
        return check_delay()


    func check_parent_event():
        if (_parent_event_id in _event_manager.completed_events):
            _parent_event_triggered_day = _main_session.curDays
            _is_parent_event_triggered = true

    
    func check_delay() -> bool:
        return (_main_session.curDays - _parent_event_triggered_day) >= _delay_weeks * 7