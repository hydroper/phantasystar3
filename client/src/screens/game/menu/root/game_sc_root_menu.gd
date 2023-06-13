extends CanvasLayer

var game_data: PS3GameData = null

var is_open: bool:
    get:
        return self._open

func open() -> void:
    self._open = true
    $outer.visible = true
    $menu.visible = true
    if self._last_focused_button == null:
        $menu/list/items_btn.grab_focus()
    else: self._last_focused_button.grab_focus()

# If there is any subcontrol, close only it; if none,
# closes the menu.
func close_subcontrol() -> void:
    self.close()

# Closes any subcontrol and the root menu itself.
func close() -> void:
    self._open = false
    $outer.visible = false
    $menu.visible = false
    self.get_parent().remove_child(self)

var _open: bool = false

var _last_focused_button: Control = null

func _ready() -> void:
    # the top-right menu button.
    $outer.pressed.connect(func(): self.close())
