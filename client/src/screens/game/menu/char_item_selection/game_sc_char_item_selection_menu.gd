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
    $context/outer.visible = false
    $context/context.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(data: Variant) -> void:
    if $context/context.is_open:
        $context/outer.visible = false
        NodeExtFn.enable($item_selector)
        $context/context.collapse("close_context")
    else:
        $item_selector.collapse("close_current")
        $item_details.collapse()
        $context/outer.visible = false
        $context/context.collapse()

var _sublayer: UISublayer

var _selected_item: PS3Item

@onready
var _tab_bar = $item_selector/container/container/main/container/tabs

@onready
var _items_container = $item_selector/container/container/main/container/scrollable/list

var _selected_character: PS3Character

var _context_selected_item: PS3Item

func _ready() -> void:
    $outer.pressed.connect(func():
        self.close_sublayer(null))
    $context/outer.pressed.connect(func():
        if $context/context.is_open:
            self.close_sublayer(null))
    self._tab_bar.tab_changed.connect(func(_tab):
        self._update_items())
    $item_selector.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current_and_parent" as Variant))
    $item_details.on_collapse.connect(func(goal, _data):
        pass)
    $context/context/main/list/equip_btn.pressed.connect(func():
        pass)
    $context/context/main/list/unequip_btn.pressed.connect(func():
        pass)
    $context/context.on_popup.connect(func(goal, _data):
        var equip = goal == "equip"
        $context/context/main/list/equip_btn.disabled = not equip
        $context/context/main/list/unequip_btn.disabled = equip
        if equip:
            $context/context/main/list/equip_btn.grab_focus()
        else:
            $context/context/main/list/unequip_btn.grab_focus())
    $context/context.on_collapse.connect(func(goal, _data):
        if goal == "close_context":
            self._selected_item = self._context_selected_item
            var m = self._items_container.get_children().filter(func(btn): return btn.item == self._selected_item)
            NodeExtFn.enable($item_selector)
            if len(m) != 0:
                m[0].get_node("button").grab_focus())

func _process(_delta: float) -> void:
    if self._selected_item == null:
        $item_details.collapse()
    else: $item_details.popup()

func _input(event: InputEvent) -> void:
    if self._sublayer != null or $context/context.is_open:
        return
    if event.is_action_released("ui_left") and not self._any_tab_focused:
        self._tab_bar.current_tab -= 1
    elif event.is_action_released("ui_right") and not self._any_tab_focused:
        self._tab_bar.current_tab += 1

var _any_tab_focused: bool:
    get:
        return NodeExtFn.get_focused(self._tab_bar.get_node("content/tabs")) != null

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
        self._update_item_details(btn.item)
        self._context_selected_item = btn.item
        $context/context.position.y = btn.get_node("button").global_position.y
        $context/context.popup("unequip" if btn.is_equipped else "equip")
        $context/outer.visible = true
        NodeExtFn.disable($item_selector))
    r.get_node("button").focus_entered.connect(func():
        var btn = PS3SelectableItemButton.get_focused_from_list(self._items_container)
        self._update_item_details(btn.item))
    r.get_node("button").focus_exited.connect(func():
        var btn = PS3SelectableItemButton.get_focused_from_list(self._items_container)
        self._update_item_details(btn.item if btn != null else self._context_selected_item))
    return r

@onready
var _details_container: VBoxContainer = $item_details/container/container/main/container

func _update_item_details(item: PS3Item) -> void:
    self._selected_item = item
    if item == null:
        return
    var character: PS3CharacterData = self.game_data.characters[self._selected_character]
    var status = character.status_if_equipped(item)
    self._details_container.get_node("damage/attr/value").text = str(status.damage) + " (" + ("+" if status.damage_diff >= 0 else "") + str(status.damage_diff) + ")"
    self._details_container.get_node("defense/attr/value").text = str(status.defense) + " (" + ("+" if status.defense_diff >= 0 else "") + str(status.defense_diff) + ")"
    self._details_container.get_node("speed/attr/value").text = str(status.speed) + " (" + ("+" if status.speed_diff >= 0 else "") + str(status.speed_diff) + ")"
