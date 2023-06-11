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
]
