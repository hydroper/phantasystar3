class_name SubsequentExampleView
extends SubsequentNode2DView
# or extends SubsequentControlView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = []

func _ready():
    self.close_subsequent_recursive()

func open_root() -> void:
    self.close_subsequent_recursive()
    self.visible = true

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func close_subsequent() -> void:
    pass
