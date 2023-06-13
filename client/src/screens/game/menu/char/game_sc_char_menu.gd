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
        self.char_list.add_child(char_btn)
    self._selected_character = data.character if data is PS3Character else self.game_data.party[0]
    self._update_status()
    $list.popup()
    $status.popup()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    $list.collapse("close_current_and_parent")
    $status.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    $list.collapse("close_current")
    $status.collapse()

@onready 
var char_list = $list/container/container/main/scrollable/list

var _sublayer: UISublayer = null

var _selected_character: PS3Character = null

func _ready() -> void:
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $list.on_popup.connect(func(_goal, _data):
        self.char_list.get_children().filter(func(a): return (a as PS3Button).meta_data == self._selected_character)[0].grab_focus())
    $list.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null if goal == "close_current" else "close_current"))

func _update_status() -> void:
    pass
