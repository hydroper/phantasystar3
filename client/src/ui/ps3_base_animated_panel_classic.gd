class_name PS3BaseAnimatedPanelClassic
extends Control

signal on_outer_click
signal on_popup(goal: String, data: Variant)
signal on_collapse(goal: String, data: Variant)

var _busy: bool = false
var _scale_tween: ConstantScaleTween = ConstantScaleTween.new(Vector2(0.12, 0.12))
var _trans_meta_data: Array = []
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
        var k1 = self._trans_meta_data[0]
        var k2 = self._trans_meta_data[1]
        self._trans_meta_data = ["", null]
        self._busy = false
        if self._collapsed:
            self.position.y = self._custom_position.y + self.size.y / 2
            self.disabled = true
            self.on_collapse.emit(k1, k2)
        else:
            self.position.y = self._custom_position.y
            self.disabled = false
            self.on_popup.emit(k1, k2))

func _ready() -> void:
    self.visible = false
    self.scale.x = 0

func _process(delta: float) -> void:
    if self._scale_tween.is_running():
        self._scale_tween.process(delta)
        var y = self._custom_position.y
        var h = self.size.y
        var sh = self.scale.y
        self.position.y = y + h / 2 - (h / 2) * sh

func _input(event: InputEvent) -> void:
    if self.is_open && !self._busy && NodeExtFn.outer_clicked(self, event):
        on_outer_click.emit()

# Stops any running animation and resets the panel to its
# collapsed state.
func reset_to_collapsed() -> void:
    self._busy = false
    self._collapsed = true
    self._trans_meta_data = ["", null]
    self.visible = false
    self.disabled = true
    self.custom_position = self.position if self._custom_position_is_unset else self._custom_position
    self.position.y = self._custom_position.y
    self._scale_tween.stop()

func popup(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_open:
        return
    self._busy = true
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.disabled = true
    self.custom_position = self.position if self._custom_position_is_unset else self._custom_position
    self.position.y = self._custom_position.y + self.size.y / 2
    self._scale_tween.tween_x(self, 1.0)

func collapse(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_collapsed:
        return
    self._busy = true
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.disabled = true
    self.custom_position = self.position if self._custom_position_is_unset else self._custom_position
    self.position.y = self._custom_position.y
    self._scale_tween.tween_x(self, 0.0)
