extends Node

var initial_off_time = 5
var range_start = 3
var range_end = 10
@onready var timer: Timer = $"Timer"
@onready var objects: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objects = get_meta("Objects")
	timer.start(initial_off_time)

func _on_timer_timeout() -> void:
	spawnRandomObject()
	timer.start(randi_range(range_start,range_end))
	
func spawnRandomObject() -> void:
	var the_chosen_one = objects[randi_range(0,objects.size()-1)]
	var object = the_chosen_one.instantiate()
	print("Spawned")
	object.set_script(null) # ts just for placeholder reasons cause player script be stupid
	add_child(object)
	object.position = Vector2(0,0) # set to spawner's position
