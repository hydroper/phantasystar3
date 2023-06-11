class_name PS3ItemType

static var MONOMATE: PS3ItemType = PS3ItemType.new(0, PS3ItemCategory.CONSUMABLE, true)
static var DIMATE: PS3ItemType = PS3ItemType.new(1, PS3ItemCategory.CONSUMABLE, true)

static var _from: Dictionary = {}
var _value: int
var _category: PS3ItemCategory
var _unique: bool

func _init(value: int, category: PS3ItemCategory, unique: bool = false):
    PS3ItemType._from[value] = self
    self._value = value
    self._category = category
    self._unique = unique

static func from(value: int) -> PS3ItemType:
    return PS3ItemType._from.get(value)

func value_of() -> int:
    return self._value

var category: PS3ItemCategory:
    get:
        return self._category

var unique: bool:
    get:
        return self._unique

var disposable: bool:
    get:
        return true

func get_name() -> String:
    if self == PS3ItemType.MONOMATE:
        return "Monomate"
    if self == PS3ItemType.DIMATE:
        return "Dimate"
    return "undefined"

func get_description() -> String:
    return "No description available."
