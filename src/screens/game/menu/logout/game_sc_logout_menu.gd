class_name GameScLogoutMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $logout.popup()
    $logout/container/container/main/list/continue_btn.grab_focus()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $logout.collapse("close_current_and_parent")

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    $logout.collapse("close_current")

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $logout.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))
    $logout/container/container/main/list/exit_btn.pressed.connect(func():
        self.game_data.save()
        self.get_tree().change_scene_to_file("res://src/screens/intro/intro_screen.tscn"))
    $logout/container/container/main/list/continue_btn.pressed.connect(func():
        self.close(null))
