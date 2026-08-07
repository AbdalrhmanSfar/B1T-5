extends CanvasLayer

@onready var animPlayer: AnimationPlayer = $fadeTransition/AnimationPlayer
@onready var timer: Timer = $fadeTransition/Timer
var sceneToLoad
@onready var timer2: Timer = $fadeTransition/Timer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print(visible)
	pass


func loadScene(sceneName: String): 
	show()
	sceneToLoad = sceneName
	print(timer.wait_time)
	timer.start()
	animPlayer.play("fadeIn")


func _on_timer_timeout() -> void:
	print("called")
	get_tree().change_scene_to_file(sceneToLoad)
	animPlayer.play("fadeOut")
	timer2.start()


func _on_timer_2_timeout() -> void:
	print("hidden")
	hide()
