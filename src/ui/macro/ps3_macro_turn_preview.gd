class_name PS3MacroTurnPreview
extends PanelContainer

var turn: PS3PartyTurn = null

func display_turn(turn: PS3PartyTurn) -> void:
    self.turn = turn
    $list/character_label.text = turn.character.name
    $list/action_label.text = "Attack" if turn.action is PS3PartyTurnAttackAction else "Defend" if turn.action is PS3PartyTurnDefendAction else turn.action.item_type.name if turn.action is PS3PartyTurnUseItemAction else turn.action.tech.name if turn.action is PS3PartyTurnUseTechAction else ""
