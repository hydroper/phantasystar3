extends Node2D

var _waiting_start := false

func _ready() -> void:
    $root/start_layer.visible = true
    $root/menu_layer.visible = true
    $root/start_layer/animator.animation_finished.connect(func(anim_name):
        if anim_name == "default":
            $root/start_layer/animator.play("looping")
            self._waiting_start = true
        elif anim_name == "start_pressed":
            self._on_start_pressed_animation_finished())
    $root/start_layer/start_click_btn.pressed.connect(self._on_start_press)
    $root/menu_layer/menu.on_popup.connect(func(_goal, _data):
        $root/menu_layer/menu/container/container/main/list/new_game_btn.grab_focus())
    $root/menu_layer/menu.on_collapse.connect(func(goal, _data):
        if goal == "new_game":
            self.get_tree().change_scene_to_file("res://src/screens/game/game_screen.tscn"))
    # 'New Game' button
    $root/menu_layer/menu/container/container/main/list/new_game_btn.pressed.connect(func():
        $root/menu_layer/menu.collapse("new_game"))

func _input(event):
    if event.is_action_released("ui_accept"):
        self._on_start_press()

func _process(_delta: float) -> void:
    pass

func _on_start_press() -> void:
    if not self._waiting_start:
        return
    $root/start_layer/animator.play("start_pressed")

func _on_start_pressed_animation_finished() -> void:
    $root/start_layer.visible = false
    $root/menu_layer.visible = true
    $root/menu_layer/menu.popup()
