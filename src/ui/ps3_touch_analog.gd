class_name PS3TouchAnalog
extends TouchScreenButton

var disabled := false
var direction: TurnDirection:
    get:
        return self._turn_dir

var _turn_dir: TurnDirection = null
var _touch_index: int = -1

var _radius: float:
    get:
        return $bg.size.x

# $point.position

# InputEventScreenTouch (has `index` and `pressed`)
# InputEventScreenDrag (has `index` and `position`)
# InputEventMouse (has `position`)
func _input(event) -> void:
    if event is InputEventScreenTouch:
        if not event.pressed:
            # release
            if self._touch_index == event.index:
                self._touch_index = -1
                self._release_analog()
        elif self._touch_index == -1 and self._touch_hits_arc(event.position):
            # hold
            self._stick_analog(event.position)
            self._touch_index = event.index
    elif event is InputEventScreenDrag and self._touch_index == event.index:
        self._stick_analog(event.position)

func _global_rect() -> Rect2:
    var r := self._radius
    var size := Vector2(r, r)
    return Rect2(self.global_position - size / 2, size)

func _touch_hits_arc(touch_pos: Vector2) -> bool:
    var a := Rect2(touch_pos, Vector2(1.0, 1.0))
    return a.intersects(self._global_rect())

const W: float = 50

func _stick_analog(touch_position: Vector2) -> void:
    var global_rect = self._global_rect()
    $point.visible = true
    $point.global_position = Vector2(clampf(touch_position.x, global_rect.position.x, global_rect.position.x + global_rect.size.x) - $point.size.x / 2, clampf(touch_position.y, global_rect.position.y, global_rect.position.y + global_rect.size.y) - $point.size.y / 2)
    # determine turn direction
    var p: Vector2 = $point.position
    if p.x < -W and p.y < -W:
        self._turn_dir = TurnDirection.UP_LEFT
    elif p.x < -W and p.y > W:
        self._turn_dir = TurnDirection.DOWN_LEFT
    elif p.x < -W:
        self._turn_dir = TurnDirection.LEFT
    elif p.x > W and p.y < -W:
        self._turn_dir = TurnDirection.UP_RIGHT
    elif p.x > W and p.y > W:
        self._turn_dir = TurnDirection.DOWN_RIGHT
    elif p.x > W:
        self._turn_dir = TurnDirection.RIGHT
    elif p.y < -W:
        self._turn_dir = TurnDirection.UP
    elif p.y > W:
        self._turn_dir = TurnDirection.DOWN
    else:
        self._turn_dir = null

func _release_analog() -> void:
    self._turn_dir = null
    $point.visible = false
