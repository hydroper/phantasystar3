extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    # data is PS3Character
    self._selected_character = data
    $item_selector.popup()
    self._update_items()

# Closes any sublayer and the current layer itself.
func close(data: Variant) -> void:
    $item_selector.collapse("close_current_and_parent")
    $item_details.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    $item_selector.collapse("close_current")
    $item_details.collapse()

@onready
var _tab_bar = $item_selector/container/container/main/container/tabs

@onready
var _items_container = $item_selector/container/container/main/container/scrollable/list

var _selected_character: PS3Character

func _ready() -> void:
    self._tab_bar.tab_changed.connect(func(_tab):
        self._update_items())
    $item_selector.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))
    $outer.pressed.connect(func():
        self.close_sublayer(null))

func _update_items() -> void:
    var type = "left_hand" if self._tab_bar.current_tab == 0 else "right_hand" if self._tab_bar.current_tab == 1 else "armor"
    NodeExtFn.remove_all_children(self._items_container)
    var character: PS3CharacterData = self.game_data.characters[self._selected_character]

    if type == "left_hand" or type == "right_hand":
        if character.left_hand != null and type == "left_hand":
            self._items_container.add_child(self._create_item_button(character.left_hand, true))
        if character.right_hand != null and type == "right_hand":
            self._items_container.add_child(self._create_item_button(character.right_hand, true))
        for item in self.game_data.items:
            if item.type.category == PS3ItemCategory.WEAPON and character.can_equip(item):
                self._items_container.add_child(self._create_item_button(item, false))
    else:
        # armor
        if character.head != null:
            self._items_container.add_child(self._create_item_button(character.head, true))
        if character.torso != null:
            self._items_container.add_child(self._create_item_button(character.torso, true))
        if character.feet != null:
            self._items_container.add_child(self._create_item_button(character.feet, true))
        if character.buckle != null:
            self._items_container.add_child(self._create_item_button(character.buckle, true))
        for item in self.game_data.items:
            if item.type.category.is_armor and character.can_equip(item):
                self._items_container.add_child(self._create_item_button(item, false))

    if self._items_container.get_child_count() == 0:
        self._tab_bar.get_node("content/tabs/" + type).grab_focus()
    else:
        self._items_container.get_child(0).get_node("button").grab_focus()

func _create_item_button(item: PS3Item, equipped: bool) -> PS3SelectableItemButton:
    var r = preload("res://src/ui/inventory/ps3_selectable_item_button.tscn").instantiate()
    r.display_item(item)
    r.is_equipped = equipped
    r.get_node("button").pressed.connect(func():
        var btn = PS3SelectableItemButton.get_pressed_from_list(self._items_container)
        pass)
    r.get_node("button").focus_entered.connect(func():
        var btn = PS3SelectableItemButton.get_focused_from_list(self._items_container)
        pass)
    r.get_node("button").focus_exited.connect(func():
        pass)
    return r
