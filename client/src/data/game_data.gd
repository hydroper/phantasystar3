class_name PS3GameData

var meseta: int = 0

var characters: Dictionary = {
    PS3Character.RHYS: PS3CharacterData.new(PS3Character.RHYS),
    PS3Character.MIEU: PS3CharacterData.new(PS3Character.MIEU),
}

var party: Array[PS3Character] = [
    PS3Character.RHYS,
    PS3Character.MIEU,
]

var items: Array[PS3Item] = [
    PS3Item.new(PS3ItemType.MONOMATE, 127),
    PS3Item.new(PS3ItemType.DIMATE, 127),
    PS3Item.new(PS3ItemType.KNIFE),
]

func _init():
    self.characters[PS3Character.RHYS].torso = PS3Item.new(PS3ItemType.GARMENT)

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

var inventory_is_full: bool:
    get:
        return false
