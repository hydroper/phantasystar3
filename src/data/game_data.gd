class_name PS3GameData

var meseta: int = 0

var characters: Array[PS3CharacterData] = []

var party: Array[PS3CharacterData] = []

var items: Array[PS3Item] = [
    PS3Item.new(PS3ItemType.MONOMATE, 127),
    PS3Item.new(PS3ItemType.DIMATE, 127),
]
