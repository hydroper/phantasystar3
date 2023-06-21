# backup code
$party_target.on_collapse.connect(func(goal, data):
    if goal == "result":
        $tech_result.reset_to_collapsed()
        $tech_result.popup()
        $tech_result/label.text = PS3Messages.tech_result(data.result)
    else:
        self._last_focused_button = self._last_focused_button if self._last_focused_button != null else $back_btn
        self._last_focused_button.grab_focus())

func _use_tech(tech: PS3TechType) -> void:
    var result = self.game_data.use_tech(self.game_data.characters[self.opened_character], tech)
    if result.type == "ask_for_party_target":
        self._select_party_target(tech)
    else:
        $tech_result.reset_to_collapsed()
        $tech_result.popup()
        self.get_viewport().gui_release_focus()
        $tech_result/label.text = PS3Messages.tech_result(result)

func _select_party_target(tech: PS3TechType) -> void:
    $party_target.reset_to_collapsed()
    NodeExtFn.remove_all_children($party_target/scrollable/list)
    for character_type in self.game_data.party:
        var character = self.game_data.characters[character_type]
        var btn = preload("res://src/ui/ps3_round_big_button.tscn").instantiate()
        btn.meta_data = { "char": character }
        btn.get_node("control/label").text = character.name
        btn.size_flags_horizontal |= Control.SizeFlags.SIZE_EXPAND
        btn.pressed.connect(func():
            var btn2 = NodeExtFn.get_pressed_button($party_target/scrollable/list)
            var result = self.game_data.use_targetted_tech(self.game_data.characters[self.opened_character], tech, btn2.meta_data.char)
            $party_target.collapse("result", { "result": result }))
        $party_target/scrollable/list.add_child(btn)
    $party_target.popup()
    $party_target/scrollable/list.get_child(0).grab_focus()