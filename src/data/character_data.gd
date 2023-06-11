class_name PS3CharacterData

var character: PS3Character
var level_exp: int = 0
var hp: int = 0
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
