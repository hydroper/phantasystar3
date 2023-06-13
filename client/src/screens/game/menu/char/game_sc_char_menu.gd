extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    $list.popup()
    $status.popup()

# Closes any sublayer and the root layer itself.
func close(data: Variant) -> void:
    pass

# If there is any sublayer, closes only it; if none,
# closes the root layer.
func close_sublayer(data: Variant) -> void:
    pass

var _sublayer: UISublayer = null

var _last_focused_button: Control = null

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
