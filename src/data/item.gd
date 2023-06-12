class_name PS3Item

var type: PS3ItemType
var quantity: int

var name: String:
    get:
        return self.type.name

func _init(type: PS3ItemType, quantity: int = 1):
    self.type = type
    self.quantity = quantity
