class_name GameScreenPause
extends Control

var subsequent_panels: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
    self.subsequent_panels = [
        $top_content,
        $character_selection,
    ]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
