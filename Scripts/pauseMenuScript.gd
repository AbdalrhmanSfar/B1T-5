extends CanvasLayer

@onready var pauseMenu: Panel = $Panel
@onready var settingsMenu: CanvasLayer = $settingsPanel
@onready var logic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	logic = get_node($"/root/Game/Logic Manager".get_path())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !logic.alive or FadeTransitionSceneV2.visible:
		return
	
	if Input.is_action_just_pressed("pause"):
		if visible and pauseMenu.visible:
			_on_resume_button_pressed()
		elif visible and settingsMenu.visible:
			settingsMenu.visible = false
			pauseMenu.visible = true
			MusicPlayerSingleton.stream_paused = true
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
	SFX.button_sfx()
	visible = false
	get_tree().paused = false
	MusicPlayerSingleton.stream_paused = false


func _on_settings_button_pressed() -> void:
	SFX.button_sfx()
	pauseMenu.hide()
	settingsMenu.show() 
	MusicPlayerSingleton.stream_paused = false


func _on_quit_to_main_button_pressed() -> void:
	SFX.button_sfx()
	MusicPlayerSingleton.stream_paused = false
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene("res://Scenes/mainMenuScene.tscn")


func _on_restart_button_pressed() -> void:
	SFX.button_sfx()
	MusicPlayerSingleton.stream_paused = false
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene(get_tree().current_scene.scene_file_path)


func _on_resume_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_restart_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_settings_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_quit_to_main_button_mouse_entered() -> void:
	SFX.hover_sfx()
