extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = []

var opened_character: PS3Character

func _ready():
    self.close_subsequent_recursive()
    $back_btn.pressed.connect(func():
        self.get_node("../..").close_subsequent())
    $slide/list/weapon.pressed.connect(func():
        $slide/list/armor.disabled = false
        $slide/list/weapon.disabled = true
        self._update_items("weapon"))
    $slide/list/armor.pressed.connect(func():
        $slide/list/armor.disabled = true
        $slide/list/weapon.disabled = false
        self._update_items("armor"))

func open_root(character: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.visible = true
    self.opened_character = character
    $unequip_check_btn.button_pressed = false
    $slide/list/weapon.disabled = true
    $slide/list/weapon.grab_focus()
    $slide/list/armor.disabled = false
    self._update_status()
    self._update_items("weapon")

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func close_subsequent() -> void:
    pass

func _update_items(type: String) -> void:
    NodeExtFn.remove_all_children($scrollable/list)
    var character: PS3CharacterData = self.game_data.characters[self.opened_character]

    if type == "weapon":
        if character.left_hand != null:
            $scrollable/list.add_child(self._create_item_button(character.left_hand, true))
        if character.right_hand != null:
            $scrollable/list.add_child(self._create_item_button(character.right_hand, true))
        for item in self.game_data.items:
            if item.type.category == PS3ItemCategory.WEAPON and character.can_equip(item):
                $scrollable/list.add_child(self._create_item_button(item, false))
    else:
        if character.head != null:
            $scrollable/list.add_child(self._create_item_button(character.head, true))
        if character.torso != null:
            $scrollable/list.add_child(self._create_item_button(character.torso, true))
        if character.feet != null:
            $scrollable/list.add_child(self._create_item_button(character.feet, true))
        if character.buckle != null:
            $scrollable/list.add_child(self._create_item_button(character.buckle, true))
        for item in self.game_data.items:
            if item.type.category.is_armor and character.can_equip(item):
                $scrollable/list.add_child(self._create_item_button(item, false))

func _update_status() -> void:
    var character: PS3CharacterData = self.game_data.characters[self.opened_character]
    var item_btn = NodeExtFn.get_focused($scrollable/list)

    if item_btn == null:
        $status/damage/value.text = str(character.damage)
        $status/defense/value.text = str(character.defense)
        $status/speed/value.text = str(character.speed)
    else:
        $status/damage/value.text = str(character.damage)
        $status/defense/value.text = str(character.defense)
        $status/speed/value.text = str(character.speed)
        print("_update_status comparison not done")

func _create_item_button(item: PS3Item, equipped: bool) -> PS3RoundMediumButton:
    var r = preload("res://src/ui/ps3_round_medium_button.tscn").instantiate()
    r.meta_data = { item = item, equipped = equipped }
    r.get_node("control/label").text = item.name
    r.disabled = equipped
    r.focus_entered.connect(func(): self._update_status())
    r.focus_exited.connect(func(): self._update_status())
    r.pressed.connect(func():
        var pressed_btn = NodeExtFn.get_pressed_button($scrollable/list)
        pass)
    return r
