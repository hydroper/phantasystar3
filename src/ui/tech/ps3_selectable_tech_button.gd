class_name PS3SelectableTechButton
extends Control

var tech: PS3TechType

var button: PS3Button:
    get:
        return $button

func display_tech(tech: PS3TechType) -> void:
    self.tech = tech
    $button/content/container/right/label.text = self.tech.name

static func get_pressed_from_list(list: Variant) -> PS3SelectableTechButton:
    if list is Array:
        var f = list.filter(func(a): return a.button.button_pressed)
        return null if len(f) == 0 else f[0]
    return PS3SelectableTechButton.get_pressed_from_list(list.get_children()) if list is Node else null

static func get_focused_from_list(list: Variant) -> PS3SelectableTechButton:
    if list is Array:
        var f = list.filter(func(a): return a.button.has_focus())
        return null if len(f) == 0 else f[0]
    return PS3SelectableTechButton.get_focused_from_list(list.get_children()) if list is Node else null
