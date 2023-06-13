extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    NodeExtFn.remove_all_children(self.char_list)
    for character_type in self.game_data.party:
        var character = self.game_data.characters[character_type]
        var char_btn = preload("res://src/ui/ps3_button.tscn").instantiate()
        char_btn.meta_data = character_type
        char_btn.get_node("content/label").text = character.name
        char_btn.custom_minimum_size.y = 75
        char_btn.focus_entered.connect(func():
            self._selected_character = (NodeExtFn.get_focused(self.char_list) as PS3Button).meta_data
            self._update_status())
        char_btn.pressed.connect(func():
            var pressed_btn = NodeExtFn.get_pressed_button(self.char_list)
            $context/context.position.y = pressed_btn.global_position.y
            $context/context.popup()
            $context/outer.visible = true
            $context/context/main/list/equip_btn.grab_focus())
        self.char_list.add_child(char_btn)
    self.char_list.get_child(0).focus_neighbor_top = self.char_list.get_child(-1).get_path()
    self.char_list.get_child(-1).focus_neighbor_bottom = self.char_list.get_child(0).get_path()
    self._selected_character = data.character if data is PS3Character else self.game_data.party[0]
    self._update_status()
    $list.popup()
    $status.popup()
    $context/outer.visible = false
    $context/context.collapse()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    $list.collapse("close_current_and_parent")
    $status.collapse()
    $context/outer.visible = false
    $context/context.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    if $context/context.is_open:
        $context/outer.visible = false
        $context/context.collapse("close_context")
    else:
        $list.collapse("close_current")
        $context/outer.visible = false
        $context/context.collapse()
        $status.collapse()

var char_list: VBoxContainer

var _sublayer: UISublayer = null

var _selected_character: PS3Character = null

func _ready() -> void:
    self.char_list = $list/container/container/main/scrollable/list
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $list.on_popup.connect(func(_goal, _data):
        self._focus_char_btn())
    $list.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null if goal == "close_current" else "close_current"))
    $context/outer.pressed.connect(func():
        if $context/context.is_open:
            self.close_sublayer(null))
    $context/context.on_collapse.connect(func(goal, _data):
        if goal == "close_context":
            self._focus_char_btn())
    $context/context/main/list/equip_btn.pressed.connect(func():
        pass)

func _focus_char_btn() -> void:
    self.char_list.get_children().filter(func(a): return (a as PS3Button).meta_data == self._selected_character)[0].grab_focus()

func _update_status() -> void:
    var character = self.game_data.characters[self._selected_character]
    $status/container/container/header/label.text = character.name
    $status/container/container/main/horizontal_list/portrait.texture = character.portrait_texture
    $status/container/container/main/horizontal_list/scrollable/list/meseta/attr/value.text = NumberExtFn.comma_sep(self.game_data.meseta)
    $status/container/container/main/horizontal_list/scrollable/list/hp/attr/value.text = NumberExtFn.comma_sep(character.hp) + "/" + NumberExtFn.comma_sep(character.max_hp)
    $status/container/container/main/horizontal_list/scrollable/list/tp/attr/value.text = NumberExtFn.comma_sep(character.tp) + "/" + NumberExtFn.comma_sep(character.max_tp)
    $status/container/container/main/horizontal_list/scrollable/list/level/attr/value.text = str(character.level)
    $status/container/container/main/horizontal_list/scrollable/list/needed_exp/attr/value.text = NumberExtFn.comma_sep(character.level_exp_goal - character.level_exp)
    $status/container/container/main/horizontal_list/scrollable/list/speed/attr/value.text = NumberExtFn.comma_sep(character.speed)
    $status/container/container/main/horizontal_list/scrollable/list/damage/attr/value.text = NumberExtFn.comma_sep(character.damage)
    $status/container/container/main/horizontal_list/scrollable/list/defense/attr/value.text = NumberExtFn.comma_sep(character.defense)
    $status/container/container/main/horizontal_list/scrollable/list/intellect/attr/value.text = NumberExtFn.comma_sep(character.intellect)
    $status/container/container/main/horizontal_list/scrollable/list/stamina/attr/value.text = NumberExtFn.comma_sep(character.stamina)
    $status/container/container/main/horizontal_list/scrollable/list/luck/attr/value.text = NumberExtFn.comma_sep(character.luck)
    $status/container/container/main/horizontal_list/scrollable/list/skill/attr/value.text = NumberExtFn.comma_sep(character.skill)
