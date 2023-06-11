extends Node2D

var game_data: PS3GameData = PS3GameData.new()

@onready
var pause: GameScreenPause = $ui/pause

var pause_subsequent_controls: Array[Node] = []

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

func _ready() -> void:
    pause.game_data = self.game_data
    pause.visible = false
    $ui/pause_button.pressed.connect(func():
        self.toggle_pause())

func _input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        self.toggle_pause()
    elif self.paused and pause.at_top:
        if event.is_action_released("ui_cancel"):
            self.toggle_pause()

func _process(_delta: float) -> void:
    pass

var paused: bool:
    get:
        return pause.visible

func toggle_pause() -> void:
    pause.visible = not self.paused
    if self.paused:
        pause.open_top()
