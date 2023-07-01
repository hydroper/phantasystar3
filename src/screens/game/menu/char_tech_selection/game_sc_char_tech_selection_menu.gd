extends UISublayer

var game_data: PS3GameData = null

# data = { character_data }
func open(data: Variant) -> void:
    self._character = data.character_data

    $tech_selection.popup()
    $context/outer.visible = false
    $report/outer.visible = false
    $target_char/outer.visible = false

    self._list_tech()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $tech_selection.collapse("close_current_and_parent")
    $tech_details.collapse()
    $context/context.collapse()
    $report/report.collapse()
    $target_char/target_char.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    if $context/context.is_open:
        $context/context.collapse("close_context")
    elif $report/report.is_open:
        $report/report.collapse("close_report")
    elif $target_char/target_char.is_open:
        $target_char/target_char.collapse("close_target_char")
    else:
        $tech_selection.collapse("close_current")
        $tech_details.collapse()
        $context/context.collapse()
        $report/report.collapse()

var _sublayer: UISublayer = null
var _character: PS3CharacterData = null
var _tech: PS3TechType = null
var _tech_list_container: VBoxContainer = null

func _ready() -> void:
    self._tech_list_container = $tech_selection/container/container/main/scrollable/container

    $outer.pressed.connect(func(): self.close_sublayer(null))
    $context/outer.pressed.connect(func(): self.close_sublayer(null))
    $report/outer.pressed.connect(func(): self.close_sublayer(null))
    $target_char/outer.pressed.connect(func(): self.close_sublayer(null))

    $tech_selection.on_popup.connect(func(_goal, _data):
        pass)

    $tech_selection.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current_and_parent" as Variant))
    
    $context/context.on_popup.connect(func(_goal, _data):
        $context/context/main/container/use_btn.grab_focus())

    $context/context.on_collapse.connect(func(goal, data):
        $context/outer.visible = false
        if goal == "tech_result":
            self._display_result(data.result)
            return
        if goal == "ask_for_party_target":
            self._ask_target_char()
            return
        $tech_selection.temporarily_disabled = false
        if goal == "close_context":
            self._focus_tech_back())

    $report/report.on_collapse.connect(func(goal, _data):
        $report/outer.visible = false
        $tech_selection.temporarily_disabled = false
        if goal == "close_report":
            self._focus_tech_back())

    $target_char/target_char.on_collapse.connect(func(goal, data):
        $target_char/outer.visible = false
        if goal == "tech_result":
            self._display_result(data.result)
            return
        $tech_selection.temporarily_disabled = false
        if goal == "close_target_char":
            self._focus_tech_back())

    $context/context/main/container/use_btn.pressed.connect(func():
        self._use_tech())

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
        self._tech_list_container.get_child(0).button.focus_neighbor_top = self._tech_list_container.get_child(-1).button.get_path()
        # focus_neighbor_bottom
        self._tech_list_container.get_child(-1).button.focus_neighbor_bottom = self._tech_list_container.get_child(0).button.get_path()
        # focus
        self._tech_list_container.get_child(0).button.grab_focus()

func _create_tech_button(tech: PS3TechType) -> PS3SelectableTechButton:
    var btn: PS3SelectableTechButton = preload("res://src/ui/tech/ps3_selectable_tech_button.tscn").instantiate()
    btn.display_tech(tech)
    btn.button.pressed.connect(func():
        self._open_context(btn.button.global_position.y))
    btn.button.focus_entered.connect(func():
        self._tech = tech
        self._update_tech_details())
    btn.button.focus_exited.connect(func():
        # self._tech = null
        pass)
    return btn

func _open_context(y: float) -> void:
    $tech_selection.temporarily_disabled = true
    $context/outer.visible = true
    $context/context.position.y = y
    $context/context.popup()

func _update_tech_details() -> void:
    $tech_details/container/container/main/container/cost/attr/value.text = str(self._tech.cost)
    $tech_details/container/container/main/container/description/attr/value.text = self._tech.description

func _focus_tech_back() -> void:
    var buttons = self._tech_list_container.get_children().filter(func(button): return button.tech == self._tech)
    if len(buttons) != 0:
        buttons[0].button.grab_focus()

func _use_tech() -> void:
    var result = self.game_data.use_tech(self._character, self._tech)
    if result.type == "ask_for_party_target":
        $context/context.collapse("ask_for_party_target")
        self._ask_target_char()
    else:
        $context/context.collapse("tech_result", {result = result})

func _use_tech_for_target_char(character: PS3Character) -> void:
    var result = self.game_data.use_targetted_tech(self._character, self._tech, self.game_data.character(character))
    $target_char/target_char.collapse("tech_result", {result = result})

func _ask_target_char() -> void:
    $target_char/outer.visible = true
    $target_char/target_char.popup()
    var list = $target_char/target_char/container/container/main/scrollable/list
    NodeExtFn.remove_all_children(list)
    for character in self.game_data.party:
        list.add_child(self._create_target_char_btn(character))
    list.get_child(0).grab_focus()
    list.get_child(0).focus_neighbor_top = list.get_child(-1).get_path()
    list.get_child(-1).focus_neighbor_bottom = list.get_child(0).get_path()

func _create_target_char_btn(character: PS3Character) -> PS3Button:
    var btn = preload("res://src/ui/ps3_button.tscn").instantiate()
    btn.get_node("content/label").text = character.name
    btn.custom_minimum_size.y = 64
    btn.pressed.connect(func():
        self._use_tech_for_target_char(character))
    return btn

func _display_result(result: Dictionary) -> void:
    $report/outer.visible = true
    $report/report/main/label.text = PS3Messages.tech_result(result)
    $report/report.popup()
    self.get_viewport().gui_release_focus()
