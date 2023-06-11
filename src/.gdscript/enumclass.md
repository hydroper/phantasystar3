# Enum class

```gdscript
class_name SomeE

static var X: SomeE = SomeE.new(0)
static var Y: SomeE = SomeE.new(1)

static var _from: Dictionary
var _value: int

func _init(value: int):
    _from = _from if _from != null else {}
    _from[value] = self
    self._value = value

static func from(value: int) -> SomeE:
    return _from.get(value)

func value_of() -> int:
    return self._value

```