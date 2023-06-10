class_name NodeExtFn

static func enable(node: Node) -> void:
    node.propagate_call("set_disabled", [false])
    node.propagate_call("set_editable", [true])

static func disable(node: Node) -> void:
    node.propagate_call("set_disabled", [true])
    node.propagate_call("set_editable", [false])

static func outer_clicked(node: Node, event: InputEvent) -> bool:
    if not (event is InputEventMouseButton and event.pressed):
        return false
    return false

static func _recursive_outer_clicked(node: Node, event: InputEventMouseButton) -> bool:
    var parent = self.get_parent()
    if parent == null:
        return true
    var i = parent.get_child_count()
    while i >= 0:
        if NodeExtFn._single_outer_clicked(parent.get_child(i), event):
            return true
        i -= 1

static func _single_outer_clicked(node: Node, event: InputEventMouseButton) -> bool:
    if node is CanvasItem:
        var ev_local = node.make_input_local(event)
        return !Rect2(Vector2(0, 0), node.size).has_point(ev_local.position)
    return false
