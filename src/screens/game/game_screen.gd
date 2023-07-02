extends Node2D

var game_data: PS3GameData = PS3GameData.new()

@onready
var game_data_dependents = [
    $ui/menu,
]

@onready
var ui_menu: GameScMenu = $ui/menu

@onready
var ui_left_analog: PS3TouchAnalog = $ui/touch_controls/left_analog

@onready
var world: Node2D = $world
@onready
var world_entities: Node2D = $world/entities

var party_entities: Dictionary = {}

func _ready() -> void:
    for o in self.game_data_dependents:
        o.game_data = self.game_data
    var party_reversed = self.game_data.party.slice(0)
    party_reversed.reverse()
    for character in party_reversed:
        var entity = self._create_character_entity(character)
        entity.position.x = 400
        entity.position.y = 400
        self.party_entities[character] = entity
        self.world_entities.add_child(entity)
    self.ui_menu.on_open.connect(func():
        self.ui_left_analog.disabled = true)
    self.ui_menu.on_close.connect(func():
        self.ui_left_analog.disabled = false)

func _process(_delta: float) -> void:
    var player_entity = self.party_entities[self.game_data.party[0]]
    var pressing_up := false
    var pressing_down := false
    var pressing_left := false
    var pressing_right := false

    if not self.ui_menu.is_open:
        if self.ui_left_analog.direction == null:
            pressing_up = Input.is_action_pressed("move_up")
            pressing_down = Input.is_action_pressed("move_down")
            pressing_left = Input.is_action_pressed("move_left")
            pressing_right = Input.is_action_pressed("move_right")
            player_entity.turn_dir = TurnDirection.UP_LEFT if (pressing_up and pressing_left) else TurnDirection.UP_RIGHT if (pressing_up and pressing_right) else TurnDirection.UP if pressing_up else TurnDirection.DOWN_LEFT if (pressing_down and pressing_left) else TurnDirection.DOWN_RIGHT if (pressing_down and pressing_right) else TurnDirection.DOWN if pressing_down else TurnDirection.LEFT if pressing_left else TurnDirection.RIGHT if pressing_right else player_entity.turn_dir
        else:
            player_entity.turn_dir = ui_left_analog.direction
            pressing_up = player_entity.turn_dir == TurnDirection.UP or player_entity.turn_dir == TurnDirection.UP_LEFT or player_entity.turn_dir == TurnDirection.UP_RIGHT
            pressing_down = player_entity.turn_dir == TurnDirection.DOWN or player_entity.turn_dir == TurnDirection.DOWN_LEFT or player_entity.turn_dir == TurnDirection.DOWN_RIGHT
            pressing_left = player_entity.turn_dir == TurnDirection.LEFT or player_entity.turn_dir == TurnDirection.UP_LEFT or player_entity.turn_dir == TurnDirection.DOWN_LEFT
            pressing_right = player_entity.turn_dir == TurnDirection.RIGHT or player_entity.turn_dir == TurnDirection.UP_RIGHT or player_entity.turn_dir == TurnDirection.DOWN_RIGHT
    else:
        player_entity.turn_dir = null

    player_entity.moving = pressing_up or pressing_down or pressing_left or pressing_right
    player_entity.moving_horizontally = pressing_left or pressing_right
    player_entity.moving_vertically = pressing_up or pressing_down

    # make party follow the player
    for character in self.party_entities:
        var entity = self.party_entities[character]
        if entity != player_entity:
            entity.follow_party(self.party_entities, player_entity)

func _create_character_entity(character: PS3Character) -> PS3CharacterEntity:
    var entity = preload("res://src/entities/ps3_character_entity.tscn").instantiate()
    entity.which_character = character
    var anim = self.game_data.character(character).entity_animation
    anim.name = "anim"
    entity.get_node("look").add_child(anim)
    entity.animation.play("standing_down")
    return entity
