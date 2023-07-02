extends Node2D

var _waiting_start := false

func _ready() -> void:
    $root/start_layer/animator.animation_finished.connect(func(anim_name):
        if anim_name == "default":
            $root/start_layer/animator.play("looping")
            self._waiting_start = true)

func _process(_delta: float) -> void:
    pass
