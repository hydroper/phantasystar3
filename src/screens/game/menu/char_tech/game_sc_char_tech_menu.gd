extends UISublayer

var game_data: PS3GameData = null

# data = { character_data }
func open(data: Variant) -> void:
    self._character = data.character_data

    $tech_selection.popup()
    $context/outer.visible = false
    $report/outer.visible = false
    self._list_tech()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    pass

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    pass

var _character: PS3CharacterData = null

var _tech: PS3TechType = null

func _ready() -> void:
    $outer.pressed.connect(func():
        self.close_sublayer(null))

    $tech_selection.on_popup(func(_goal, _data):
        pass)

    $tech_selection.on_collapse(func(_goal, _data):
        pass)

func _process(_delta: float) -> void:
    pass

# lists only camp techniques.
func _list_tech() -> void:
    to_do()
