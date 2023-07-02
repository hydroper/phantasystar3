class_name PS3CharacterData

var character: PS3Character
var level_exp: int = 0
var hp: int = 10
var tp: int = 0
var poisoned: bool = false

var left_hand: PS3Item = null
var right_hand: PS3Item = null
var head: PS3Item = null
var torso: PS3Item = null
var feet: PS3Item = null
var buckle: PS3Item = null

func _init(character: PS3Character):
    self.character = character

var string_id: String:
    get:
        return self.character.string_id

var name: String:
    get:
        return self.character.name

var gender: Gender:
    get:
        return self.character.gender

var face_texture: Texture:
    get:
        return self.character.face_texture

var portrait_texture: Texture:
    get:
        return self.character.portrait_texture

var level: int:
    get:
        return 1

var level_exp_goal: int:
    get:
        return 1

var max_hp: int:
    get:
        return 10

var max_tp: int:
    get:
        return 10

var speed: int:
    get:
        return 8

var damage: int:
    get:
        return 8

var defense: int:
    get:
        return 13

var intellect: int:
    get:
        return 6

var stamina: int:
    get:
        return 15

var luck: int:
    get:
        return 10

var skill: int:
    get:
        return 5

var learned_tech: Array[PS3TechType]:
    get:
        return [PS3TechType.HEAL, PS3TechType.RES, PS3TechType.GIRES, PS3TechType.REVER, PS3TechType.ANTI, PS3TechType.ORDER, PS3TechType.FANBI, PS3TechType.FORSA, PS3TechType.NASAK, PS3TechType.SHU]

var entity_animation: Node2D:
    get:
        if self.character == PS3Character.TEMPLATE:
            return preload("res://src/character_animations/mieu/ps3_mieu_entity_animation.tscn").instantiate()
        if self.character == PS3Character.MIEU:
            return preload("res://src/character_animations/mieu/ps3_mieu_entity_animation.tscn").instantiate()
        if self.character == PS3Character.RHYS:
            return preload("res://src/character_animations/rhys/ps3_rhys_entity_animation.tscn").instantiate()
        assert(false, "Unimplemented animation.")
        return null

func can_equip(item: PS3Item) -> bool:
    return self.character.can_equip(item)

# Returns {damage, defense, speed, damage_diff, defense_diff, speed_diff}
func status_if_equipped(item: PS3Item) -> Dictionary:
    return {damage = 0, defense = 0, speed = 0, damage_diff = 0, defense_diff = 0, speed_diff = 0}
