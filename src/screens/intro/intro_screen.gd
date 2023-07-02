extends Node2D

@onready
var _animator: AnimationPlayer = $root/animator

func _ready() -> void:
    self._animator.animation_finished.connect(func(_anim_name):
        pass)
    $root/skip_btn.pressed.connect(func():
        self._skip_part())

func _input(event):
    if event.is_action_released("ui_cancel"):
        self._skip_part()

func _process(_delta: float) -> void:
    pass

func _skip_part() -> void:
    var pos = self._animator.current_animation_position
    for ahead_pos in [0.4, 2.6, 3, 4.6]:
        if pos < ahead_pos:
            self._animator.advance(ahead_pos)
            break
