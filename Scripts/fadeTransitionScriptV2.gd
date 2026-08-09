extends CanvasLayer

@onready var animPlayer: AnimationPlayer = $fadeTransition/AnimationPlayer
@onready var sceneTransitionTimer: Timer = $fadeTransition/sceneTransitionTimer1
var sceneToLoad
@onready var sceneTransitionTimer2: Timer = $fadeTransition/sceneTransitionTimer2
@onready var blinkTimer: Timer = $fadeTransition/blinkTimer1
@onready var blinkTimer2: Timer = $fadeTransition/blinkTimer2
var fadeOutTime


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print(visible)
	pass


func loadScene(sceneName: String): 
	show()
	print("fade scene show")
	animPlayer.speed_scale = 1.0
	sceneToLoad = sceneName
	sceneTransitionTimer.start()
	animPlayer.play("fadeIn")


func _on_timer_timeout() -> void:
	print("called")
	get_tree().change_scene_to_file(sceneToLoad)
	animPlayer.play("fadeOut")
	sceneTransitionTimer2.start()


func _on_timer_2_timeout() -> void:
	print("fade scene hide")
	hide()

func blink(blinkDuration: float, fadeInDuration: float, fadeOutDuration: float): 
	show()
	print("fade scene show")
	animPlayer.speed_scale = 1.0 / fadeInDuration
	blinkTimer.wait_time = fadeInDuration
	blinkTimer2.wait_time = blinkDuration
	fadeOutTime = fadeOutDuration
	blinkTimer.start()
	animPlayer.play("fadeIn")


func _on_blink_timer_1_timeout() -> void:
	blinkTimer2.start()
	print(blinkTimer2.wait_time)


func _on_blink_timer_2_timeout() -> void:
	print("fade scene hide")
	print("play fadeOut")
	animPlayer.speed_scale = 1.0 / fadeOutTime
	animPlayer.play("fadeOut")
	await animPlayer.animation_finished
	hide()

func abort():
	print("fade scene hide")
	hide()
	sceneTransitionTimer.stop()
	sceneTransitionTimer2.stop()
	blinkTimer.stop()
	blinkTimer2.stop()
