extends Node

@export var lane_count: int = 3
@export var street_width: float = 470
@export var pavementWidth: float = 610
var lane_width: float
@export var start_lane: int = 1
@export var switch_dur: float = 0.12
@export var switch_lock: bool = true
@export var gameDifficulty: int = 0
@export var difficultyThresholds: Array[float] = [20, 40, 70, 120, 150, 200, 250, 300, 500, 1000]
var maxDifficulty: int
@export var globalSpeedIncrements: Array[float] = [0, 0.4, 0.8, 1, 1.2, 1.4, 1.6, 2, 2.5, 3]
var globalSpeedIncrement: float = globalSpeedIncrements[0]
var globalSpeedIncrementTarget: float = globalSpeedIncrements[0]
@export var lerp_speed: float = 6.0
@export var blinkLengthDifficulty: Array[float] = [2, 2, 1.5, 1, 0.7, 0.7, 0.7, 0.5, 0.3, 0.3]
@export var timeBetweenBlinks: Array[float] = [15, 10, 10, 8, 8, 8, 8, 8, 8, 8]

@onready var player: Node = %"Player"
@onready var UIManagar: Node = %"UI Manager"
const speedScale = 300.0 # speed will be (Speed+playerspeed) * speedScale
var paused: bool = false
var score: float = 0 # time survived
var multiplyer: float = 1.0
@export var initialEnergy: int  = 10
@export var energyAfterLongBlink: int = 10
var energy: int
var timer = 0.0
var alive = true
var sceneID = 2

@onready var gameOverMenu: CanvasLayer = $"../gameOverMenu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lane_width = street_width / float(lane_count)
	energy = initialEnergy
	maxDifficulty = difficultyThresholds.size()-1
	globalSpeedIncrementTarget = globalSpeedIncrements[0]
	globalSpeedIncrement = globalSpeedIncrementTarget


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !alive or paused:
		return
	
	timer += _delta
	score += (multiplyer * _delta * 10)
	gameDifficulty = clampi(gameDifficulty,0,maxDifficulty)
	if gameDifficulty < maxDifficulty and score >= difficultyThresholds[gameDifficulty]:
		gameDifficulty += 1
		globalSpeedIncrementTarget = globalSpeedIncrements[gameDifficulty]
		SFX.vroom_sfx()
	globalSpeedIncrement = lerp(globalSpeedIncrement, globalSpeedIncrementTarget, min(1.0, _delta * lerp_speed))
	
	if int(timer) != int(timer - _delta): 
		energy -= 1
		if energy == 0:
			energy = int(timeBetweenBlinks[gameDifficulty])
			FadeTransitionSceneV2.blink(blinkLengthDifficulty[gameDifficulty], blinkLengthDifficulty[gameDifficulty]/2, blinkLengthDifficulty[gameDifficulty]/2)
	
	if get_tree().paused:
		paused = true
	else: 
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
	shouldSaveHighScore(Global.playerName, score)
	print("play crash sfx")
	gameOverMenu.show()
	get_tree().paused = true
	score = 0
	alive = false
	FadeTransitionSceneV2.abort()
	SFX.lose_sfx()
	await SFX.crash_sfx()
