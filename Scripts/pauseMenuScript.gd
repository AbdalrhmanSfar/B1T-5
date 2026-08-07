extends CanvasLayer

@onready var pauseMenu: Panel = $Panel
@onready var settingsMenu: Panel = $settingsPanel
@onready var fadePanel: ColorRect = %fadeTransition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			_on_resume_button_pressed()
		else:
			visible = true
			pauseMenu.show() 
			get_tree().paused = true
			MusicPlayerSingleton.stream_paused = true 
			
	if Global.closedSettings:
		Global.closedSettings = false
		pauseMenu.show()
		MusicPlayerSingleton.stream_paused = true


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	MusicPlayerSingleton.stream_paused = false


func _on_settings_button_pressed() -> void:
	pauseMenu.hide()
	settingsMenu.show() 
	MusicPlayerSingleton.stream_paused = false


func _on_quit_to_main_button_pressed() -> void:
	MusicPlayerSingleton.stream_paused = false
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene("res://Scenes/mainMenuScene.tscn")


func _on_restart_button_pressed() -> void:
	MusicPlayerSingleton.stream_paused = false
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene(get_tree().current_scene.scene_file_path)
