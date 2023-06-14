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
