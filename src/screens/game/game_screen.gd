extends Node2D

var game_data: PS3GameData = PS3GameData.new()

@onready
var game_data_dependents = [
    $ui/pause,
    $ui/pause/character,
]

@onready
var pause: GameScPause = $ui/pause

var pause_subsequent_controls: Array[Node] = []

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

func _ready() -> void:
    for o in self.game_data_dependents:
        o.game_data = self.game_data
    # $ui/pause.game_data = self.game_data
    # $ui/pause/character.game_data = self.game_data

    $ui/pause_button.pressed.connect(func():
        self.pause.toggle_pause())

func _input(_event: InputEvent) -> void:
    pass

func _process(_delta: float) -> void:
    pass

var paused: bool:
    get:
        return self.pause.visible
