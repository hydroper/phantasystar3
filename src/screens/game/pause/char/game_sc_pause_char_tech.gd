extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = [
    $party_target,
    $tech_result,
]

var opened_character: PS3Character

var _last_focused_button: Control = null

func _ready():
    self.close_subsequent_recursive()
    $back_btn.pressed.connect(func():
        self.get_node("../..").close_subsequent())
    $party_target.on_outer_click.connect(func():
        $party_target.collapse())
    $party_target.on_collapse.connect(func(goal, data):
        if goal == "result":
            $tech_result.reset_to_collapsed()
            $tech_result.popup()
            $tech_result/label.text = PS3Messages.tech_result(data.result)
        else:
            self._last_focused_button = self._last_focused_button if self._last_focused_button != null else $back_btn
            self._last_focused_button.grab_focus())
    $tech_result.on_outer_click.connect(func():
        $tech_result.collapse())
    $tech_result.on_collapse.connect(func(_goal, _data):
        self._last_focused_button = self._last_focused_button if self._last_focused_button != null else $back_btn
        self._last_focused_button.grab_focus())

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func open_root(character_type: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.opened_character = character_type
    self.visible = true
    $tech_description.visible = false
    NodeExtFn.remove_all_children($scroll_list/list)
    var character = self.game_data.characters[character_type]
    for tech in character.learned_tech:
        $scroll_list/list.add_child(self.create_tech_button(tech))
    if $scroll_list/list.get_child_count() > 0:
        $scroll_list/list.get_child(0).grab_focus()
        $scroll_list/list.get_child(0).focus_neighbor_top = $back_btn.get_path()
        self._last_focused_button = $scroll_list/list.get_child(0)
        $back_btn.focus_neighbor_bottom = $scroll_list/list.get_child(0).get_path()
    else:
        $back_btn.focus_neighbor_bottom = null
        $back_btn.grab_focus()
        self._last_focused_button = $back_btn

func create_tech_button(tech_1: PS3TechType) -> PS3RoundMediumButton:
    var r = preload("res://src/ui/ps3_round_medium_button.tscn").instantiate()
    r.meta_data = tech_1
    r.get_node("control/label").text = tech_1.name
    # r.tooltip_text = tech_1.description
    r.pressed.connect(func():
        var btn2 = NodeExtFn.get_pressed_button($scroll_list/list)
        self._last_focused_button = btn2
        var tech_2 = btn2.meta_data
        self._use_tech(tech_2))
    r.focus_entered.connect(func():
        var tech_2 = NodeExtFn.get_focused($scroll_list/list).meta_data
        $tech_description.visible = true
        $tech_description/label.text = "[i]" + tech_2.name + ":[/i] " + tech_2.description)
    r.focus_exited.connect(func():
        $tech_description.visible = false)
    return r

func close_subsequent() -> void:
    if $party_target.is_open:
        $party_target.collapse()
    elif $tech_result.is_open:
        $tech_result.collapse()
    else:
        self._last_focused_button = null
        self.visible = false

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
            var result = self.game_data.use_targetted_tech(self.game_data.characters[self.opened_character], tech, btn.meta_data.char)
            $party_target.collapse("result", { "result": result }))
        $party_target/scrollable/list.add_child(btn)
    $party_target.popup()
    $party_target/scrollable/list.get_child(0).grab_focus()
