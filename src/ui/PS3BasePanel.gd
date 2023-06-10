class_name PS3BasePanel
extends Control

signal outer_click
signal after_popup(goal: String, data: Variant)
signal after_collapse(goal: String, data: Variant)

var _busy: bool = false
var _scale_tween: ConstantScaleTween = ConstantScaleTween.new(Vector2(0.05, 0.05))
var _trans_goal: String = ""
var _trans_data: Variant = null
var _collapsed: bool = true
var _disabled: bool = true
var _position: Vector2

var disabled: bool:
    get:
        return self._disabled
    set(value):
        self._disabled = value
        if value:
            NodeExtFn.disable(self)
        else:
            NodeExtFn.enable(self)

var is_open: bool:
    get:
        return !self._collapsed

var is_collapsed: bool:
    get:
        return self._collapsed

var is_opening_or_collapsing: bool:
    get:
        return self._busy

func _init():
    self.visible = false
    self._scale_tween.finished.connect(func():
        self.visible = self._collapsed
        self._collapsed = not self._collapsed
        var k1 = self._trans_goal
        var k2 = self._trans_data
        self._trans_goal = ""
        self._trans_data = null
        self._busy = false
        if self._collapsed:
            self.disabled = true
            self.after_collapse.emit(k1, k2)
        else:
            self.disabled = false
            self.after_popup.emit(k1, k2))

func _process(delta: float) -> void:
    self._scale_tween.process(delta)

func popup(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_open:
        return
    self._busy = true
    self._trans_goal = goal
    self._trans_data = data
    self.visible = true
    self.disabled = true
    self._position = self.position
    self._scale_tween.tween_x(self, 1.0)

func collapse(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_collapsed:
        return
    self._busy = true
    self._trans_goal = goal
    self._trans_data = data
    self.visible = true
    self.disabled = true
    self._position = self.position
    self._scale_tween.tween_x(self, 0.0)
