class_name NodeExtFn

static func enable(node: Node) -> void:
    node.propagate_call("set_disabled", [false])
    node.propagate_call("set_editable", [true])

static func disable(node: Node) -> void:
    node.propagate_call("set_disabled", [true])
    node.propagate_call("set_editable", [false])

static func get_pressed_button(list: Variant) -> BaseButton:
    if list is Array:
        var f = list.filter(func(a): return a is BaseButton and a.button_pressed)
        return null if len(f) == 0 else f[0]
    return NodeExtFn.get_pressed_button(list.get_children()) if list is Node else null

static func get_focused(list: Variant) -> Control:
    if list is Array:
        var f = list.filter(func(a): return a is Control and a.has_focus())
        return null if len(f) == 0 else f[0]
    return NodeExtFn.get_focused(list.get_children()) if list is Node else null

static func get_hovered_button(list: Variant) -> BaseButton:
    if list is Array:
        var f = list.filter(func(a): return a is BaseButton and a.is_hovered())
        return null if len(f) == 0 else f[0]
    return NodeExtFn.get_hovered_button(list.get_children()) if list is Node else null

static func remove_all_children(node: Node) -> void:
    for child in node.get_children():
        node.remove_child(child)

static func outer_clicked(node: Node, event: InputEvent) -> bool:
    if not (event is InputEventMouseButton and event.pressed and node is Control and node.visible):
        return false
    var ev_local = node.make_input_local(event)
    return !Rect2(Vector2(0, 0), node.size).has_point(ev_local.position)

static func any_is_visible(list: Array[Node]) -> bool:
    return list.any(func(a): return a is CanvasItem and a.visible)
