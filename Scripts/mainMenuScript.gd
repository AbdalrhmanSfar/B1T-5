extends Control

@onready var creditsPanel: Panel = $creditsPanel
@onready var mainButtons: VBoxContainer = $mainButtons
@onready var settingsPanel: CanvasLayer = $settingsPanel
@onready var enterNameContainer: Control = $enterNameContainer
@onready var nameBox: LineEdit = $enterNameContainer/LineEdit
@onready var levelSelector: HBoxContainer = $levelSelector
@onready var playButton: Button = $mainButtons/playButton

var streetsSpeed = 1 # base speed before car speeding up (which is the increase in difficulty)
@onready var streets: Control = $movingStreet/Control
var queue: Array = []
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

signal acceptDirection
var tutorialMessages: Array = []
@onready var tutorialInstructions: Control = $tutorialInstructions
@onready var car: CharacterBody2D = $movingStreet/Car
@onready var logic: Node = %"Logic Manager"
@onready var obstacles: Node2D = $obstacles
var initialObstacleY: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This line is for clearing the leaderboard date
	# Just uncomment the code line and run the game for one time 
	# THIS ACTION IS IRREVERSIBLE
	#SilentWolf.Scores.wipe_leaderboard() 
	
	for child in streets.get_children():
		queue.push_back(child)
	
	for child in tutorialInstructions.get_children():
		tutorialMessages.push_back(child)
	
	for child in obstacles.get_children():
		initialObstacleY.push_back(child.position.y)
	
	mainButtons.show()
	settingsPanel.hide()
	creditsPanel.hide()
	tutorialInstructions.hide()
	
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
		queue[i].position.y += ((streetsSpeed + logic.globalSpeedIncrement) * logic.speedScale * _delta)
	var isOutside = not queue.back().get_viewport_rect().intersects(queue.back().get_global_rect())
	if isOutside:
		queue.back().position.y = queue[0].position.y - 1890
		queue.push_front(queue.pop_back())
		print("moved road")
	
	if Input.is_action_just_pressed("ui_accept"):
		acceptDirection.emit()

func _on_play_button_pressed() -> void:
	SFX.button_sfx()
	FadeTransitionSceneV2.loadScene("res://Scenes/main_game_scene.tscn")
	#fadePanel.show()
	#fadePanel.get_node("fadeTimer").start()
	#fadePanel.get_node("AnimationPlayer").play("fadeIn")

func _on_settings_buton_pressed() -> void:
	SFX.button_sfx()
	mainButtons.hide()
	settingsPanel.show()


func _on_leaderboard_button_pressed() -> void:
	SFX.button_sfx()
	get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	SFX.button_sfx()
	creditsPanel.show()
	mainButtons.hide()

func _on_quit_button_pressed() -> void:
	SFX.button_sfx()
	get_tree().quit()

func _on_quit_credits_pressed() -> void:
	SFX.button_sfx()
	creditsPanel.hide()
	mainButtons.show()


func _on_submit_name_button_pressed() -> void:
	SFX.button_sfx()
	Global.config.set_value("settings","name",nameBox.text)
	Global.config.save(Global.settingsFilePath)
	Global.playerName = nameBox.text
	enterNameContainer.hide()
	mainButtons.show()


func _on_first_play_button_pressed() -> void:
	SFX.button_sfx()
	levelSelector.show()

func startTutorial():
	tutorialInstructions.show()
	tutorialMessages[0].show()
	await acceptDirection
	tutorialMessages[0].hide()
	
	logic.alive = true
	tutorialMessages[1].show()
	await car.carMoved
	tutorialMessages[2].show()
	await acceptDirection
	tutorialMessages[1].hide()
	tutorialMessages[2].hide()
	while 1:
		tutorialMessages[3].show()
		for obstacle in obstacles.get_children():
			obstacle.paused = false
			obstacle.sent = false
		
		await logic.obsticleDied
		if logic.obsticleDiedID == 0: 
			tutorialMessages[3].hide()
			tutorialMessages[4].show()
			var i = 0
			for obstacle in obstacles.get_children():
				obstacle.position.y = initialObstacleY[i]
				obstacle.paused = true
				i += 1
			streetsSpeed = 0
			await acceptDirection
			tutorialMessages[4].hide()
			streetsSpeed = 1
			continue
		
		await logic.obsticleDied
		if logic.obsticleDiedID == 0: 
			tutorialMessages[3].hide()
			tutorialMessages[4].show()
			var i = 0
			for obstacle in obstacles.get_children():
				obstacle.position.y = initialObstacleY[i]
				obstacle.paused = true
				i += 1
			streetsSpeed = 0
			await acceptDirection
			tutorialMessages[4].hide()
			streetsSpeed = 1
			continue
		
		await logic.obsticleDied
		if logic.obsticleDiedID == 0: 
			tutorialMessages[3].hide()
			tutorialMessages[4].show()
			var i = 0
			for obstacle in obstacles.get_children():
				obstacle.position.y = initialObstacleY[i]
				obstacle.paused = true
				i += 1
			streetsSpeed = 0
			await acceptDirection
			tutorialMessages[4].hide()
			streetsSpeed = 1
			continue
		
		break
	tutorialMessages[3].hide()
	tutorialMessages[5].show()
	await get_tree().create_timer(1.5).timeout
	FadeTransitionSceneV2.blink(2.0,0.5,0.5)
	await get_tree().create_timer(1.3).timeout
	tutorialMessages[6].show()
	await acceptDirection
	_on_play_button_pressed()


func _on_tutorial_button_pressed() -> void:
	SFX.button_sfx()
	mainButtons.hide()
	levelSelector.hide()
	startTutorial()


func _on_play_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_settings_buton_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_leaderboard_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_credits_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_quit_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_tutorial_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_main_game_button_mouse_entered() -> void:
	SFX.hover_sfx()


func _on_quit_credits_mouse_entered() -> void:
	SFX.hover_sfx()
