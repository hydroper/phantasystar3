extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    pass

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    pass

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    pass

func _ready() -> void:
    $outer.pressed.connect(func():
        self.close_sublayer(null))

    $tech_selection.on_popup(func(_goal, _data):
        pass)

    $tech_selection.on_collapse(func(_goal, _data):
        pass)
