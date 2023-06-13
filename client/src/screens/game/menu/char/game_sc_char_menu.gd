extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    $list.popup()
    $status.popup()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    super.close(data)

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    $list.collapse("close_current")
    $status.collapse()

var _sublayer: UISublayer = null

var _last_focused_button: Control = null

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $list.on_popup.connect(func(_goal, _data):
        if self._last_focused_button == null:
            $list/container/container/main/scrollable/list.get_child(0).grab_focus()
        else: self._last_focused_button.focus())
    $list.on_collapse.connect(func(goal, _data):
        if goal == "close_current":
            super.close(null))
