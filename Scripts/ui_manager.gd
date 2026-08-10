extends Node

@onready var logic: Node = %"Logic Manager"
@onready var score: Label = %ScoreUI
@export var streetsSpeed = 1.0 # base speed before car speeding up (which is the increase in difficulty)
@onready var streets: CanvasLayer = $"../movingStreet"
@onready var speedHandle: Node2D = %"handle"
var queue: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in streets.get_children():
		queue.push_back(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if logic.alive:
		score.text = str(logic.score).pad_decimals(0)
	for i in range(queue.size()):
		queue[i].position.y += ((streetsSpeed + logic.globalSpeedIncrement) * logic.speedScale * _delta)
	var isOutside = not queue.back().get_viewport_rect().intersects(queue.back().get_global_rect())
	if isOutside:
		queue.back().position.y = queue[0].position.y - 1890
		queue.push_front(queue.pop_back())
		print("moved road")
	
	speedHandle.rotation_degrees = -88 + 176.0*((1.0+logic.globalSpeedIncrement)/(1.0+logic.globalSpeedIncrementMax))
