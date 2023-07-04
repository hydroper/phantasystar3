class_name PS3PartyTurnAttackAction

# If set to -1 or out of bounds, attacks any opponent.
var opponent_index: int = -1

func _init(opponent_index: int):
    self.opponent_index = opponent_index
