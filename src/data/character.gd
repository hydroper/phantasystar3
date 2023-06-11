class_name PS3Character

static var RHYS: PS3Character = PS3Character.new(0, "rhys", "Rhys")

static var _from: Dictionary = {}
var _value: int
var _string_id: String
var _name: String

func _init(value: int, string_id: String, name: String):
    PS3Character._from[value] = self
    self._value = value
    self._string_id = string_id
    self._name = name

static func from(value: int) -> PS3Character:
    return PS3Character._from.get(value)

func value_of() -> int:
    return self._value

var string_id: String:
    get:
        return self._string_id

var name: String:
    get:
        return self._name
