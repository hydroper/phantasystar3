class_name GameScreenPause
extends Control

var game_data: PS3GameData = null

var subsequent_panels: Array[Node] = []

const CHARACTER_HP_OR_TP_BAR_WIDTH: float = 102.0

# Called when the node enters the scene tree for the first time.
func _ready():
    self.visible = false
    self.subsequent_panels = [
        $top_content,
        $character_selection,
        $character,
    ]
    $top_content/buttons1/character_btn.pressed.connect(func():
        self.open_character_selection())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        self.toggle_pause()
    elif self.visible:
        if event.is_action_released("ui_cancel"):
            self.close_subsequent()

func close_all_subsequent_panels() -> void:
    for p in self.subsequent_panels:
        p.visible = false

func open_top() -> void:
    self.close_all_subsequent_panels()
    $top_content.visible = true
    $top_content/status/meseta/value.text = str(self.game_data.meseta)
    $top_content/buttons1/items_btn.grab_focus()

func open_character_selection() -> void:
    self.close_all_subsequent_panels()
    $character_selection.visible = true
    NodeExtFn.remove_all_children($character_selection/list)
    for character_type in self.game_data.party:
        var character = self.game_data.characters[character_type]
        var character_box = preload("res://src/screens/game/pause/GameScPauseTopPartyChar.tscn").instantiate()
        character_box.character = character_type
        character_box.custom_minimum_size.x = 200
        character_box.custom_minimum_size.y = 400
        character_box.size_flags_horizontal = 0
        character_box.size_flags_vertical = 0
        character_box.get_node("face").texture = character.face_texture
        character_box.get_node("name_label").text = character.name
        character_box.get_node("current_level").text = str(character.level)
        character_box.get_node("hp_bar/current").size.x = (character.hp as float) / (character.max_hp as float) * CHARACTER_HP_OR_TP_BAR_WIDTH
        character_box.get_node("tp_bar/current").size.x = (character.tp as float) / (character.max_tp as float) * CHARACTER_HP_OR_TP_BAR_WIDTH
        character_box.pressed.connect(func():
            for button in $character_selection/list.get_children():
                if button.button_pressed:
                    self.open_character(button.character)
                    return)
        $character_selection/list.add_child(character_box)
    $character_selection/list.get_child(0).focus_neighbor_left = $character_selection/list.get_child(-1).get_path()
    $character_selection/list.get_child(-1).focus_neighbor_right = $character_selection/list.get_child(0).get_path()
    $character_selection/list.get_child(0).grab_focus()

func open_character(character_type: PS3Character) -> void:
    self.close_all_subsequent_panels()
    $character.visible = true
    var character = self.game_data.characters[character_type]
    $character/status/left/name.text = character.name
    $character/status/left/hp/ratio.text = str(character.hp) + "/" + str(character.max_hp)
    $character/status/left/tp/ratio.text = str(character.tp) + "/" + str(character.max_tp)
    $character/status/right/tech_btn.grab_focus()

func close_subsequent() -> void:
    if $character_selection.visible:
        self.open_top()
    elif $character.visible:
        self.open_character_selection()
    else:
        self.toggle_pause()

func toggle_pause() -> void:
    self.visible = not self.visible
    if self.visible:
        self.open_top()
