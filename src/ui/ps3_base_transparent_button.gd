# A button that is transparent when not hovered.
class_name PS3BaseTransparentButton
extends Button

enum Reflected { UNINIT, DEFAULT, ACTIVE }

var _reflected: Reflected = Reflected.UNINIT

func _ready():
    self._reflect_state()

func _process(_delta: float) -> void:
    self._reflect_state()

func _reflect_state() -> void:
    # if self.button_pressed or self.is_hovered() or self.has_focus():
    if self.is_hovered():
        if self._reflected != Reflected.ACTIVE:
            self._reflect_state_fn(Reflected.ACTIVE)
    elif self._reflected != Reflected.DEFAULT:
        self._reflect_state_fn(Reflected.DEFAULT)

func _reflect_state_fn(to: Reflected) -> void:
    self.modulate.a = 0.5 if to == Reflected.DEFAULT else 1.0
    self._reflected = to
