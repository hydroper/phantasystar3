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
    NodeExtFn.remove_all_children($scroll_list/list)
    var character = self.game_data.characters[character_type]
    for tech in character.learned_tech:
        # tech.
        pass

func create_tech_button(tech: PS3TechType) -> PS3RoundMediumButton:
    var r = preload("res://src/ui/ps3_round_medium_button.tscn").instantiate()
    r.meta_data = tech
    return r

func close_subsequent() -> void:
    self.close_subsequent_recursive()
    self.visible = false
