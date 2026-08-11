extends Node

@onready var logic: Node = %"Logic Manager"
@onready var score: Label = %ScoreUI
@export var streetsSpeed = 1.0 # base speed before car speeding up (which is the increase in difficulty)
@onready var streets: CanvasLayer = $"../movingStreet"
@onready var speedHandle: Node2D = %"handle"
var queue: Array = []
@onready var highScoreLabel: Label = $"../UI/VBoxContainer/highScoreLabel"
@onready var camera: Camera2D = %"Camera2D"
var cameraShaking: bool = false
@export var cameraShakeIntensity: float = 10
var laneWarnings: Array
@export var warningBlinkDuration: float = 0.25
@export var warningBlinkCount: int = 3
var blinkTimesLeft: Array[int] = [0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laneWarnings = %"Warnings".get_children()
	#print(laneWarnings.size())
	for child in streets.get_children():
		queue.push_back(child)
	for laneIndex in range(laneWarnings.size()):
		#print("set "+str(laneIndex)+" to "+str(logic.screenCenter + (-logic.street_width * 0.5) + logic.lane_width * (float(laneIndex) + 0.5)))
		laneWarnings[laneIndex].position.x = logic.screenCenter + (-logic.lane_width) + logic.lane_width * (float(laneIndex) )
		laneWarnings[laneIndex].visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if logic.alive:
		score.text = "SCORE: " + str(logic.score).pad_decimals(0)
	for i in range(queue.size()):
		queue[i].position.y += ((streetsSpeed + logic.globalSpeedIncrement) * logic.speedScale * _delta)
	var isOutside = not queue.back().get_viewport_rect().intersects(queue.back().get_global_rect())
	if isOutside:
		queue.back().position.y = queue[0].position.y - 1890
		queue.push_front(queue.pop_back())
		print("moved road")
	
	speedHandle.rotation_degrees = -88 + 176.0*((1.0+logic.globalSpeedIncrement)/(1.0+logic.globalSpeedIncrementMax))
	
	if cameraShaking:
		var t=cameraShakeIntensity*(logic.globalSpeedIncrementTarget-logic.globalSpeedIncrement)
		camera.offset.x = randf_range(-t,t)
		camera.offset.y = randf_range(-t,t)
	
			

func startCamShake() -> void:
	cameraShaking = true

func stopCamShake() -> void:
	camera.offset = Vector2(0,0)
	cameraShaking = false

func _on_obstacle_spawner_evil_spawn(laneIndex: int) -> void:
	blinkTimesLeft[laneIndex] = warningBlinkCount
	var timer = laneWarnings[laneIndex].get_child(0)
	laneWarnings[laneIndex].visible = true
	blinkTimesLeft[laneIndex] -= 1
	timer.start(warningBlinkDuration)

func _on_timer1_timeout() -> void:
	if laneWarnings[0].visible:
		laneWarnings[0].visible = false
		var timer = laneWarnings[0].get_child(0)
		timer.start(warningBlinkDuration/2)
	elif blinkTimesLeft[0]:
		laneWarnings[0].visible = true
		blinkTimesLeft[0] -= 1
		var timer = laneWarnings[0].get_child(0)
		timer.start(warningBlinkDuration)
		


func _on_timer2_timeout() -> void:
	if laneWarnings[1].visible:
		laneWarnings[1].visible = false
		var timer = laneWarnings[1].get_child(0)
		timer.start(warningBlinkDuration/2)
	elif blinkTimesLeft[1]:
		laneWarnings[1].visible = true
		blinkTimesLeft[1] -= 1
		var timer = laneWarnings[1].get_child(0)
		timer.start(warningBlinkDuration)


func _on_timer3_timeout() -> void:
	if laneWarnings[2].visible:
		laneWarnings[2].visible = false
		var timer = laneWarnings[2].get_child(0)
		timer.start(warningBlinkDuration/2)
	elif blinkTimesLeft[2]:
		laneWarnings[2].visible = true
		blinkTimesLeft[2] -= 1
		var timer = laneWarnings[2].get_child(0)
		timer.start(warningBlinkDuration)
