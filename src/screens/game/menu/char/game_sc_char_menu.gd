extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    NodeUtil.remove_all_children(self._char_list)
    for character_type in self.game_data.party:
        var character = self.game_data.character(character_type)
        var char_btn = preload("res://src/ui/ps3_button.tscn").instantiate()
        char_btn.meta_data = character_type
        char_btn.get_node("content/label").text = character.name
        char_btn.custom_minimum_size.y = 75
        char_btn.focus_entered.connect(func():
            self._selected_character = (NodeUtil.get_focused(self._char_list) as PS3Button).meta_data
            self._update_status())
        char_btn.pressed.connect(func():
            var pressed_btn = NodeUtil.get_pressed_button(self._char_list)
            $context/context.position.y = pressed_btn.global_position.y
            $context/context.popup()
            $context/outer.visible = true
            $context/context/main/list/select_item_btn.grab_focus())
        self._char_list.add_child(char_btn)
    self._char_list.get_child(0).focus_neighbor_top = self._char_list.get_child(-1).get_path()
    self._char_list.get_child(-1).focus_neighbor_bottom = self._char_list.get_child(0).get_path()
    self._selected_character = data if data is PS3Character else self.game_data.party[0]
    self._update_status()
    $list.popup()
    $status.popup()
    $context/outer.visible = false
    $context/context.collapse()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    if data == "close_current_and_parent_from_item_selection" or data == "close_current_and_parent_from_tech_selection":
        super.close("close_current")
    elif self._sublayer == null:
        $list.collapse("close_current_and_parent")
        $status.collapse()
        $context/context.collapse()
    else:
        self._sublayer.close("close_current")

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    if self._sublayer != null:
        self._sublayer.close_sublayer(data)
    elif $context/context.is_open:
        $context/context.collapse("close_context")
    else:
        $list.collapse("close_current")
        $context/context.collapse()
        $status.collapse()

var _char_list: VBoxContainer
var _sublayer: UISublayer = null
var _selected_character: PS3Character = null

func _ready() -> void:
    self._char_list = $list/container/container/main/scrollable/list
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $list.on_popup.connect(func(_goal, _data):
        self._focus_char_btn())
    $list.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant)
        elif goal == "open_item_selection":
            self._open_item_selection()
        elif goal == "open_tech_selection":
            self._open_tech_selection())
    $context/outer.pressed.connect(func():
        if $context/context.is_open:
            self.close_sublayer(null))
    $context/context.on_collapse.connect(func(goal, _data):
        $context/outer.visible = false
        if goal == "close_context":
            self._focus_char_btn())
    $context/context/main/list/select_item_btn.pressed.connect(func():
        $list.collapse("open_item_selection")
        $context/context.collapse()
        $status.collapse())
    $context/context/main/list/tech_btn.pressed.connect(func():
        $list.collapse("open_tech_selection")
        $context/context.collapse()
        $status.collapse())

func _focus_char_btn() -> void:
    self._char_list.get_children().filter(func(a): return (a as PS3Button).meta_data == self._selected_character)[0].grab_focus()

func _update_status() -> void:
    var character = self.game_data.character(self._selected_character)
    $status/container/container/header/label.text = character.name
    var hl = $status/container/container/main/horizontal_list
    var vl = hl.get_node("scrollable/list")
    hl.get_node("portrait").texture = character.portrait_texture
    vl.get_node("meseta/attr/value").text = NumberUtil.comma_sep(self.game_data.meseta)
    vl.get_node("hp/attr/value").text = NumberUtil.comma_sep(character.hp) + "/" + NumberUtil.comma_sep(character.max_hp)
    vl.get_node("tp/attr/value").text = NumberUtil.comma_sep(character.tp) + "/" + NumberUtil.comma_sep(character.max_tp)
    vl.get_node("level/attr/value").text = str(character.level)
    vl.get_node("needed_exp/attr/value").text = NumberUtil.comma_sep(character.level_exp_goal - character.level_exp)
    vl.get_node("speed/attr/value").text = NumberUtil.comma_sep(character.speed)
    vl.get_node("damage/attr/value").text = NumberUtil.comma_sep(character.damage)
    vl.get_node("defense/attr/value").text = NumberUtil.comma_sep(character.defense)
    vl.get_node("intellect/attr/value").text = NumberUtil.comma_sep(character.intellect)
    vl.get_node("stamina/attr/value").text = NumberUtil.comma_sep(character.stamina)
    vl.get_node("luck/attr/value").text = NumberUtil.comma_sep(character.luck)
    vl.get_node("skill/attr/value").text = NumberUtil.comma_sep(character.skill)

func _open_item_selection() -> void:
    var sublayer = preload("res://src/screens/game/menu/char_item_selection/game_sc_char_item_selection_menu.tscn").instantiate()
    sublayer.game_data = self.game_data
    sublayer.on_close.connect(func(data):
        self._sublayer = null
        if data == "close_current_and_parent":
            self.close("close_current_and_parent_from_item_selection")
        else:
            self.open(self._selected_character))
    self._sublayer = sublayer
    self.add_child(sublayer)
    sublayer.open(self._selected_character)

func _open_tech_selection() -> void:
    var sublayer = preload("res://src/screens/game/menu/char_tech_selection/game_sc_char_tech_selection_menu.tscn").instantiate()
    sublayer.game_data = self.game_data
    sublayer.on_close.connect(func(data):
        self._sublayer = null
        if data == "close_current_and_parent":
            self.close("close_current_and_parent_from_tech_selection")
        else:
            self.open(self._selected_character))
    self._sublayer = sublayer
    self.add_child(sublayer)
    sublayer.open({character_data = self.game_data.character(self._selected_character)})
