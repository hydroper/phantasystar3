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

func _ready():
    $button/content/container/equipped.modulate.a = 0

var _is_equipped: bool = false
