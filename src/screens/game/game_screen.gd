extends Node2D

var game_data: PS3GameData = PS3GameData.new()

@onready
var game_data_dependents = [
    $ui/menu,
]

@onready
var ui_menu: GameScMenu = $ui/menu

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

func _ready() -> void:
    for o in self.game_data_dependents:
        o.game_data = self.game_data

func _process(_delta: float) -> void:
    pass
