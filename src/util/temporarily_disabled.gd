# Allows disabling Godot nodes temporarily and returning
# to their disabled state back.
class_name TemporarilyDisabled

var disabled: bool:
    get:
        return self._disabled
    set(value):
        if value:
            self._disabled = true
            self._temporarily_disable(self._top_node)
        else:
            self._disabled = false
            self._back_to_previous_state()

func _init(top_node: Node):
    self._top_node = top_node

var _disabled: bool = false
var _top_node: Node
var _previous_state: Dictionary = {}

func _temporarily_disable(node: Node) -> void:
    if NodeExtFn.can_be_disabled(node):
        self._previous_state[node] = NodeExtFn.get_disabled(node)
        NodeExtFn.set_disabled(node, true)
    for child in node.get_children():
        self._temporarily_disable(child)

func _back_to_previous_state() -> void:
    for node in self._previous_state:
        NodeExtFn.set_disabled(node, self._previous_state[node])
    self._previous_state.clear()
