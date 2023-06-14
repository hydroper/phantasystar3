extends Control

var item: PS3Item

func display_item(item: PS3Item) -> void:
    self.item = item
    $button/content/container/right/label.text = self.item.name
