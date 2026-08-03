extends Node

@onready var logic: Node = %"Logic Manager"
@onready var pauseMenu: Control = $"CanvasLayer/Pause Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause_ui() -> void:
	pauseMenu.visible = true
	
func unpause_ui() -> void:
	pauseMenu.visible = false
