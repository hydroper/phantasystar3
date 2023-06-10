class_name PS3BasePanel
extends Control

signal on_outer_click
signal on_popup(goal: String, data: Variant)
signal on_collapse(goal: String, data: Variant)

var _busy: bool = false
var _scale_tween: ConstantScaleTween = ConstantScaleTween.new(Vector2(0.05, 0.05))
var _trans_goal: String = ""
var _trans_data: Variant = null
var _collapsed: bool = true
var _disabled: bool = true
var _custom_position_is_unset: bool = true
var _custom_position: Vector2

var custom_position: Vector2:
    get:
        return self._custom_position
    set(value):
        self._custom_position = value
        self._custom_position_is_unset = false

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
    self.scale.x = 0
    self._scale_tween.finished.connect(func():
        self.visible = self._collapsed
        self._collapsed = not self._collapsed
        var k1 = self._trans_goal
        var k2 = self._trans_data
        self._trans_goal = ""
        self._trans_data = null
        self._busy = false
        if self._collapsed:
            self.position.x = self._custom_position.x + self.size.x / 2
            self.disabled = true
            self.on_collapse.emit(k1, k2)
        else:
            self.position.x = self._custom_position.x
            self.disabled = false
            self.on_popup.emit(k1, k2))

func _process(delta: float) -> void:
    self._scale_tween.process(delta)
    var x = self._custom_position.x
    var w = self.size.x
    var sx = self.scale.x
    self.position.x = x + w / 2 - (w / 2) * sx

func popup(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_open:
        return
    self._busy = true
    self._trans_goal = goal
    self._trans_data = data
    self.visible = true
    self.disabled = true
    self.custom_position = self.position if self._custom_position_is_unset else self._custom_position
    self._scale_tween.tween_x(self, 1.0)

func collapse(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_collapsed:
        return
    self._busy = true
    self._trans_goal = goal
    self._trans_data = data
    self.visible = true
    self.disabled = true
    self.custom_position = self.position if self._custom_position_is_unset else self._custom_position
    self._scale_tween.tween_x(self, 0.0)
