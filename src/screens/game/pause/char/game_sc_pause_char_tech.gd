extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = []

var opened_character: PS3Character

func _ready():
    self.close_subsequent_recursive()
    $back_btn.pressed.connect(func():
        self.get_node("../..").close_subsequent())

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func open_root(character_type: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.opened_character = character_type
    self.visible = true
    NodeExtFn.remove_all_children($scroll_list/list)
    var character = self.game_data.characters[character_type]
    for tech in character.learned_tech:
        $scroll_list/list.add_child(self.create_tech_button(tech))
    if $scroll_list/list.get_child_count() > 0:
        $scroll_list/list.get_child(0).grab_focus()
    else:
        $back_btn.grab_focus()

func create_tech_button(tech: PS3TechType) -> PS3RoundMediumButton:
    var r = preload("res://src/ui/ps3_round_medium_button.tscn").instantiate()
    r.meta_data = tech
    r.get_node("control/label").text = tech.name
    r.pressed.connect(func():
        for button in $scroll_list/list.get_children():
            if button.button_pressed:
                # print(button.meta_data.name)
                return)
    return r

func close_subsequent() -> void:
    pass
