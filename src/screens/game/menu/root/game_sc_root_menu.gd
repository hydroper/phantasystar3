extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $menu.visible = true
    self._temporarily_disabled.disabled = false
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
        self._sublayer.close_sublayer(data)

var _sublayer: UISublayer = null
var _last_focused_button: Control = null
var _temporarily_disabled: TemporarilyDisabled

func _ready() -> void:
    self._temporarily_disabled = TemporarilyDisabled.new($menu/list)
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $menu/list/items_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/items_btn
        self._open_items())
    $menu/list/char_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/char_btn
        self._open_characters())
    $menu/list/party_order_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/party_order_btn
        self._open_party_order())
    $menu/list/macro_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/macro_btn
        self._open_macro())
    $menu/list/log_out_btn.pressed.connect(func():
        self._last_focused_button = $menu/list/log_out_btn
        self._open_logout())

func _open_items() -> void:
    self._temporarily_disabled.disabled = true
    var sublayer = preload("res://src/screens/game/menu/items/game_sc_items_menu.tscn").instantiate()
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

func _open_characters() -> void:
    self._temporarily_disabled.disabled = true
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

func _open_party_order() -> void:
    self._temporarily_disabled.disabled = true
    var sublayer = preload("res://src/screens/game/menu/party_order/game_sc_party_order_menu.tscn").instantiate()
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

func _open_macro() -> void:
    self._temporarily_disabled.disabled = true
    var sublayer = preload("res://src/screens/game/menu/macro/game_sc_macro_menu.tscn").instantiate()
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

func _open_logout() -> void:
    self._temporarily_disabled.disabled = true
    var sublayer = preload("res://src/screens/game/menu/logout/game_sc_logout_menu.tscn").instantiate()
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
