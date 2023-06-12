class_name PS3BaseAnimatedPanel
extends Control

signal on_outer_click
signal on_popup(goal: String, data: Variant)
signal on_collapse(goal: String, data: Variant)

var _busy: bool = false

@onready
var _scale_tween: LazyTween = LazyTween.new(self)

@onready
var _modulate_tween: LazyTween = LazyTween.new(self)

var _trans_meta_data: Array = []

var _collapsed: bool = true
var _disabled: bool = true

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

func popup(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_open:
        return
    self._busy = true
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.disabled = true
    self._scale_tween.tween_property("scale", Vector2(self.scale.x, 1.0), 0.3)
    self._modulate_tween.tween_property("modulate", Color(1.0, 1.0, 1.0, 1.0), 0.27)

func collapse(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_collapsed:
        return
    self._busy = true
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.disabled = true
    self._scale_tween.tween_property("scale", Vector2(self.scale.x, 0.0), 0.3)
    self._modulate_tween.tween_property("modulate", Color(1.0, 1.0, 1.0, 0.0), 0.27)

func _init():
    self.visible = false
    self.scale.y = 0
    self._scale_tween.finished.connect(func():
        self.visible = self._collapsed
        self._collapsed = not self._collapsed
        var k = self._trans_meta_data
        self._trans_meta_data = ["", null]
        self._busy = false
        if self._collapsed:
            self.disabled = true
            self.on_collapse.emit(k[0], k[1])
        else:
            self.disabled = false
            self.on_popup.emit(k[0], k[1]))

func _ready() -> void:
    self.visible = false
    self.scale.y = 0

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
