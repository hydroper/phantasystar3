extends Button

var character: PS3CharacterData

const CHARACTER_HP_OR_TP_BAR_WIDTH: float = 102.0

func display_character(character: PS3CharacterData):
    self.character = character
    self.custom_minimum_size.x = 200
    self.custom_minimum_size.y = 400
    self.size_flags_horizontal = 0
    self.size_flags_vertical = 0
    self.get_node("face").texture = self.character.face_texture
    self.get_node("name_label").text = self.character.name
    self.get_node("current_level").text = str(self.character.level)
    self.get_node("hp_bar/current").size.x = (self.character.hp as float) / (self.character.max_hp as float) * CHARACTER_HP_OR_TP_BAR_WIDTH
    self.get_node("tp_bar/current").size.x = (self.character.tp as float) / (self.character.max_tp as float) * CHARACTER_HP_OR_TP_BAR_WIDTH
