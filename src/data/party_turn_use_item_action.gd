class_name PS3PartyTurnUseItemAction

# Identifies item by type, not by its object identity
# in the inventory.
var item_type: PS3ItemType

# Certain items have a target. It is usually a
# party character. If that character is not present,
# this item use must be ignored.
var target: Variant

func _init(item_type: PS3ItemType, target: Variant):
    self.item_type = item_type
    self.target = target
