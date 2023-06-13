class_name GameScMenu
extends CanvasLayer

var is_open: bool:
    get:
        return self._is_open

var game_data: PS3GameData = null

func toggle() -> void:
    if self.is_open:
        self.close()
    else: self.open()

func open() -> void:
    assert(not self.is_open, "game_sc_menu.open() called when the menu is open.")
    var root_layer = preload("res://src/screens/game/menu/root/game_sc_root_menu.tscn").instantiate()
    root_layer.name = "root"
    root_layer.game_data = self.game_data
    self._is_open = true
    root_layer.on_close.connect(func(_data):
        self._is_open = false)
    $sub.add_child(root_layer)
    $sub/root.open(null)

func close() -> void:
    assert(self.is_open, "game_sc_menu.close() called when the menu is open.")
    $sub/root.close(null)

func close_sublayer() -> void:
    assert(self.is_open, "game_sc_menu.close_sublayer() called when the menu is open.")
    $sub/root.close_sublayer(null)

var _is_open: bool = false

func _ready() -> void:
    # the top-right menu button.
    $menu_button.pressed.connect(func(): self.toggle())

func _input(event: InputEvent) -> void:
    var pause_just_released = event.is_action_released("pause")
    if (event.is_action_released("ui_cancel") or pause_just_released) and self.is_open:
        $sub/root.close_sublayer(null)
    elif pause_just_released and not self.is_open:
        self.open()
