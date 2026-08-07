extends CharacterBody2D

@export var lane_count: int = 3
@export var street_width: float = 9.0
@export var start_lane: int = 1

@export var switch_dur: float = 0.12
@export var switch_lock: bool = true

var lane_width: float
var current_lane: int
var is_switching := false
var _tween: Tween


func _ready() -> void:
	lane_width = street_width / float(lane_count)
	current_lane = clampi(start_lane, 0, lane_count - 1)

	var p := position
	p.x = lane_center_x(current_lane)
	position = p


func _process(_delta: float) -> void:
	if switch_lock and is_switching:
		return

	if Input.is_action_just_pressed("lane_right"):
		request_lane(current_lane + 1)
	elif Input.is_action_just_pressed("lane_left"):
		request_lane(current_lane - 1)


func request_lane(new_lane: int) -> void:
	new_lane = clampi(new_lane, 0, lane_count - 1)
	if new_lane == current_lane:
		return

	current_lane = new_lane
	_move_to_lane_center(current_lane)


func lane_center_x(lane_index: int) -> float:
	return (-street_width * 0.5) + lane_width * (float(lane_index) + 0.5)


func _move_to_lane_center(lane_index: int) -> void:
	is_switching = true

	var target_x := lane_center_x(lane_index)
	var target_pos := position
	target_pos.x = target_x

	if is_instance_valid(_tween):
		_tween.kill()

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_OUT)

	_tween.tween_property(self, "position", target_pos, switch_dur)
	_tween.finished.connect(func() -> void:
		is_switching = false
	)
