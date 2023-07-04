class_name PS3PartyTurn

var character: PS3Character

# Either:
# - a PS3PartyTurnAttackAction,
# - a PS3PartyTurnDefendAction,
# - a PS3PartyTurnUseItemAction or
# - a PS3PartyTurnUseTechAction.
var action: Variant

func _init(character: PS3Character, action: Variant):
    self.character = character
    self.action = action
