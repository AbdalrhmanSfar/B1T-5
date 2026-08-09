extends CharacterBody2D

@onready var logic: Node = %"Logic Manager"

var current_lane: int
var is_switching := false
var _tween: Tween

@export var lean_degrees := 6.0
@export var rotate_time := 0.35
@export var steering_wheel: Node2D
signal carMoved

func _ready() -> void:
	current_lane = clampi(logic.start_lane, 0, logic.lane_count - 1)
	var p := position
	p.x = lane_center_x(current_lane)
	position = p
	rotation_degrees = 0.0

func _process(_delta: float) -> void:
	if !logic.alive:
		return
	
	if logic.switch_lock and is_switching:
		return

	if Input.is_action_just_pressed("lane_right"):
		request_lane(current_lane + 1)
		carMoved.emit()
	elif Input.is_action_just_pressed("lane_left"):
		request_lane(current_lane - 1)
		carMoved.emit()
	

func request_lane(new_lane: int) -> void:
	new_lane = clampi(new_lane, 0, logic.lane_count - 1)
	if new_lane == current_lane:
		return

	var dir: float = float(new_lane - current_lane)
	current_lane = new_lane
	_move_to_lane_center(current_lane, dir)

func lane_center_x(lane_index: int) -> float:
	if logic.sceneID == 1:
		return (-logic.street_width * 0.5) + logic.lane_width * (float(lane_index) + 0.5) + 1497.0
	else:
		return (-logic.street_width * 0.5) + logic.lane_width * (float(lane_index) + 0.5)

func _move_to_lane_center(lane_index: int, dir: float) -> void:
	is_switching = true

	var target_x := lane_center_x(lane_index)
	var target_pos := position
	target_pos.x = target_x

	if is_instance_valid(_tween):
		_tween.kill()

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_OUT)

	var rot_time: float = logic.switch_dur * rotate_time

	_tween.tween_property(
		self, "rotation_degrees",
		dir * lean_degrees,
		rot_time
	)

	if is_instance_valid(steering_wheel):
		_tween.tween_property(
			steering_wheel, "rotation_degrees",
			dir * lean_degrees * 3,
			rot_time * 3
		)

	_tween.tween_property(self, "position", target_pos, logic.switch_dur)

	_tween.tween_property(
		self, "rotation_degrees",
		0.0,
		rot_time
	)

	if is_instance_valid(steering_wheel):
		_tween.tween_property(
			steering_wheel, "rotation_degrees",
			0.0,
			rot_time * 2
		)

	_tween.finished.connect(func() -> void:
		is_switching = false
		rotation_degrees = 0.0
		if is_instance_valid(steering_wheel):
			steering_wheel.rotation_degrees = 0.0
	)
