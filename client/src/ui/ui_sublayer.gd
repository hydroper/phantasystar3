class_name UISublayer
extends CanvasLayer

signal on_close(data: Variant)

func open(data: Variant) -> void:
    pass

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    if self._closed:
        return
    self.get_parent().remove_child(self)
    self._closed = true
    self.on_close.emit(data)

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    pass

var is_closed: bool:
    get:
        return self._closed

var _closed: bool = false
