class_name PS3GameScMacroMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $macros.popup()
    $preview.popup()
    $context/outer.visible = false
    self._list_macros()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $macros.collapse("close_current_and_parent")
    $preview.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    $macros.collapse("close_current")
    $preview.collapse()

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $macros.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))

func _list_macros() -> void:
    var ul = $macros/container/container/main/scrollable/list
    for i in range(0, len(self.game_data.macros)):
        ul.add_child(self._create_macro_btn(i))
    ul.get_child(0).focus_neighbor_top = ul.get_child(-1).get_path()
    ul.get_child(-1).focus_neighbor_bottom = ul.get_child(0).get_path()
    ul.get_child(0).grab_focus()

func _create_macro_btn(index: int) -> Button:
    var macro = self.game_data.macros[index]
    var btn = preload("res://src/ui/ps3_button.tscn").instantiate()
    btn.custom_minimum_size.y = 75
    btn.get_node("content/label").text = macro.letter
    return btn

func _preview(macro: PS3Macro) -> void:
    var ul = $preview/container/container/main/scrollable/list
    NodeUtil.remove_all_children(ul)
    for turn in macro.party_turns:
        var turn_preview = preload("res://src/ui/macro/ps3_macro_turn_preview.tscn").instantiate()
        turn_preview.display_turn(turn)
        ul.add_child(turn_preview)
