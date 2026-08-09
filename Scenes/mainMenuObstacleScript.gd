extends CharacterBody2D

var speed: float # edit from meta data for each different obstacle. can be edited from some other script if needed

#@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var logic: Node = %"Logic Manager"
var paused = true
@onready var killObstacles: Node2D = $"../../killObstacles"
var sent = false

func _ready() -> void:
	speed = get_meta("Speed")
	print("ALIVE")

func _physics_process(_delta: float) -> void:
	if paused:
		return
	velocity.y = (speed+logic.globalSpeedIncrement)*logic.speedScale
	move_and_slide()
	if get_slide_collision_count() > 0:
		logic.emitObsticleDied(0)
		#queue_free() 
	if killObstacles.position.y < position.y and !sent:
		logic.emitObsticleDied(1)
		sent = true
		#queue_free()
