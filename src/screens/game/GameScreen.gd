extends Node2D

var game_data: PS3GameData = PS3GameData.new()

var paused: bool = false

var pause_subsequent_controls: Array[Node] = []

@onready
var world: Node2D = $world

@onready
var world_entities: Node2D = $world/entities

@onready
var world_entity_labels: Node2D = $world/entity_labels

func _ready() -> void:
    $ui/pause.visible = false
    $ui/pause_button.pressed.connect(func():
        self.toggle_pause())

func _input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        self.toggle_pause()
    elif self.paused:
        if event.is_action_released("ui_cancel"):
            self.toggle_pause()

func _process(_delta: float) -> void:
    pass

func toggle_pause() -> void:
    for p in $ui/pause.subsequent_panels:
        p.visible = false
    self.paused = not self.paused
    $ui/pause.visible = self.paused
    if self.paused:
        $ui/pause/top_content.visible = true
        $ui/pause/top_content/buttons1/items_btn.grab_focus()
