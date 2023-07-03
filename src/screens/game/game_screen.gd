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
var world = $world
@onready
var world_entities = $world/entities

var party_entities: Dictionary = {}

var camera: Camera2D = null

func _ready() -> void:
    for o in self.game_data_dependents:
        o.game_data = self.game_data
    for character in ArrayUtil.to_reversed(self.game_data.party):
        var entity = self._create_character_entity(character)
        entity.position.x = 400
        entity.position.y = 400
        self.party_entities[character] = entity
        self.world_entities.add_child(entity)
    self.attach_player_camera()
    self.ui_menu.on_open.connect(func():
        self.ui_left_analog.disabled = true)
    self.ui_menu.on_close.connect(func():
        self.ui_left_analog.disabled = false)
    self.game_data.on_party_order_update.connect(func():
        self.attach_player_camera())

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        self.game_data.save()

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

    player_entity.moving = pressing_up or pressing_down or pressing_left or pressing_right
    player_entity.moving_horizontally = pressing_left or pressing_right
    player_entity.moving_vertically = pressing_up or pressing_down

    # make party follow the player
    for i in range(1, len(self.game_data.party)):
        var entity = self.party_entities[self.game_data.party[i]]
        var leader = self.party_entities[self.game_data.party[i - 1]]
        entity.follow_party(leader)

func _create_character_entity(character: PS3Character) -> PS3CharacterEntity:
    var entity = preload("res://src/entities/ps3_character_entity.tscn").instantiate()
    entity.which_character = character
    var anim = self.game_data.character(character).entity_animation
    anim.name = "anim"
    entity.get_node("look").add_child(anim)
    entity.animation.play("standing_down")
    return entity

func reconstruct_camera() -> void:
    self.camera = Camera2D.new()
    self.camera.limit_left = -100
    self.camera.limit_right = 1500
    self.camera.limit_top = -200
    self.camera.limit_bottom = 700

func attach_player_camera() -> void:
    if self.camera != null:
        for character in self.party_entities:
            var entity = self.party_entities[character]
            if self.camera.get_parent() == entity:
                entity.remove_child(self.camera)
    self.reconstruct_camera()
    self.party_entities[self.game_data.party[0]].add_child(self.camera)
