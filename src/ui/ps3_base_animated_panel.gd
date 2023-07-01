class_name PS3BaseAnimatedPanel
extends Control

signal on_outer_click
signal on_popup(goal: String, data: Variant)
signal on_collapse(goal: String, data: Variant)

var disabled: bool:
    get:
        return self._disabled
    set(value):
        self._disabled = value
        if value:
            NodeExtFn.disable(self)
        else:
            NodeExtFn.enable(self)

var temporarily_disabled: bool:
    get:
        return self._temporarily_disabled.disabled
    set(value):
        self._temporarily_disabled.disabled = value

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
    self._busy_collapsing = false
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.temporarily_disabled = true
    self._do_transition()

func collapse(goal: String = "", data: Variant = null) -> void:
    if self._busy or self.is_collapsed:
        return
    self._busy = true
    self._busy_collapsing = true
    self._trans_meta_data = [goal, data]
    self.visible = true
    self.temporarily_disabled = true
    self._do_transition()

var _busy: bool = false
var _busy_collapsing: bool = false

var _scale_tween: LazyTween
var _modulate_tween: LazyTween

var _trans_meta_data: Array = []

var _collapsed: bool = true
var _disabled: bool = true
var _temporarily_disabled: TemporarilyDisabled = null

var _postpone_transition: bool = false

func _init():
    self.visible = false
    self.scale.y = 0
    self.modulate = Color(1.0, 1.0, 1.0, 0.0)
    self._temporarily_disabled = TemporarilyDisabled.new(self)
    self._scale_tween = LazyTween.new()
    self._modulate_tween = LazyTween.new()

    self._scale_tween.finished.connect(func():
        self._scale_tween.kill()
        self._modulate_tween.kill()
        self.visible = self._collapsed
        self._collapsed = not self._collapsed
        var k = self._trans_meta_data
        self._trans_meta_data = ["", null]
        self._busy = false
        self._busy_collapsing = false
        if self._collapsed:
            self.temporarily_disabled = true
            self.on_collapse.emit(k[0], k[1])
        else:
            self.temporarily_disabled = false
            self.on_popup.emit(k[0], k[1]))

func _ready() -> void:
    self.visible = false
    self.scale.y = 0
    self.modulate = Color(1.0, 1.0, 1.0, 0.0)
    if self._postpone_transition:
        self._do_transition()

func _input(event: InputEvent) -> void:
    if self.is_open and !self._busy and NodeExtFn.outer_clicked(self, event):
        self.on_outer_click.emit()

func _process(_delta: float) -> void:
    pass

func _do_transition() -> void:
    if not self.is_inside_tree():
        self._postpone_transition = true
        return
    if self._busy_collapsing:
        self._scale_tween.tween_property(self, "scale", Vector2(self.scale.x, 0.0), 0.3)
        self._modulate_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.27)
    else:
        self._scale_tween.tween_property(self, "scale", Vector2(self.scale.x, 1.0), 0.3)
        self._modulate_tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.27)
    self._postpone_transition = false
