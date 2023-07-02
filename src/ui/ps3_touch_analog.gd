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

func _touch_hits_arc(touch_pos: Vector2) -> bool:
    var a := Rect2(touch_pos, Vector2(1.0, 1.0))
    var r := self._radius
    var size := Vector2(r, r)
    var b := Rect2(self.global_position - size / 2, size)
    return a.intersects(b)

func _stick_analog(position: Vector2) -> void:
    $point.visible = true
    # assert(false, "Not yet done.")

func _release_analog() -> void:
    self._turn_dir = null
    $point.visible = false
    # assert(false, "Not yet done.")
