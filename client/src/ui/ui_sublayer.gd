class_name UISublayer
extends CanvasLayer

signal on_close(data: Variant)

func open(data: Variant) -> void:
    pass

# Closes any sublayer and the root layer itself.
func close(data: Variant) -> void:
    pass

# If there is any sublayer, closes only it; if none,
# closes the root layer.
func close_sublayer(data: Variant) -> void:
    pass
