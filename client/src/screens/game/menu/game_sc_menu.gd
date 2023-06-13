class_name GameScMenu
extends CanvasLayer

var is_open: bool:
    get:
        return $sub.has_node("root")

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
    $sub.add_child(root_layer)
    $sub/root.open()

func close() -> void:
    assert(self.is_open, "game_sc_menu.close() called when the menu is open.")
    $sub/root.close()

func close_subcontrol() -> void:
    assert(self.is_open, "game_sc_menu.close_subcontrol() called when the menu is open.")
    $sub/root.close_subcontrol()

func _ready() -> void:
    # the top-right menu button.
    $menu_button.pressed.connect(func(): self.toggle())

func _input(event: InputEvent) -> void:
    var pause_just_released = event.is_action_released("pause")
    if (event.is_action_released("ui_cancel") or pause_just_released) and self.is_open:
        $sub/root.close_subcontrol()
    elif pause_just_released and not self.is_open:
        self.open()
