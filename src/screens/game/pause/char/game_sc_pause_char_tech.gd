extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = []

var opened_character: PS3Character

func _ready():
    self.close_subsequent_recursive()

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func open_root(character_type: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.opened_character = character_type
    self.visible = true
    var character = self.game_data.characters[character_type]

func close_subsequent() -> void:
    self.close_subsequent_recursive()
    self.visible = false
