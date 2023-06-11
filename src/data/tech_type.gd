class_name PS3TechType

var name: String:
    get:
        return "undefined"

var cost: int:
    get:
        return self._cost

var _cost: int

func _init(cost: int):
    self._cost = cost
