extends CharacterBody2D

const SPEED = 300.0

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var logic: Node = %"Logic Manager"

func _physics_process(_delta: float) -> void:
	if logic.paused:
		return
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Animations & Sprite
	
	if direction.x < 0 and animatedSprite.flip_h:
		animatedSprite.flip_h = false
		
	elif direction.x > 0 and not animatedSprite.flip_h:
		animatedSprite.flip_h = true
		

	#if direction and direction.y >= 0:
		#animatedSprite.play("Walk")
	#elif direction.y < 0:
		#animatedSprite.play("Walk Up")
	#else:
		#animatedSprite.play("Idle")
	
	# Physics

	if direction:
		velocity = direction * SPEED
		#velocity.x = direction.x * SPEED
		#velocity.y = direction.y * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
