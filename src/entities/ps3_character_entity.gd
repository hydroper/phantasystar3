class_name PS3CharacterEntity
extends RigidBody2D

var which_character: PS3Character = null

var turn_dir: TurnDirection = TurnDirection.DOWN

var moving: bool:
    get:
        return self._moving
    set(value):
        if value == self._moving:
            return
        self._moving = value
        self._reflected_move_animation = false

var moving_horizontally := false
var moving_vertically := false

var animation: AnimationPlayer:
    get:
        return $look/anim/animator

var _max_speed: float = 550
var _moving := false
var _reflected_turn_dir: TurnDirection = null
var _reflected_move_animation: bool = false

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    self._reflect_turn_dir()
    if self._moving:
        self.apply_central_force(self.turn_dir.speed * 600)

func _reflect_turn_dir() -> void:
    if self.turn_dir == self._reflected_turn_dir and self._reflected_move_animation:
        return
    self._reflected_turn_dir = self.turn_dir
    self._reflected_move_animation = true
    var animation_name := ""
    if self.moving:
        if self.turn_dir == TurnDirection.UP:
            animation_name = "walking_up"
        elif self.turn_dir == TurnDirection.DOWN:
            animation_name = "walking_down"
        elif self.turn_dir == TurnDirection.LEFT or self.turn_dir == TurnDirection.UP_LEFT or self.turn_dir == TurnDirection.DOWN_LEFT:
            animation_name = "walking_left"
        else: animation_name = "walking_right"
    elif self.turn_dir == TurnDirection.UP:
        animation_name = "standing_up"
    elif self.turn_dir == TurnDirection.DOWN:
        animation_name = "standing_down"
    elif self.turn_dir == TurnDirection.LEFT or self.turn_dir == TurnDirection.UP_LEFT or self.turn_dir == TurnDirection.DOWN_LEFT:
        animation_name = "standing_left"
    else: animation_name = "standing_right"
    self.animation.play(animation_name)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if not self.moving_horizontally:
        state.linear_velocity.x = 0
    if not self.moving_vertically:
        state.linear_velocity.y = 0
    var dir = self.turn_dir

    # no smoothing
    if (dir == TurnDirection.UP or dir == TurnDirection.UP_LEFT or dir == TurnDirection.UP_RIGHT) and state.linear_velocity.y > 0:
        state.linear_velocity.y = 0
    if (dir == TurnDirection.DOWN or dir == TurnDirection.DOWN_LEFT or dir == TurnDirection.DOWN_RIGHT) and state.linear_velocity.y < 0:
        state.linear_velocity.y = 0
    if (dir == TurnDirection.LEFT or dir == TurnDirection.UP_LEFT or dir == TurnDirection.DOWN_LEFT) and state.linear_velocity.x > 0:
        state.linear_velocity.x = 0
    if (dir == TurnDirection.RIGHT or dir == TurnDirection.UP_RIGHT or dir == TurnDirection.DOWN_RIGHT) and state.linear_velocity.x < 0:
        state.linear_velocity.x = 0

    # max speed
    state.linear_velocity.x = clampf(state.linear_velocity.x, -self._max_speed, self._max_speed)
    state.linear_velocity.y = clampf(state.linear_velocity.y, -self._max_speed, self._max_speed)

const following_distance = Vector2(90.0, 90.0)

func follow_party(party_entities: Dictionary, leader_entity: PS3CharacterEntity) -> void:
    var needs_to_follow := true
    var rect_a := Rect2(self.global_position, following_distance)
    for character in party_entities:
        var entity = party_entities[character]
        if entity == self:
            continue
        var rect_b := Rect2(entity.global_position, following_distance)
        if rect_a.intersects(rect_b):
            needs_to_follow = false
            break
    var pressing_up := false
    var pressing_down := false
    var pressing_left := false
    var pressing_right := false
    if needs_to_follow:
        var rect_b := Rect2(leader_entity.global_position, following_distance)
        if rect_a.position.x < rect_b.position.x:
            pressing_right = true
        elif rect_a.position.x > rect_b.position.x:
            pressing_left = true
        if rect_a.position.y < rect_b.position.y:
            pressing_down = true
        elif rect_a.position.y > rect_b.position.y:
            pressing_up = true
    self.turn_dir = TurnDirection.UP_LEFT if (pressing_up and pressing_left) else TurnDirection.UP_RIGHT if (pressing_up and pressing_right) else TurnDirection.UP if pressing_up else TurnDirection.DOWN_LEFT if (pressing_down and pressing_left) else TurnDirection.DOWN_RIGHT if (pressing_down and pressing_right) else TurnDirection.DOWN if pressing_down else TurnDirection.LEFT if pressing_left else TurnDirection.RIGHT if pressing_right else self.turn_dir
    self.moving = pressing_up or pressing_down or pressing_left or pressing_right
    self.moving_horizontally = pressing_left or pressing_right
    self.moving_vertically = pressing_up or pressing_down
