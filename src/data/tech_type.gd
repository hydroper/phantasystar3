class_name PS3TechType

static var HEAL: PS3TechType = PS3TechType.new(0, "Heal", 1)
static var RES: PS3TechType = PS3TechType.new(1, "Res", 1)
static var GIRES: PS3TechType = PS3TechType.new(2, "Gires", 1)
static var REVER: PS3TechType = PS3TechType.new(3, "Rever", 1)
static var ANTI: PS3TechType = PS3TechType.new(4, "Anti", 1)
static var ORDER: PS3TechType = PS3TechType.new(5, "Order", 1)
static var FANBI: PS3TechType = PS3TechType.new(6, "Fanbi", 1)
static var FORSA: PS3TechType = PS3TechType.new(7, "Forsa", 1)
static var NASAK: PS3TechType = PS3TechType.new(8, "Nasak", 1)
static var SHU: PS3TechType = PS3TechType.new(9, "Shu", 1)

var name: String:
    get:
        return self._name

var cost: int:
    get:
        return self._cost

var description: String:
    get:
        return "No description available."

static func from(value: int) -> PS3TechType:
    return _from.get(value)

func value_of() -> int:
    return self._value

static var _from: Dictionary
var _value: int
var _name: String
var _cost: int

func _init(value: int, name: String, cost: int):
    _from = _from if _from != null else {}
    _from[value] = self
    self._value = value
    self._name = name
    self._cost = cost
