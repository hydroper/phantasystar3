class_name GameScPartyOrderMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $remaining.popup()
    $result.popup()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $remaining.collapse("close_current_and_parent")
    $result.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    $remaining.collapse("close_current")
    $result.collapse()

func _ready() -> void:
    # outer
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $remaining.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))
