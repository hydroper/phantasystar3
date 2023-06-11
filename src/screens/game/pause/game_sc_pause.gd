class_name GameScPause
extends SubsequentControlView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = [
    $root_content,
    $character_selection,
    $character,
]

var last_selected_character: PS3Character

# Called when the node enters the scene tree for the first time.
func _ready():
    self.visible = false
    $root_content/buttons1/character_btn.pressed.connect(func():
        self.open_character_selection())
    $character/status/right/back_btn.pressed.connect(func():
        self.close_subsequent())
    $character_selection/back_btn.pressed.connect(func():
        self.close_subsequent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        self.toggle_pause()
    elif self.visible:
        if event.is_action_released("ui_cancel"):
            self.close_subsequent()

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func open_root() -> void:
    self.close_subsequent_recursive()
    $root_content.visible = true
    $root_content/status/meseta/value.text = str(self.game_data.meseta)
    $root_content/buttons1/items_btn.grab_focus()

func open_character_selection() -> void:
    self.close_subsequent_recursive()
    $character_selection.visible = true
    NodeExtFn.remove_all_children($character_selection/scroll_list/list)
    for character_type in self.game_data.party:
        var character = self.game_data.characters[character_type]
        var char_card = preload("res://src/screens/game/pause/char_select_card/game_sc_pause_char_select_card.tscn").instantiate()
        char_card.display_character(character)
        char_card.pressed.connect(func():
            for button in $character_selection/scroll_list/list.get_children():
                if button.button_pressed:
                    self.close_subsequent_recursive()
                    self.last_selected_character = character_type
                    $character.open_status(button.character.character)
                    return)
        $character_selection/scroll_list/list.add_child(char_card)
    $character_selection/scroll_list/list.get_child(0).focus_neighbor_left = $character_selection/scroll_list/list.get_child(-1).get_path()
    $character_selection/scroll_list/list.get_child(-1).focus_neighbor_right = $character_selection/scroll_list/list.get_child(0).get_path()
    $character_selection/scroll_list/list.get_child(0).grab_focus()
    if self.last_selected_character != null:
        for button in $character_selection/scroll_list/list.get_children():
            if button.character.character == self.last_selected_character:
                button.grab_focus()
                break
        self.last_selected_character = null

func close_subsequent() -> void:
    if $character_selection.visible:
        self.open_root()
    elif $character.visible:
        $character.close_subsequent()
        if not $character.visible:
            self.open_character_selection()
    else:
        self.visible = false

func toggle_pause() -> void:
    self.visible = not self.visible
    if self.visible:
        self.open_root()
    else:
        self.close_subsequent_recursive()
