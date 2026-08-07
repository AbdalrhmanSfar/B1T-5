extends Node

@export var lane_count: int = 3
@export var street_width: float = 9.0
var lane_width: float
@export var start_lane: int = 1
@export var switch_dur: float = 0.12
@export var switch_lock: bool = true

@onready var player: Node = %"Player"
@onready var UIManagar: Node = %"UI Manager"
var paused = false
var score = 0.0 # time survived

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lane_width = street_width / float(lane_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	print("GAME OVER")
	SilentWolf.Scores.save_score(Global.playerName, score)
	score = 0
