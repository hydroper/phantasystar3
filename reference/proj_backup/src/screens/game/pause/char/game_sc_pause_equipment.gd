extends SubsequentNode2DView

var game_data: PS3GameData = null

@onready
var subsequent: Array[Node] = []

var opened_character: PS3Character

var slide_type: String = "left_hand"

func _ready():
    self.close_subsequent_recursive()
    $back_btn.pressed.connect(func():
        self.get_node("../..").close_subsequent())
    $slide/list/lhand.pressed.connect(func():
        self.slide_change("left_hand"))
    $slide/list/rhand.pressed.connect(func():
        self.slide_change("right_hand"))
    $slide/list/armor.pressed.connect(func():
        self.slide_change("armor"))
    $unequip_check_btn.toggled.connect(func(_value):
        self._update_items())

func open_root(character: PS3Character) -> void:
    self.close_subsequent_recursive()
    self.visible = true
    self.opened_character = character
    $unequip_check_btn.button_pressed = false
    self._update_status()
    self.slide_change("left_hand")
    $slide/list/lhand.grab_focus()

func close_subsequent_recursive() -> void:
    SubsequentViews.close_recursive(self.subsequent)

func close_subsequent() -> void:
    pass

func slide_change(type: String) -> void:
    self.slide_type = type
    $slide/list/lhand.disabled = type == "left_hand"
    $slide/list/rhand.disabled = type == "right_hand"
    $slide/list/armor.disabled = type == "armor"
    self._update_items()

func _update_items() -> void:
    var type = self.slide_type
    NodeExtFn.remove_all_children($scrollable/list)
    var character: PS3CharacterData = self.game_data.characters[self.opened_character]

    if type == "left_hand" or type == "right_hand":
        if character.left_hand != null and type == "left_hand":
            $scrollable/list.add_child(self._create_item_button(character.left_hand, true))
        if character.right_hand != null and type == "right_hand":
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
        var status = character.status_if_equipped(item_btn.meta_data.item)
        $status/damage/value.text = str(status.damage) + " (" + ("+" if status.damage_diff >= 0 else "") + str(status.damage_diff) + ")"
        $status/defense/value.text = str(status.defense) + " (" + ("+" if status.defense_diff >= 0 else "") + str(status.defense_diff) + ")"
        $status/speed/value.text = str(status.speed) + " (" + ("+" if status.speed_diff >= 0 else "") + str(status.speed_diff) + ")"

func _create_item_button(item: PS3Item, equipped: bool) -> PS3RoundMediumButton:
    var r = preload("res://src/ui/ps3_round_medium_button.tscn").instantiate()
    r.meta_data = { item = item, equipped = equipped }
    r.get_node("control/label").text = item.name
    r.disabled = not equipped if $unequip_check_btn.button_pressed else equipped
    r.focus_entered.connect(func(): self._update_status())
    r.focus_exited.connect(func(): self._update_status())
    r.pressed.connect(func():
        var unequip = $unequip_check_btn.button_pressed
        var pressed_btn = NodeExtFn.get_pressed_button($scrollable/list)
        pass)
    return r
