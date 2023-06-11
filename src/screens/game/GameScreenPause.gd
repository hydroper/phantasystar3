class_name GameScreenPause
extends Control

var game_data: PS3GameData = null

var subsequent_panels: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
    self.subsequent_panels = [
        $top_content,
        $character_selection,
    ]
    $top_content/buttons1/character_btn.pressed.connect(func():
        self.open_character_selection())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if self.visible and not self.at_top:
        if event.is_action_released("ui_cancel"):
            self.close_subsequent()

var at_top: bool:
    get:
        return self.visible and $top_content.visible

func close_all_subsequent_panels() -> void:
    for p in self.subsequent_panels:
        p.visible = false

func open_top() -> void:
    self.close_all_subsequent_panels()
    $top_content.visible = true
    $top_content/buttons1/items_btn.grab_focus()

func open_character_selection() -> void:
    self.close_all_subsequent_panels()
    $character_selection.visible = true
    NodeExtFn.remove_all_children($character_selection/list)
    for character_type in self.game_data.party:
        var character = self.game_data.characters[character_type]
        var character_box = preload("res://src/screens/game/pause/GameScPauseTopPartyChar.tscn").instantiate()
        character_box.custom_minimum_size.x = 185
        character_box.size_flags_horizontal = 0
        character_box.size_flags_vertical = 0
        character_box.get_node("face").texture = character.face_texture
        character_box.get_node("name_label").text = character.name
        $character_selection/list.add_child(character_box)

func close_subsequent() -> void:
    if $character_selection.visible:
        self.open_top()
