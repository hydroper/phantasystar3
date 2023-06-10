class_name NodeExtFn

static func enable(node: Node) -> void:
    node.propagate_call("set_disabled", [false])
    node.propagate_call("set_editable", [true])

static func disable(node: Node) -> void:
    node.propagate_call("set_disabled", [true])
    node.propagate_call("set_editable", [false])
