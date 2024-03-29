class_name GameScItemsMenu
extends UISublayer

var game_data: PS3GameData = null

static var _tabs: Dictionary = {
    0: "all",
    1: "weapon",
    2: "armor",
    3: "consumable",
}

func open(_data: Variant) -> void:
    $items.popup()
    $context/outer.visible = false
    $report/outer.visible = false
    $target_char/outer.visible = false
    self._update_items()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $items.collapse("close_current_and_parent")
    $item_details.collapse()
    $context/context.collapse()
    $report/report.collapse()
    $target_char/target_char.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    if $context/context.is_open:
        $context/context.collapse("close_context")
    elif $report/report.is_open:
        $report/report.collapse("close_report")
    elif $target_char/target_char.is_open:
        $target_char/target_char.collapse("close_target_char")
    else:
        $items.collapse("close_current")
        $item_details.collapse()
        $context/context.collapse()
        $report/report.collapse()

var _sublayer: UISublayer = null
var _selected_item: PS3Item
@onready
var _tab_bar = $items/container/container/main/container/tabs
@onready
var _items_container = $items/container/container/main/container/scrollable/list
@onready
var _subpanels: Array[PS3BaseAnimatedPanel] = [$context/context, $report/report, $target_char/target_char]
@onready
var _sort_btn: Button = $items/container/container/main/container/sort_btn

func _ready() -> void:
    # outer
    $outer.pressed.connect(func(): self.close_sublayer(null))
    $context/outer.pressed.connect(func(): self.close_sublayer(null))
    $report/outer.pressed.connect(func(): self.close_sublayer(null))
    $target_char/outer.pressed.connect(func(): self.close_sublayer(null))

    self._tab_bar.tab_changed.connect(func(_tab):
        self._selected_item = null
        self._update_items()
        # reset scroll
        $items/container/container/main/container/scrollable.scroll_vertical = 0)

    # tab bar scroll follow
    PS3TabBarScrollFollow.apply(self._tab_bar, $items/container/container/main/container/tabs/content/tabs/scrollable)

    $items.on_collapse.connect(func(goal, _data):
        if goal == "close_current" or goal == "close_current_and_parent":
            super.close(null as Variant if goal == "close_current" else "close_current" as Variant))

    $item_details.on_collapse.connect(func(_goal, _data):
        pass)

    # sort button
    self._sort_btn.pressed.connect(func():
        self.game_data.items.sort_custom(func(a, b): return b.name > a.name)
        self._selected_item = null
        self._update_items()
        # reset scroll
        $items/container/container/main/container/scrollable.scroll_vertical = 0)

    # use button
    $context/context/main/list/use_btn.pressed.connect(func():
        pass)

    # drop button
    $context/context/main/list/drop_btn.pressed.connect(func():
        pass)

    $context/context.on_popup.connect(func(_goal, _data):
        $context/context/main/list/use_btn.grab_focus())

    $context/context.on_collapse.connect(func(goal, _data):
        $context/outer.visible = false
        $items.temporarily_disabled = false
        if goal == "close_context":
            self._focus_item_again()
        elif goal == "to_use":
            self._use()
        elif goal == "to_drop":
            self._drop())

    $context/context/main/list/use_btn.pressed.connect(func():
        $context/context.collapse("to_use"))

    $context/context/main/list/drop_btn.pressed.connect(func():
        $context/context.collapse("to_drop"))

    $report/report.on_collapse.connect(func(goal, _data):
        $report/outer.visible = false
        $items.temporarily_disabled = false
        if goal == "close_report": self._reflect_drop_or_focus_item_again())

    $target_char/target_char.on_collapse.connect(func(goal, data):
        $target_char/outer.visible = false
        $items.temporarily_disabled = false
        if goal == "use_item":
            self._use_targetted(data.character)
            return
        if goal == "close_target_char":
            self._focus_item_again()
            return)

func _process(_delta: float) -> void:
    if self._selected_item == null:
        $item_details.collapse()
    else: $item_details.popup()

func _input(event: InputEvent) -> void:
    if self._sublayer != null or self._subpanels.any(func(p): return p.is_open):
        return
    self._tab_bar.current_tab += -1 if event.is_action_released("ui_left") else 1 if event.is_action_released("ui_right") else 0

var _tab_type: String:
    get:
        return GameScItemsMenu._tabs[self._tab_bar.current_tab]

func _update_items() -> void:
    var type = self._tab_type
    NodeUtil.remove_all_children(self._items_container)

    var criteria: Callable

    if type == "all":
        criteria = func(_item): return true
    elif type == "weapon":
        criteria = func(item): return item.type.category == PS3ItemCategory.WEAPON
    elif type == "armor":
        criteria = func(item): return item.type.category.is_armor
    elif type == "consumable":
        criteria = func(item): return item.type.category == PS3ItemCategory.CONSUMABLE
    else: assert(type == "all")

    for item in self.game_data.items.filter(criteria):
        self._items_container.add_child(self._create_item_button(item))

    if self._items_container.get_child_count() == 0:
        self._sort_btn.focus_neighbor_top = ""
        self._sort_btn.focus_neighbor_bottom = ""
        self._selected_item = null
    else:
        self._items_container.get_child(0).button.focus_neighbor_top = self._sort_btn.get_path()
        self._sort_btn.focus_neighbor_top = self._items_container.get_child(-1).button.get_path()
        self._sort_btn.focus_neighbor_bottom = self._items_container.get_child(0).button.get_path()
        self._items_container.get_child(0).button.grab_focus()
        self._selected_item = self._items_container.get_child(0).item

func _create_item_button(item: PS3Item) -> PS3SelectableItemButton:
    var btn = preload("res://src/ui/inventory/ps3_selectable_item_button.tscn").instantiate()
    btn.display_item(item)
    btn.is_equipped = false
    btn.button.pressed.connect(self._show_context)
    btn.button.focus_entered.connect(func():
        self._update_item_details(btn.item))
    btn.button.focus_exited.connect(func():
        pass)
    return btn

func _show_context() -> void:
    var btn = PS3SelectableItemButton.get_pressed_from_list(self._items_container)
    # self._update_item_details(btn.item)
    $context/context.position.y = btn.button.global_position.y
    $context/context.popup()
    $context/outer.visible = true
    $items.temporarily_disabled = true

@onready
var _details_container: ScrollContainer = $item_details/container/container/main/scrollable

func _update_item_details(item: PS3Item) -> void:
    self._selected_item = item
    if item == null:
        return
    self._details_container.get_node("list/name").text = item.name
    self._details_container.get_node("list/scrollable_description/description").text = item.description

# Called when, for example, the context menu collapses and returns
# to the item selector.
func _focus_item_again() -> void:
    var m = self._items_container.get_children().filter(func(btn): return btn.item == self._selected_item)
    $items.temporarily_disabled = false
    if len(m) != 0:
        m[0].button.grab_focus()
    elif self._items_container.get_child_count() != 0:
        self._items_container.get_child(0).button.grab_focus()

func _show_report() -> void:
    $report/report.popup()
    $report/outer.visible = true
    $items.temporarily_disabled = true

func _use() -> void:
    $items.temporarily_disabled = true
    var result = self.game_data.use_item(self._selected_item)
    if result.type == "ask_for_party_target":
        self._show_party_target_selection()
    else:
        $report/report/main/label.text = PS3Messages.item_result(result)
        self._show_report()

func _use_targetted(target: Variant) -> void:
    $items.temporarily_disabled = true
    var result = self.game_data.use_targetted_item(self._selected_item, target)
    $report/report/main/label.text = PS3Messages.item_result(result)
    self._show_report()

func _show_party_target_selection() -> void:
    var list = $target_char/target_char/container/container/main/scrollable/list
    NodeUtil.remove_all_children(list)
    for character in self.game_data.party:
        list.add_child(self._create_party_target_button(character))
    list.get_child(0).grab_focus()
    list.get_child(0).focus_neighbor_top = list.get_child(-1).get_path()
    list.get_child(-1).focus_neighbor_bottom = list.get_child(0).get_path()
    $target_char/outer.visible = true
    $target_char/target_char.popup()

func _create_party_target_button(character: PS3Character) -> Button:
    var char_data := self.game_data.character(character)
    var btn = preload("res://src/ui/ps3_button.tscn").instantiate()
    btn.custom_minimum_size.y = 90
    btn.get_node("content/label").text = char_data.name
    btn.pressed.connect(func():
        $target_char/target_char.collapse("use_item", {character = char_data}))
    return btn

func _drop() -> void:
    self._selected_item.quantity -= 1
    self._reflect_drop_or_focus_item_again()
    $items.temporarily_disabled = false

func _reflect_drop_or_focus_item_again() -> void:
    var btn = self._items_container.get_children().filter(func(btn): return btn.item == self._selected_item)[0]
    if self._selected_item.quantity == 0:
        self.game_data.items.remove_at(self.game_data.items.find(self._selected_item))
        self._selected_item = null
        var i = NodeUtil.child_index_from_parent(btn)
        self._items_container.remove_child(btn)
        if self._items_container.get_child_count() == 0:
            i = 0
        if self._items_container.get_child_count() != 0:
            self._items_container.get_child(i).button.grab_focus()
    else:
        btn.display_item(self._selected_item)
        btn.button.grab_focus()
