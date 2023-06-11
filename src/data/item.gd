class_name PS3Item

var type: PS3ItemType
var quantity: int

func _init(type: PS3ItemType, quantity: int = 1):
    self.type = type
    self.quantity = quantity
