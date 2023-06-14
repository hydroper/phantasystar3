class_name PS3SelectableItemButton
extends Control

var item: PS3Item

var is_equipped: bool:
    get:
        return self._is_equipped
    set(value):
        self._is_equipped = value
        $button/content/container/equipped.modulate.a = 1.0 if self.is_equipped else 0.0

func display_item(item: PS3Item) -> void:
    self.item = item
    $button/content/container/right/label.text = self.item.name

static func get_pressed_from_list(list: Variant) -> PS3SelectableItemButton:
    if list is Array:
        var f = list.filter(func(a): return a.get_node("button").button_pressed)
        return null if len(f) == 0 else f[0]
    return PS3SelectableItemButton.get_pressed_from_list(list.get_children()) if list is Node else null

static func get_focused_from_list(list: Variant) -> PS3SelectableItemButton:
    if list is Array:
        var f = list.filter(func(a): return a.get_node("button").has_focus())
        return null if len(f) == 0 else f[0]
    return PS3SelectableItemButton.get_focused_from_list(list.get_children()) if list is Node else null

func _ready():
    $button/content/container/equipped.modulate.a = 0

var _is_equipped: bool = false
