extends Node2D

var initial_off_time_start = 3
var initial_off_time_end = 20
var range_start = 3
var range_end = 30
@onready var logic: Node = %"Logic Manager"
@onready var timer: Timer = $"Timer"
@onready var objects: Array
@onready var laneIndex: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objects = get_meta("Objects")
	laneIndex = get_meta("index")
	position.x = (-logic.street_width * 0.5) + logic.lane_width * (float(laneIndex) + 0.5)
	timer.start(randi_range(initial_off_time_start,initial_off_time_end))

func _on_timer_timeout() -> void:
	spawnRandomObject()
	timer.start(randi_range(range_start,range_end))
	
func spawnRandomObject() -> void:
	var the_chosen_one: PackedScene = objects[randi_range(0,objects.size()-1)]
	var object = the_chosen_one.instantiate()
	print("Spawned")
	add_child(object)
	object.position = Vector2(0,0) # set to spawner's position
	object._ready()
