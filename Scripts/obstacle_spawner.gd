extends Node2D

var initial_off_time_start = 1
var initial_off_time_end = 5
var range_start: Array[float] = [5,4,3,2,1]
var range_end: Array[float] = [25,15,7,7,7]
@onready var logic: Node = %"Logic Manager"
@onready var timer: Array[Timer] = [$"lane1/Timer1",$"lane2/Timer2",$"lane3/Timer3"]
@onready var objects: Array
@onready var lanes: Array[Node2D] = [$"lane1",$"lane2",$"lane3"]
@onready var consequtiveSpawningThreshold: float = 1200
var laneQueue: Array
var laneLatestPosition: Array[float] = [0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	objects = get_meta("Objects")
	for laneIndex in range(lanes.size()):
		laneQueue.push_back([])
		lanes[laneIndex].position.x = (-logic.street_width * 0.5) + logic.lane_width * (float(laneIndex) + 0.5)
		timer[laneIndex].start(randi_range(initial_off_time_start,initial_off_time_end))

func _process(_delta: float) -> void:
	for i in range(laneQueue.size()):
		while laneQueue[i].size():
			if not is_instance_valid(laneQueue[i][-1]): 
				laneQueue[i].pop_back()
			else:
				break
	
	for i in range(laneQueue.size()):
		if laneQueue[i].size():
			laneLatestPosition[i]=laneQueue[i][0].position.y - position.y
		else:
			laneLatestPosition[i]=100000


func spawnRandomObject(laneIndex: int) -> void:
	var the_chosen_one: PackedScene = objects[randi_range(0,objects.size()-1)]
	var object = the_chosen_one.instantiate()
	print("Spawned")
	lanes[laneIndex].add_child(object)
	laneQueue[laneIndex].push_front(object)


func _on_timer_1_timeout() -> void:
	if not (laneLatestPosition[1] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[1]) + " is ok to spawn")
		spawnRandomObject(0)
	timer[0].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))


func _on_timer_2_timeout() -> void:
	if not (laneLatestPosition[0] < consequtiveSpawningThreshold and laneLatestPosition[2] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[0]) + str(laneLatestPosition[2]) + " is ok to spawn")
		spawnRandomObject(1)
	timer[1].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))


func _on_timer_3_timeout() -> void:
	if not (laneLatestPosition[1] < consequtiveSpawningThreshold):
		print(str(laneLatestPosition[1]) + " is ok to spawn")
		spawnRandomObject(2)
	timer[2].start(randf_range(range_start[logic.gameDifficulty],range_end[logic.gameDifficulty]))
