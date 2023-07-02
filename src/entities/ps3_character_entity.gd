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
    # max speed
    state.linear_velocity.x = clampf(state.linear_velocity.x, -self._max_speed, self._max_speed)
    state.linear_velocity.y = clampf(state.linear_velocity.y, -self._max_speed, self._max_speed)
