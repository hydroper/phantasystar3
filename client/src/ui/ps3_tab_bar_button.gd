class_name PS3TabBarButton
extends Button

var tab_selected: bool = false

var meta_data: Variant = null

enum Reflected { DEFAULT, DISABLED, DISABLED_FOCUSED, HOVER, PRESSED_OR_FOCUS_OR_SELECTED }

var _reflected: Reflected = Reflected.DEFAULT

func _ready():
    self._reflect_state()

func _process(_delta: float) -> void:
    self._reflect_state()

func _reflect_state() -> void:
    if self.disabled:
        if self.has_focus():
            self._reflect_state_fn(Reflected.DISABLED_FOCUSED)
        elif self._reflected != Reflected.DISABLED:
            self._reflect_state_fn(Reflected.DISABLED)
    elif self.button_pressed or self.has_focus() or self.tab_selected:
        if self._reflected != Reflected.PRESSED_OR_FOCUS_OR_SELECTED:
            self._reflect_state_fn(Reflected.PRESSED_OR_FOCUS_OR_SELECTED)
    elif self.is_hovered():
        if self._reflected != Reflected.HOVER:
            self._reflect_state_fn(Reflected.HOVER)
    elif self._reflected != Reflected.DEFAULT:
        self._reflect_state_fn(Reflected.DEFAULT)

func _reflect_state_fn(to: Reflected) -> void:
    $skin/hovered_bg.visible = to == Reflected.HOVER
    # if to == Reflected.HOVER:
    #     $skin/hovered_anim.play()
    # else: $skin/hovered_anim.stop()
    $skin/pressed_or_focused_or_sel_bg.visible = to == Reflected.PRESSED_OR_FOCUS_OR_SELECTED
    # if to == Reflected.PRESSED_OR_FOCUS_OR_SELECTED:
    #     $skin/pressed_or_focused_or_sel_anim.play()
    # else: $skin/pressed_or_focused_or_sel_anim.stop()
    $skin/disabled_focused_bg.visible = to == Reflected.DISABLED_FOCUSED
    # if to == Reflected.DISABLED_FOCUSED:
    #     $skin/disabled_focused_anim.play()
    # else: $skin/disabled_focused_anim.stop()
    $content.modulate.a = 0.7 if to == Reflected.DISABLED or to == Reflected.DISABLED_FOCUSED else 1.0
    self._reflected = to
