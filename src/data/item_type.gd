class_name PS3ItemType

static var _from: Dictionary = {}

static var MONOMATE: PS3ItemType = PS3ItemType.new(0, "Monomate", PS3ItemCategory.CONSUMABLE, true)
static var DIMATE: PS3ItemType = PS3ItemType.new(1, "Dimate", PS3ItemCategory.CONSUMABLE, true)
static var KNIFE: PS3ItemType = PS3ItemType.new(2, "Knife", PS3ItemCategory.WEAPON, false)
static var GARMENT: PS3ItemType = PS3ItemType.new(3, "Garment", PS3ItemCategory.TORSO, false)
static var BOOTS: PS3ItemType = PS3ItemType.new(4, "Boots", PS3ItemCategory.FEET, false)

static func from(value: int) -> PS3ItemType:
    return _from.get(value)

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

var name: String:
    get:
        return self._name

var description: String:
    get:
        return self.get_description()

var targetted_recovery: Variant:
    get:
        if self == PS3ItemType.MONOMATE:
            return {type = "hp", hp = 10}
        return null

func get_description() -> String:
    return "No description available."

var _value: int
var _name: String
var _category: PS3ItemCategory
var _unique: bool

func _init(value: int, name: String, category: PS3ItemCategory, unique: bool = false):
    _from[value] = self
    self._value = value
    self._name = name
    self._category = category
    self._unique = unique
