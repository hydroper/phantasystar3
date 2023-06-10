extends Node2D

var game_data: GameData = GameData.new()

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

@onready
var dp: PS3DefaultPanel = $ui/PS3DefaultPanel

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    if Input.is_action_pressed("move_left") && not dp.is_opening_or_collapsing:
        if dp.is_collapsed:
            dp.popup()
        else:
            dp.collapse()
