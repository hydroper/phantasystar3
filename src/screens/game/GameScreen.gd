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
    self.pause.game_data = self.game_data
    $ui/pause_button.pressed.connect(func():
        self.pause.toggle_pause())

func _input(event: InputEvent) -> void:
    pass

func _process(_delta: float) -> void:
    pass

var paused: bool:
    get:
        return self.pause.visible
