extends Node

@export var lane_count: int = 3
@export var street_width: float = 470
var lane_width: float
@export var start_lane: int = 1
@export var switch_dur: float = 0.12
@export var switch_lock: bool = true
@export var lerp_speed: float = 12.0
@export var globalSpeedIncrements: Array[float] = [0, 0.2, 0.8, 1.8, 3]
var globalSpeedIncrement: float = globalSpeedIncrements[0]
var obsticleDiedID
signal obsticleDied
var sceneID = 1

const speedScale = 225.0 # speed will be Speed field * speedScale
@export var initialEnergy: int  = 30
var energy: int
var timer = 0.0
var alive = false
var paused = false
var startBlinkTimer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lane_width = street_width / float(lane_count)
	energy = initialEnergy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if startBlinkTimer:
		timer += _delta
	
	if int(timer) != int(timer - _delta): 
		energy -= 1
		if energy == 0:
			energy = 10
			FadeTransitionSceneV2.blink(1.1, 0.5, 0.5)

func emitObsticleDied(id: int):
	if id == 0:
		SFX.crash_sfx()
	obsticleDiedID = id
	obsticleDied.emit()
