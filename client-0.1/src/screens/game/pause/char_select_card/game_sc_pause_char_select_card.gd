extends Button

var character: PS3CharacterData

const CHARACTER_HP_OR_TP_BAR_WIDTH: float = 102.0

func display_character(character: PS3CharacterData):
    self.character = character
    self.size_flags_horizontal = 0
    self.size_flags_vertical = 0
    self.get_node("face").texture = self.character.face_texture
    self.get_node("name_label").text = self.character.name
    self.get_node("current_level").text = str(self.character.level)
    self.get_node("hp_bar/current").size.x = float(self.character.hp) / float(self.character.max_hp) * CHARACTER_HP_OR_TP_BAR_WIDTH
    self.get_node("tp_bar/current").size.x = float(self.character.tp) / float(self.character.max_tp) * CHARACTER_HP_OR_TP_BAR_WIDTH

func _process(_delta: float) -> void:
    $background.visible = not self.is_hovered() and not self.has_focus()
    $background_hover.visible = self.is_hovered() and not self.has_focus()
    $background_focus.visible = self.has_focus()   
