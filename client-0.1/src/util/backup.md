# Backup

## NodeExtFn

```gdscript
static func outer_clicked(node: Node, event: InputEvent) -> bool:
    if not (event is InputEventMouseButton and event.pressed):
        return false
    var p = node
    while p.get_parent() != null:
        p = p.get_parent()
    return NodeExtFn._recursive_outer_clicked(p, event) == node

static func _recursive_outer_clicked(node: Node, event: InputEventMouseButton) -> Node:
    if NodeExtFn._single_outer_clicked(node, event):
        return node
    if not node is Control:
        var i = node.get_child_count() - 1
        while i >= 0:
            var r = NodeExtFn._recursive_outer_clicked(node.get_child(i), event)
            if r != null:
                return r
            i -= 1
    return null

static func _single_outer_clicked(node: Node, event: InputEventMouseButton) -> bool:
    if node is Control and node.visible:
        var ev_local = node.make_input_local(event)
        return !Rect2(Vector2(0, 0), node.size).has_point(ev_local.position)
    return false
```