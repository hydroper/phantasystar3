class_name ConstantPhysicsRotationTween

var increment_degrees: float

var _tween_node: Node2D = null
var _running: bool = false
var _increment_scale: float = 1
var _target_degrees: float = 0

var _route_result_go_clockwise: bool = false
var _route_result_delta: float = 0

var _current_rotation: float:
    get:
        return fmod(AngleUtil.apply_range(self._tween_node.rotation_degrees), 360)

func _init(tween_node: Node2D, increment_degrees: float):
    self._tween_node = tween_node
    self.increment_degrees = increment_degrees

func is_running() -> bool:
    return self._running

func tween(target_degrees: float) -> void:
    if self.is_running():
        self.stop()
    self._target_degrees = fmod(roundf(AngleUtil.apply_range(target_degrees)), 360.0)
    self._running = true

func stop() -> void:
    self._running = false

func integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if not self._running:
        return
    var current_rotation = self._current_rotation
    if current_rotation == self._target_degrees:
        self._running = false
        state.angular_velocity = 0
        return
    self._update_route(current_rotation)
    var route_delta = self._route_result_delta
    state.angular_velocity = (1.0 if (route_delta <= 3 and self.increment_degrees > 1.0) else self.increment_degrees) * self._increment_scale

func _update_route(current_rotation: float) -> void:
    var a = self._target_degrees
    var b = current_rotation
    var ab = a - b
    var ba = b - a
    ab = ab + 360 if ab < 0 else ab
    ba = ba + 360 if ba < 0 else ba
    var go_clockwise = ab < ba
    self._increment_scale = 1 if go_clockwise else -1
    self._route_result_go_clockwise = go_clockwise
    self._route_result_delta = roundf(ab if go_clockwise else ba)
