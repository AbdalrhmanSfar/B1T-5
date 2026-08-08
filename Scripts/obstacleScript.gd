extends CharacterBody2D

var speed: float # edit from meta data for each different obstacle. can be edited from some other script if needed

#@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var logic: Node

func _ready() -> void:
	speed = get_meta("Speed")
	logic = get_node($"/root/Game/Logic Manager".get_path())
	print("ALIVE")

func _physics_process(_delta: float) -> void:
	if logic.paused:
		return
	velocity.y = (speed+logic.globalSpeedIncrement)*logic.speedScale
	move_and_slide()
	if get_slide_collision_count() > 0:
		logic.gameOver()
		queue_free() 

	
