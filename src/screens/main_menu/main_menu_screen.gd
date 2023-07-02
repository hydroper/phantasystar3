extends Node2D

var _waiting_start := false

func _ready() -> void:
    $root/start_layer/animator.animation_finished.connect(func(anim_name):
        if anim_name == "default":
            $root/start_layer/animator.play("looping")
            self._waiting_start = true
        elif anim_name == "start_pressed":
            pass)
    $root/start_layer/start_click_btn.pressed.connect(self._on_start_press)

func _input(event):
    if event.is_action_released("ui_accept"):
        self._on_start_press()

func _process(_delta: float) -> void:
    pass

func _on_start_press() -> void:
    if not self._waiting_start:
        return
    pass
