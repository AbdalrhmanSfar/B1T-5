extends Node

@onready var player: Node = %"Player"
@onready var UIManagar: Node = %"UI Manager"
var paused = false
var score = 0.0 # time survived
var multiplyer = 1.0
@export var initialEnergy = 10
@export var energyAfterLongBlink = 10
var energy: int
var timer = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	energy = initialEnergy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	timer += _delta
	score += (multiplyer * _delta)
	if int(timer) != int(timer - _delta): 
		energy -= 1
		if energy == 0:
			energy = energyAfterLongBlink
			FadeTransitionSceneV2.blink(2.0, 0.5)
	
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
	SilentWolf.Scores.save_score("Global.playerName", score)
	score = 0
