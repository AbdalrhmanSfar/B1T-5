extends Node

@onready var player: Node = %"Player"
@onready var UIManagar: Node = %"UI Manager"
var paused = false
var score = 0.0 # time survived

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not paused:
			pause_game()
		else:
			unpause_game()

func pause_game() -> void:
	paused = true

func unpause_game() -> void:
	paused = false

func gameOver():
	SilentWolf.Scores.save_score(Global.playerName, score)
	score = 0
