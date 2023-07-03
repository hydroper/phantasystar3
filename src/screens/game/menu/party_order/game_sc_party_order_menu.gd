class_name GameScPartyOrderMenu
extends UISublayer

var game_data: PS3GameData = null

func open(_data: Variant) -> void:
    $remaining.popup()
    $result.popup()
    self._list_selectable()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $remaining.collapse("close_current_and_parent")
    $result.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    $remaining.collapse("close_current")
    $result.collapse()

var _result: Array[PS3Character] = []
@onready
var _selectable_list = $remaining/container/container/main/scrollable/list

func _ready() -> void:
    # outer
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
    return btn
