extends Node

@onready var logic: Node = %"Logic Manager"
@onready var score: RichTextLabel = %"ScoreUI"
@export var streetsSpeed = 50.0
@onready var streets: CanvasLayer = $"../movingStreet"

var queue: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in streets.get_children():
		queue.push_back(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if logic.alive:
		score.text = "Score: " + str(logic.score).pad_decimals(1)
	for i in range(queue.size()):
		queue[i].position.y += (streetsSpeed * _delta)
	var isOutside = not queue.back().get_viewport_rect().intersects(queue.back().get_global_rect())
	if isOutside:
		queue.back().position.y = queue[0].position.y - 630
		queue.push_front(queue.pop_back())
		print("moved road")
	
	
	
	
	
