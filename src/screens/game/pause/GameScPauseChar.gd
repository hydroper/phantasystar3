extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = [
    $status,
    $tech,
]

var opened_character: PS3Character

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass

func close_all_subsequent() -> void:
    for p in self.subsequent:
        if p is SubsequentNode2DView or p is SubsequentControlView:
            p.close_all_subsequent()
        p.visible = false

func open_status(character_type: PS3Character) -> void:
    self.close_all_subsequent()
    self.opened_character = character_type
    var character = self.game_data.characters[character_type]
    if not self.visible:
        self.visible = true
        $portrait.texture = character.portrait_texture
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

    $status/right/tech_btn.grab_focus()

func close_subsequent() -> void:
    if $status.visible:
        self.visible = false
    elif $tech.visible:
        self.open_status(self.opened_character)
