class_name ConstantScaleTween

signal finished

var _increment: Vector2
var _running: bool = false
var _node: Node = null
var _current_value: Vector2
var _tween_control: Control = null
var _tween_node2d: Node2D = null
var _final: Vector2

func _init(increment: Vector2):
    self._increment = increment

func is_running() -> bool:
    return self._running

func tween(node: Node, final: Vector2) -> void:
    if self.is_running():
        self.stop()
    assert((not node is Control) and (not node is Node2D), "ConstantScaleTween.tween() only supports Node2D and Control")
    self._running = true
    self._final = final
    self._tween_control = node as Control
    self._tween_node2d = node as Node2D
    self._current_value = self._tween_control.scale if self._tween_control != null else self._tween_node2d.scale

func tween_x(node: Node, final: float) -> void:
    var cn = node as Control
    var n2d = node as Node2D
    self.tween(node, Vector2(final, cn.scale.y if cn != null else n2d.scale.y if n2d != null else 0.0))

func tween_y(node: Node, final: float) -> void:
    var cn = node as Control
    var n2d = node as Node2D
    self.tween(node, Vector2(cn.scale.x if cn != null else n2d.scale.x if n2d != null else 0.0, final))

func stop() -> void:
    self._running = false
    self._tween_control = null
    self._tween_node2d = null

func process(delta: float) -> void:
    if not self._running:
        return
    if self._current_value == self._final:
        self.finished.emit()
        self.stop()
        return
    if self._current_value.x > self._final.x:
        self._current_value.x = maxf(self._final.x, self._current_value.x - (self._increment.x * delta))
    else:
        self._current_value.x = minf(self._current_value.x + self._increment.x * delta, self._final.x)
    if self._current_value.y > self._final.y:
        self._current_value.y = maxf(self._final.y, self._current_value.y - (self._increment.y * delta))
    else:
        self._current_value.y = minf(self._current_value.y + self._increment.y * delta, self._final.y)

    if self._tween_control != null:
        self._tween_control.scale = self._current_value
    else:
        self._tween_node2d.scale = self._current_value
