extends Node2D

var initial_off_time_start = 1
var initial_off_time_end = 5
@export var range_start: Array[float] = [3,3,3,3,2,2,2,1,1,0.75]
@export var range_end: Array[float] = [25,15,7,7,7,5,5,3,3,3]
@onready var logic: Node = %"Logic Manager"
@onready var timer: Array[Timer] = [$"lane1/Timer1",$"lane2/Timer2",$"lane3/Timer3"]
var objects: Array
var probabilities: Array
@onready var lanes: Array[Node2D] = [$"lane1",$"lane2",$"lane3"]
@onready var consequtiveSpawningThreshold: float = 1200
var laneQueue: Array
var laneLatestPosition: Array[float] = [0,0,0]
var probSum=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objects = get_meta("Objects")
	probabilities = get_meta("Probabilities")
	for p in probabilities:
		probSum += p
	
	for laneIndex in range(lanes.size()):
		laneQueue.push_back([])
		lanes[laneIndex].position.x = logic.screenCenter + (-logic.street_width * 0.5) + logic.lane_width * (float(laneIndex) + 0.5)
		timer[laneIndex].start(randf_range(initial_off_time_start,initial_off_time_end))

func updateLatestPos(i: int) -> void:
	while laneQueue[i].size():
		if not is_instance_valid(laneQueue[i][-1]): 
			laneQueue[i].pop_back()
		else:
			break
	if laneQueue[i].size():
		laneLatestPosition[i]=laneQueue[i][0].position.y - position.y
	else:
		laneLatestPosition[i]=100000

func getIndex(choice: int) -> int:
	for i in range(probabilities.size()):
		if probabilities[i] >= choice: 
			return i
		else:
			choice -= probabilities[i]
	return -1 #if fail or smth default to last obstacle

func spawnRandomObject(laneIndex: int) -> void:
	var t = randi_range(1,probSum)
	var the_chosen_one: PackedScene = objects[getIndex(t)]
	var object = the_chosen_one.instantiate()
	while laneQueue[laneIndex].size() > 0 and object.has_meta("evilCarDetection"):
		object.queue_free()
		t = randi_range(1,probSum)
		the_chosen_one = objects[getIndex(t)]
		object = the_chosen_one.instantiate()
	print("Spawned")
	lanes[laneIndex].add_child(object)
	laneQueue[laneIndex].push_front(object)


func _on_timer_1_timeout() -> void:
	updateLatestPos(1)
	if not (laneLatestPosition[1] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[1]) + " is ok to spawn")
		spawnRandomObject(0)
	timer[0].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))


func _on_timer_2_timeout() -> void:
	updateLatestPos(0)
	updateLatestPos(2)
	if not (laneLatestPosition[0] < consequtiveSpawningThreshold and laneLatestPosition[2] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[0]) + str(laneLatestPosition[2]) + " is ok to spawn")
		spawnRandomObject(1)
	timer[1].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))


func _on_timer_3_timeout() -> void:
	updateLatestPos(1)
	if not (laneLatestPosition[1] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[1]) + " is ok to spawn")
		spawnRandomObject(2)
	timer[2].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))
