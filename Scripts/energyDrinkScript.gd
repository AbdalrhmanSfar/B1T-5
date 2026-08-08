extends CharacterBody2D

@onready var logic
@export var energyGranted = 10.0
const speedScale = 100.0
var speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	logic = get_node($"/root/Game/Logic Manager".get_path())


func _physics_process(_delta: float) -> void:
	if logic.paused:
		return
	velocity.y = (speed+logic.globalSpeedIncrement)*speedScale
	move_and_slide()
	if get_slide_collision_count() > 0:
		logic.energy += energyGranted
		queue_free()
