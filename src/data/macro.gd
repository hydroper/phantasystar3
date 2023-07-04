class_name PS3Macro

var index: int

var letter: String:
    get:
        return String.chr(0x41 + index)

func _init(index: int):
    self.index = index
