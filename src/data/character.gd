class_name PS3Character

static var RHYS: PS3Character = PS3Character.new(0, "rhys", "Rhys", Gender.MALE, preload("res://res/img/characters/rhys/face.png"), preload("res://res/img/characters/rhys/portrait.png"))
static var MIEU: PS3Character = PS3Character.new(1, "mieu", "Mieu", Gender.FEMALE, preload("res://res/img/characters/mieu/face.png"), preload("res://res/img/characters/mieu/portrait.png"))

static func from(value: int) -> PS3Character:
    return PS3Character._from.get(value)

func value_of() -> int:
    return self._value

var string_id: String:
    get:
        return self._string_id

var gender: Gender:
    get:
        return self._gender

var name: String:
    get:
        return self._name

var face_texture: Texture:
    get:
        return self._face_texture

var portrait_texture: Texture:
    get:
        return self._portrait_texture

static var _from: Dictionary
var _value: int
var _string_id: String
var _name: String
var _gender: Gender
var _face_texture: Texture
var _portrait_texture: Texture

func _init(value: int, string_id: String, name: String, gender: Gender, face_texture: Texture, portrait_texture: Texture):
    _from = _from if _from != null else {}
    _from[value] = self
    self._value = value
    self._string_id = string_id
    self._name = name
    self._gender = gender
    self._face_texture = face_texture
    self._portrait_texture = portrait_texture
