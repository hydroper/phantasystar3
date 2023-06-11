class_name PS3CharacterData

var character: PS3Character
var level_exp: int = 0
var hp: int = 10
var tp: int = 0
var poisoned: bool = false

var left_arm: PS3ItemType = null
var right_arm: PS3ItemType = null
var helmet: PS3ItemType = null
var chest: PS3ItemType = null
var legs: PS3ItemType = null

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

var level: int:
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

var intelligence: int:
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
