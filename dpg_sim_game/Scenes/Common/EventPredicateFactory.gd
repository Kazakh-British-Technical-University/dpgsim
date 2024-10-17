class_name EventPredicateFactory

enum PREDICATE_TYPE {
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


## Base class for all event predicates (conditions). 
class EventPredicate:

    enum COMPARISON_TYPE {
        EQUAL,
        GREATER,
        GREATER_OR_EQUAL,
        LESS,
        LESS_OR_EQUAL
    }   


    ## Checks if event condition criterias are met
    func evaluate() -> bool:
        assert(false, "Cannot use method of an abstract class")
        return false


    func compare(a, b, comparison_type: int) -> bool:
        match comparison_type:
            COMPARISON_TYPE.EQUAL:
                return a == b
            COMPARISON_TYPE.GREATER:
                return a > b
            COMPARISON_TYPE.GREATER_OR_EQUAL:
                return a >= b
            COMPARISON_TYPE.LESS:
                return a < b
            COMPARISON_TYPE.LESS_OR_EQUAL:
                return a <= b
            _:
                assert(false, "Invalid comparison type")
                return false


## Checks for a particular week counting from the session’s start
class TimePredicate:

    extends EventPredicate

    var _weeks: int
    var _comparison_type: int
    var _main_session: MainSession


    func _init(weeks: int, comparison_type: int, main_session: MainSession):
        _weeks = weeks
        _comparison_type = comparison_type
        _main_session = main_session
        

    func evaluate() -> bool:
        # TODO: Is ok to check every day of the week?
        var currentWeek = int(_main_session.curDays / 7)
        return compare(currentWeek, _weeks, _comparison_type)
        


## TODO: Implement this
## This trigger is for the user’s Actions
class ActionPredicate:

    extends EventPredicate


## Checks for the amount of money player have
class MoneyPredicate:

    extends EventPredicate

    var _money: int
    var _comparison_type: int
    var _moneyNode: Money


    func _init(money: int, comparison_type: int, moneyNode: Money):
        _money = money
        _comparison_type = comparison_type
        _moneyNode = moneyNode

    
    func evaluate() -> bool:
        return compare(_moneyNode.total, _money, _comparison_type)