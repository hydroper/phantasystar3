class_name PS3RoundMediumCheckButton
extends Button

# Allows storing arbitrary data.
var meta_data: Variant = null

var _tween: Tween = null
var _arc_x_tween: Tween = null

func _init_tween() -> void:
    if self._tween != null:
        self._tween.kill()
        self._tween = null
    self._tween = self.get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
    self.focus_entered.connect(self._on_focus_or_hover_entered)
    self.focus_exited.connect(self._on_focus_or_hover_exited)
    self.mouse_entered.connect(self._on_focus_or_hover_entered)
    self.mouse_exited.connect(self._on_focus_or_hover_exited)
    self._toggled(self.button_pressed)

func _on_focus_or_hover_entered() -> void:
    self._init_tween()
    self._tween.tween_property($control, "scale", Vector2(0.75, 0.75), .2)

func _on_focus_or_hover_exited() -> void:
    self._init_tween()
    self._tween.tween_property($control, "scale", Vector2(0.65, 0.65), .2)

func _process(_delta: float) -> void:
    $control.modulate.a = 0.6 if self.disabled else 1.0

func _toggled(pressed_arg: bool) -> void:
    $control/background.modulate = Color.WHITE if pressed_arg else Color("#7e7e7e")
    if self._arc_x_tween != null:
        self._arc_x_tween.kill()
        self._arc_x_tween = null
    self._arc_x_tween = self.get_tree().create_tween()
    self._arc_x_tween.tween_property($control/arc, "position", Vector2(34 if pressed_arg else -90, $control/arc.position.y), 0.15)
