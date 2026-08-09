extends Control

@onready var creditsPanel: Panel = $creditsPanel
@onready var mainButtons: VBoxContainer = $mainButtons
@onready var settingsPanel: CanvasLayer = $settingsPanel
@onready var enterNameContainer: Control = $enterNameContainer
@onready var nameBox: LineEdit = $enterNameContainer/LineEdit

@export var streetsSpeed = 1.0 # base speed before car speeding up (which is the increase in difficulty)
@onready var streets: Control = $movingStreet/Control
var queue: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This line is for clearing the leaderboard date
	# Just uncomment the code line and run the game for one time 
	# THIS ACTION IS IRREVERSIBLE
	#SilentWolf.Scores.wipe_leaderboard() 
	
	for child in streets.get_children():
		queue.push_back(child)
	
	mainButtons.show()
	settingsPanel.hide()
	creditsPanel.hide()
	
	if Global.config.get_value("settings", "name") == "a":
		mainButtons.hide()
		enterNameContainer.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if creditsPanel.visible:
			_on_quit_credits_pressed()
		elif settingsPanel.visible:
			settingsPanel.hide()
			mainButtons.show()
	
	if Global.closedSettings:
		Global.closedSettings = false
		mainButtons.show()
	
	for i in range(queue.size()):
		queue[i].position.y += (streetsSpeed * _delta)
	var isOutside = not queue.back().get_viewport_rect().intersects(queue.back().get_global_rect())
	if isOutside:
		queue.back().position.y = queue[0].position.y - 1890
		queue.push_front(queue.pop_back())
		print("moved road")

func _on_play_button_pressed() -> void:
	FadeTransitionSceneV2.loadScene("res://Scenes/main_game_scene.tscn")
	#fadePanel.show()
	#fadePanel.get_node("fadeTimer").start()
	#fadePanel.get_node("AnimationPlayer").play("fadeIn")

func _on_settings_buton_pressed() -> void:
	mainButtons.hide()
	settingsPanel.show()


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	creditsPanel.show()
	mainButtons.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Sections/main_game_scene.tscn")

func _on_quit_credits_pressed() -> void:
	creditsPanel.hide()
	mainButtons.show()


func _on_submit_name_button_pressed() -> void:
	Global.config.set_value("settings","name",nameBox.text)
	Global.config.save(Global.settingsFilePath)
	Global.playerName = nameBox.text
	enterNameContainer.hide()
	mainButtons.show()
