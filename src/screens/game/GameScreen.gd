extends Node2D

var game_data: GameData = GameData.new()

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if Input.is_action_pressed("move_left"):
        if $ui/PS3DefaultPanel.is_open:
            $ui/PS3DefaultPanel.collapse()
        else:
            $ui/PS3DefaultPanel.popup()
