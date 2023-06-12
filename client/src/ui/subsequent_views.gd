class_name SubsequentViews

static func close_recursive(subsequent: Array[Node]) -> void:
    for p in subsequent:
        if p is SubsequentNode2DView or p is SubsequentControlView:
            p.close_all_subsequent()
        p.visible = false
