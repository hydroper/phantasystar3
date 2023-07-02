class_name PS3CharacterEntity
extends RigidBody2D

var which_character: PS3Character = null
var turn_dir: TurnDirection = TurnDirection.DOWN
var moving := false

var animation: AnimationPlayer:
    get:
        return $look/anim/animator

var _max_speed: float = 600

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if not self.moving:
        state.linear_velocity.x = 0
        state.linear_velocity.y = 0
    else:
        # max speed
        state.linear_velocity.x = clampf(state.linear_velocity.x, -self._max_speed, self._max_speed)
        state.linear_velocity.y = clampf(state.linear_velocity.y, -self._max_speed, self._max_speed)
