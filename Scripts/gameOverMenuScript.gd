extends CanvasLayer


func _on_restart_button_pressed() -> void:
	SFX.button_sfx()
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene(get_tree().current_scene.scene_file_path)


func _on_quit_to_main_menu_button_pressed() -> void:
	SFX.button_sfx()
	get_tree().paused = false
	FadeTransitionSceneV2.loadScene("res://Scenes/mainMenuScene.tscn")


func _on_restart_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_quit_to_main_menu_button_mouse_entered() -> void:
	SFX.hover_sfx()
