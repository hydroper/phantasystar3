extends Node2D

var game_data: GameData = GameData.new()

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
        if not self.paused:
            self.toggle_pause())
    self.pause_subsequent_controls = []

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        self.toggle_pause()
    if self.paused:
        return

func _input(event: InputEvent) -> void:
    if self.paused and NodeExtFn.outer_clicked($ui/pause/background, event):
        self.toggle_pause()

func toggle_pause() -> void:
    if NodeExtFn.any_is_visible(self.pause_subsequent_controls):
        return
    self.paused = not self.paused
    $ui/pause.visible = self.paused
    if self.paused:
        $ui/pause/buttons1/items_btn.grab_focus()
