extends Node

@export var lane_count: int = 3
@export var street_width: float = 500
var lane_width: float
@export var start_lane: int = 1
@export var switch_dur: float = 0.12
@export var switch_lock: bool = true
@onready var player: Node = %"Player"
@onready var UIManagar: Node = %"UI Manager"
var paused: bool = false
var score: float = 2000 # time survived
var multiplyer: float = 1.0
@export var initialEnergy: int  = 10
@export var energyAfterLongBlink: int = 10
var energy: int
var timer = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lane_width = street_width / float(lane_count)
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

func shouldSaveHighScore(playerName: String, newScore: float):
	print("Call coroutine")
	print(newScore)
	var playerScores: Dictionary = await SilentWolf.Scores.get_top_score_by_player(playerName).sw_top_player_score_complete
	var shouldSave = false
	print("check if the player has a score")
	if playerScores.has("top_score") and playerScores.top_score != null:
		print("player has score")
		var highScore = playerScores.top_score.score
		if newScore > highScore:
			shouldSave = true
			# delete
			var oldHighScoreID = playerScores.top_score.score_id
			await SilentWolf.Scores.delete_score(oldHighScoreID)
	else:
		print("player does not have score")
		shouldSave = true
	print(shouldSave)
	print(newScore)
	if shouldSave:
		await SilentWolf.Scores.save_score(Global.playerName, newScore)
	

func gameOver():
	print("GAME OVER")
	print(score)
	shouldSaveHighScore(Global.playerName, score)
	score = 0
	# just for now 
	#get_tree().change_scene_to_file("res://Scenes/mainMenuScene.tscn")
