extends Button

enum Reflected { DEFAULT, DISABLED, DISABLED_FOCUSED, HOVER_OR_FOCUS, PRESSED }

var _reflected: Reflected = Reflected.DEFAULT

func _ready():
    self._reflect_state()

func _process(delta):
    self._reflect_state()

func _reflect_state() -> void:
    if self.disabled:
        if self.has_focus():
            self._reflect_state_fn(Reflected.DISABLED_FOCUSED)
        elif self._reflected != Reflected.DISABLED:
            self._reflect_state_fn(Reflected.DISABLED)
    elif self.button_pressed:
        if self._reflected != Reflected.PRESSED:
            self._reflect_state_fn(Reflected.PRESSED)
    elif self.is_hovered() or self.has_focus():
        if self._reflected != Reflected.HOVER_OR_FOCUS:
            self._reflect_state_fn(Reflected.HOVER_OR_FOCUS)
    elif self._reflected != Reflected.DEFAULT:
        self._reflect_state_fn(Reflected.DEFAULT)

func _reflect_state_fn(to: Reflected) -> void:
    $button_states/hovered_or_focused_bg.visible = to == Reflected.HOVER_OR_FOCUS
    if to == Reflected.HOVER_OR_FOCUS:
        $button_states/hovered_or_focused_anim.play()
    else: $button_states/hovered_or_focused_anim.stop()
    $button_states/pressed_bg.visible = to == Reflected.PRESSED
    if to == Reflected.PRESSED:
        $button_states/pressed_anim.play()
    else: $button_states/pressed_anim.stop()
    $button_states/disabled_focused_bg.visible = to == Reflected.DISABLED_FOCUSED
    if to == Reflected.DISABLED_FOCUSED:
        $button_states/disabled_focused_anim.play()
    else: $button_states/disabled_focused_anim.stop()
    if $label != null:
        $label.modulate.a = 0.7 if to == Reflected.DISABLED or to == Reflected.DISABLED_FOCUSED else 1.0
    self._reflected = to
