extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = [
    $status,
    $tech,
    $equipment,
]

var opened_character: PS3Character

var last_status_pressed_button: Control = null

func _ready():
    self.close_subsequent_recursive()
    $status/right/back_btn.pressed.connect(func():
        self.get_node("..").close_subsequent())
    $status/right/tech_btn.pressed.connect(func():
        self.last_status_pressed_button = $status/right/tech_btn
        self.close_subsequent_recursive()
        $tech.open_root(self.opened_character))
    $status/right/equipment_btn.pressed.connect(func():
        self.last_status_pressed_button = $status/right/equipment_btn
        self.close_subsequent_recursive()
        $equipment.open_root(self.opened_character))

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func init_character(character_type: PS3Character) -> void:
    self.opened_character = character_type
    var character = self.game_data.characters[character_type]
    if not self.visible:
        self.visible = true
        $portrait.texture = character.portrait_texture

func open_status(character_type: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.init_character(character_type)
    var character = self.game_data.characters[character_type]
    $status.visible = true
    $status/left/name.text = character.name
    $status/left/hp/ratio.text = str(character.hp) + "/" + str(character.max_hp)
    $status/left/tp/ratio.text = str(character.tp) + "/" + str(character.max_tp)
    $status/left/experience/ratio.text = str(character.level_exp) + "/" + str(character.level_exp_goal)
    $status/left/speed/value.text = str(character.speed)
    $status/left/damage/value.text = str(character.damage)
    $status/left/defense/value.text = str(character.defense)
    $status/left/intelligence/value.text = str(character.intelligence)
    $status/left/stamina/value.text = str(character.stamina)
    $status/right/luck/value.text = str(character.luck)
    $status/right/skill/value.text = str(character.skill)
    if self.last_status_pressed_button == null:
        $status/right/tech_btn.grab_focus()
    else:
        self.last_status_pressed_button.grab_focus()

func close_subsequent() -> void:
    if $status.visible:
        self.visible = false
        self.last_status_pressed_button = null
    elif $tech.visible:
        $tech.close_subsequent()
        if not $tech.visible:
            self.open_status(self.opened_character)
    elif $equipment.visible:
        self.open_status(self.opened_character)
