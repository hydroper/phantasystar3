class_name GameScPartyOrderMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $remaining.popup()
    $result.popup()
    self._list_selectable()
    self._selectable_list.get_child(0).grab_focus()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $remaining.collapse("close_current_and_parent")
    $result.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    if len(self._result) == 0:
        $remaining.collapse("close_current")
        $result.collapse()
    else:
        var character = self._result.pop_back()
        self._selectable_list.add_child(self._create_selectable_button(character))
        self._result_nodes.remove_child(self._result_nodes.get_child(-1))

var _result: Array[PS3Character] = []
@onready
var _selectable_list = $remaining/container/container/main/scrollable/list
@onready
var _result_nodes = $result/main/scrollable/list

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $remaining.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))

func _list_selectable() -> void:
    for character in self.game_data.party:
        self._selectable_list.add_child(self._create_selectable_button(character))

func _create_selectable_button(character: PS3Character) -> PS3Button:
    var btn = preload("res://src/ui/ps3_button.tscn").instantiate()
    btn.get_node("content/label").text = character.name
    btn.custom_minimum_size.y = 75
    btn.pressed.connect(func():
        self._selectable_list.remove_child(btn)
        self._result.append(character)
        self._result_nodes.add_child(self._create_result_label(character))
        if len(self._result) == len(self.game_data.party):
            self.game_data.party.assign(self._result)
            self.game_data.on_party_order_update.emit()
            self.close(null)
        else:
            self._selectable_list.get_child(0).grab_focus())
    return btn

func _create_result_label(character: PS3Character) -> Node:
    var label := Label.new()
    label.custom_minimum_size.y = 60
    label.text = character.name
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 26)
    return label
