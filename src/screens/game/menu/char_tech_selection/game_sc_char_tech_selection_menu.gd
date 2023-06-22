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

    $tech_selection.on_popup.connect(func(_goal, _data):
        pass)

    $tech_selection.on_collapse.connect(func(_goal, _data):
        pass)

func _process(_delta: float) -> void:
    if self._tech == null:
        $tech_details.collapse()
    else: $tech_details.popup()

# lists only camp techniques.
func _list_tech() -> void:
    for tech in self._character.learned_tech:
        if tech.available_on_camp:
            self._tech_list_container.add_child(self._create_tech_button(tech))
    if self._tech_list_container.get_child_count() != 0:
        # focus_neighbor_top
        self._tech_list_container.get_child(0).get_node("button").focus_neighbor_top = self._tech_list_container.get_child(-1).get_node("button").get_path()
        # focus_neighbor_bottom
        self._tech_list_container.get_child(-1).get_node("button").focus_neighbor_bottom = self._tech_list_container.get_child(0).get_node("button").get_path()
        # focus
        self._tech_list_container.get_child(0).get_node("button").grab_focus()

func _create_tech_button(tech: PS3TechType) -> PS3SelectableTechButton:
    var btn: PS3SelectableTechButton = preload("res://src/ui/tech/ps3_selectable_tech_button.tscn").instantiate()
    btn.display_tech(tech)
    btn.get_node("button").pressed.connect(func():
        pass)
    btn.get_node("button").focus_entered.connect(func():
        self._tech = tech
        self._update_tech_details())
    btn.get_node("button").focus_exited.connect(func():
        self._tech = null)
    return btn

func _update_tech_details() -> void:
    $tech_details/container/container/main/container/cost/attr/value.text = str(self._tech.cost)
    $tech_details/container/container/main/container/description/attr/value.text = self._tech.description
