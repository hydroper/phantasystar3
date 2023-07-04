class_name PS3PartyTurnUseTechAction

# Identifies item by type, not by its object identity
# in the inventory.
var tech: PS3TechType

# Certain techs have a target:
# - If it's a party character that is not present,
#   this tech use must be ignored.
# - If it's an integer, it is an index. For most techs,
#   this index is the target opponent. If out of bounds,
#   the tech applies to any opponent.
var target: Variant

func _init(tech: PS3TechType, target: Variant):
    self.tech = tech
    self.target = target
