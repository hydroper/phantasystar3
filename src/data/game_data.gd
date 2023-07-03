class_name PS3GameData

# Signal emitted manually by code that updates
# the party order.
signal on_party_order_update

# The slot on which to save the game data.
var slot: int = 0

var meseta: int = 0

var characters: Dictionary = {
    PS3Character.TEMPLATE: PS3CharacterData.new(PS3Character.TEMPLATE),
    PS3Character.RHYS: PS3CharacterData.new(PS3Character.RHYS),
    PS3Character.MIEU: PS3CharacterData.new(PS3Character.MIEU),
}

var party: Array[PS3Character] = [
    PS3Character.TEMPLATE,
    PS3Character.MIEU,
    PS3Character.RHYS,
]

var items: Array[PS3Item] = [
    PS3Item.new(PS3ItemType.MONOMATE, 127),
    PS3Item.new(PS3ItemType.DIMATE, 127),
    PS3Item.new(PS3ItemType.KNIFE),
    PS3Item.new(PS3ItemType.KNIFE),
    PS3Item.new(PS3ItemType.KNIFE),
    PS3Item.new(PS3ItemType.KNIFE),
    PS3Item.new(PS3ItemType.KNIFE),
]

func character(character: Variant) -> PS3CharacterData:
    if character is PS3CharacterData:
        return character
    assert(character is PS3Character)
    return self.characters[character]

func _init():
    self.characters[PS3Character.RHYS].torso = PS3Item.new(PS3ItemType.GARMENT)
    self.characters[PS3Character.RHYS].feet = PS3Item.new(PS3ItemType.BOOTS)

# Returns {type} and additional properties,
# where "type" is either:
# - "ask_for_party_target" (then invoke use_targetted_tech())
# - "ask_for_opponent_target" (then invoke use_targetted_tech())
# - "not_enough_tp"
# - "unimplemented"
func use_tech(from_character: PS3CharacterData, tech: PS3TechType) -> Dictionary:
    if tech.is_targetted_healing_tech:
        return {type = "ask_for_party_target"} if from_character.tp >= tech.cost else {type = "not_enough_tp"}
    return {type = "unimplemented"}

# Returns {type} and additional properties,
# where "type" is either:
# - "restored_hp"
# - "hp_already_full"
# - "not_enough_tp"
# - "unimplemented"
func use_targetted_tech(from_character: PS3CharacterData, tech: PS3TechType, target: Variant) -> Dictionary:
    if tech.is_targetted_healing_tech:
        if from_character.tp >= tech.cost:
            if target.hp == target.max_hp:
                return {type = "hp_already_full", party_char = target}
            else:
                from_character.tp -= tech.cost
                var k = target.hp
                target.hp = mini(target.hp + tech.healing_tech_restored_hp, target.max_hp)
                return {type = "restored_hp", party_char = target, restored_hp = target.hp - k}
        else:
            return {type = "not_enough_tp"}
    return {type = "unimplemented"}

# Returns {type} and additional properties,
# where "type" is either:
# - "ask_for_party_target" (then invoke use_targetted_item())
# - "unimplemented"
func use_item(item: PS3Item) -> Dictionary:
    if item.targetted_recovery != null:
        return {type = "ask_for_party_target", item = item}
    return {type = "unimplemented"}

func use_targetted_item(item: PS3Item, target: Variant) -> Dictionary:
    var recovery = item.targetted_recovery
    if recovery != null:
        if recovery.type == "hp":
            target = self.character(target)
            if target.hp == target.max_hp:
                return {type = "hp_already_full", party_char = target}
            else:
                item.quantity -= 1
                if item.quantity == 0:
                    self.items.remove_at(self.items.find(item))
                var k = target.hp
                target.hp = mini(target.hp + recovery.hp, target.max_hp)
                return {type = "restored_hp", party_char = target, restored_hp = target.hp - k}
    return {type = "unimplemented"}

var inventory_is_full: bool:
    get:
        return false

func save() -> void:
    pass
