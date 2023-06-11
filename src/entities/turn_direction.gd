class_name TurnDirection

static var _from: Dictionary
static var UP: TurnDirection = TurnDirection.new(0, Vector2(0, -1))
static var UP_LEFT: TurnDirection = TurnDirection.new(1, Vector2(-1, -1))
static var UP_RIGHT: TurnDirection = TurnDirection.new(2, Vector2(1, -1))
static var DOWN: TurnDirection = TurnDirection.new(3, Vector2(0, 1))
static var DOWN_LEFT: TurnDirection = TurnDirection.new(4, Vector2(-1, 1))
static var DOWN_RIGHT: TurnDirection = TurnDirection.new(5, Vector2(1, 1))
static var LEFT: TurnDirection = TurnDirection.new(6, Vector2(-1, 0))
static var RIGHT: TurnDirection = TurnDirection.new(7, Vector2(1, 0))

var _v: int
var _speed: Vector2

func _init(v: int, speed: Vector2):
    self._v = v
    self._speed = speed
    _from = _from if _from != null else {}
    _from[v] = self

static func from(value: int) -> TurnDirection:
    return _from.get(value)

func value_of() -> int:
    return self._v

var speed: Vector2:
    get:
        return self._speed
