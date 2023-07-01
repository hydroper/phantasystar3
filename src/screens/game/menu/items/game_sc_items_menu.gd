extends UISublayer

var game_data: PS3GameData = null

func open(data: Variant) -> void:
    # data is PS3Character
    self._selected_character = data
    $item_selector.popup()
    $context/outer.visible = false
    $report/outer.visible = false
    self._update_items()

# Closes any sublayer and the current layer itself.
func close(_data: Variant) -> void:
    $item_selector.collapse("close_current_and_parent")
    $item_details.collapse()
    $context/context.collapse()
    $report/report.collapse()

# If there is any sublayer, closes only it; if none,
# closes the current layer.
func close_sublayer(_data: Variant) -> void:
    if $context/context.is_open:
        $context/context.collapse("close_context")
    elif $report/report.is_open:
        $report/report.collapse("close_report")
    else:
        $item_selector.collapse("close_current")
        $item_details.collapse()
        $context/context.collapse()
        $report/report.collapse()

var _sublayer: UISublayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
