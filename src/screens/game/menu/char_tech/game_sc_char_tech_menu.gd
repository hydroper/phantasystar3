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

var _tech_list_container: VBoxContainer = null

func _ready() -> void:
    self._tech_list_container = $tech_selection/container/container/main/scrollable/container

    $outer.pressed.connect(func():
        self.close_sublayer(null))

    $tech_selection.on_popup(func(_goal, _data):
        pass)

    $tech_selection.on_collapse(func(_goal, _data):
        pass)

func _process(_delta: float) -> void:
    if self._tech == null:
        $tech_details.collapse()
    else: $tech_details.popup()

# lists only camp techniques.
func _list_tech() -> void:
    for tech in self._character.learned_tech:
        self._tech_list_container.add_child(self._create_tech_button(tech))

func _create_tech_button(tech: PS3TechType) -> PS3SelectableTechButton:
    var r: PS3SelectableTechButton = preload("res://src/ui/tech/ps3_selectable_tech_button.tscn").instantiate()
    r.display_tech(tech)
    r.get_node("button").pressed.connect(func():
        pass)
    r.get_node("button").focus_entered.connect(func():
        pass)
    r.get_node("button").focus_exited.connect(func():
        pass)
    return r
