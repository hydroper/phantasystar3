class_name PS3ItemCategory

static var CONSUMABLE: PS3ItemCategory = PS3ItemCategory.new()
static var HEAD: PS3ItemCategory = PS3ItemCategory.new()
static var TORSO: PS3ItemCategory = PS3ItemCategory.new()
static var FEET: PS3ItemCategory = PS3ItemCategory.new()
static var BUCKLE: PS3ItemCategory = PS3ItemCategory.new()

# left/right hand
static var WEAPON: PS3ItemCategory = PS3ItemCategory.new()

static var OTHER: PS3ItemCategory = PS3ItemCategory.new()

var is_armor: bool:
    get:
        return [
            PS3ItemCategory.HEAD,
            PS3ItemCategory.TORSO,
            PS3ItemCategory.FEET,
            PS3ItemCategory.BUCKLE,
        ].find(self) != -1
