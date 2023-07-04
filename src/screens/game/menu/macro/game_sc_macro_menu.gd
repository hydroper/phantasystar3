class_name PS3GameScMacroMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $macros.popup()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $macros.collapse("close_current_and_parent")

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    $macros.collapse("close_current")

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $macros.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))
