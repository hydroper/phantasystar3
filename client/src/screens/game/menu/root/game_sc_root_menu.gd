extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    $menu.visible = true
    NodeExtFn.enable($menu/list)
    if self._last_focused_button == null:
        $menu/list/items_btn.grab_focus()
    else: self._last_focused_button.grab_focus()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    if self._sublayer == null:
        super.close(data)
    else:
        self._sublayer.close("close_current")

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    if self._sublayer == null:
        self.close(data)
    else:
        self._sublayer.close(data)

var _sublayer: UISublayer = null

var _last_focused_button: Control = null

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))

    $menu/list/char_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/char_btn
        self._open_characters())

func _open_characters() -> void:
    NodeExtFn.disable($menu/list)
    var sublayer = preload("res://src/screens/game/menu/char/game_sc_char_menu.tscn").instantiate()
    sublayer.game_data = self.game_data
    sublayer.on_close.connect(func(data):
        self._sublayer = null
        if data == "close_current":
            self.close(null)
        else:
            self.open(null))
    self._sublayer = sublayer
    self.add_child(sublayer)
    sublayer.open(null)
