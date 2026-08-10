extends Node2D

@export var range_start: float = 0.1
@export var range_end: float = 0.4

@onready var logic: Node = %"Logic Manager"
@onready var timer: Timer = $"Timer"
@onready var objects: Array
@onready var probabilities: Array
var probSum=0
var canSpawn = false # this will edit itself when the initial decoration leaves the spawning area
var index: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	index = get_meta("index")
	position.x = logic.screenCenter + logic.pavementWidth*(-0.5+index)
	objects = get_meta("Objects")
	probabilities = get_meta("Probabilities")
	for p in probabilities:
		probSum += p
	timer.start(randf_range(range_start,range_end))

func _on_timer_timeout() -> void:
	if canSpawn:
		spawnRandomObject()
	timer.start(randf_range(range_start,range_end))

func getIndex(choice: int) -> int:
	for i in range(probabilities.size()):
		if probabilities[i] >= choice: 
			return i
		else:
			choice -= probabilities[i]
	return -1 #if fail or smth default to last obstacle

func spawnRandomObject() -> void:
	var t = randi_range(1,probSum)
	var the_chosen_one: PackedScene = objects[getIndex(t)]
	var object = the_chosen_one.instantiate()
	print("Spawned")
	add_child(object)
	object.position = Vector2(0,0)
	if index == 0:
		object.rotation_degrees = 180
	canSpawn = false


func _on_area_2d_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	canSpawn = true
