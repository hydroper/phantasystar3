class_name PS3SelectableItemButton
extends Control

var item: PS3Item

var button: PS3Button:
    get:
        return $button

var is_equipped: bool:
    get:
        return self._is_equipped
    set(value):
        self._is_equipped = value
        $button/content/container/equipped.modulate.a = 1.0 if self._is_equipped else 0.0

func display_item(item: PS3Item) -> void:
    self.item = item
    var suffix := "" if item.quantity == 1 else " ⨉ " + str(item.quantity)
    $button/content/container/right/label.text = self.item.name + suffix

static func get_pressed_from_list(list: Variant) -> PS3SelectableItemButton:
    if list is Array:
        var f = list.filter(func(a): return a.button.button_pressed)
        return null if len(f) == 0 else f[0]
    return PS3SelectableItemButton.get_pressed_from_list(list.get_children()) if list is Node else null

static func get_focused_from_list(list: Variant) -> PS3SelectableItemButton:
    if list is Array:
        var f = list.filter(func(a): return a.button.has_focus())
        return null if len(f) == 0 else f[0]
    return PS3SelectableItemButton.get_focused_from_list(list.get_children()) if list is Node else null

var _is_equipped: bool = false
