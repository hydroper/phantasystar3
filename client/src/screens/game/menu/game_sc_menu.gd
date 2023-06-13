class_name GameScMenu
extends CanvasLayer

var is_open: bool:
    get:
        return self._open

var game_data: PS3GameData = null

func toggle() -> void:
    if self.is_open:
        self.close()
    else: self.open()

func open() -> void:
    assert(not self._open, "game_sc_menu.open() called when the menu is open.")
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
    assert(self._open, "game_sc_menu.close() called when the menu is open.")
    self._open = false
    $outer.visible = false
    $menu.visible = false

var _open: bool = false

var _last_focused_button: Control = null

func _ready() -> void:
    $outer.visible = false
    $menu.visible = false

    # the top-right menu button.
    $menu_button.pressed.connect(func(): self.toggle())

    # the top-right menu button.
    $outer.pressed.connect(func(): self.toggle())

func _input(event: InputEvent) -> void:
    if self.is_open:
        if event.is_action_released("ui_cancel"):
            self.close_subcontrol()
    elif event.is_action_released("pause"):
        self.open()
