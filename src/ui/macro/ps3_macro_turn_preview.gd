class_name PS3MacroTurnPreview
extends PanelContainer

var turn: PS3PartyTurn = null

func display_turn(turn: PS3PartyTurn) -> void:
    self.turn = turn
