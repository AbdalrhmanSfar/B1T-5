extends Node

var closedSettings: bool = false
var config = ConfigFile.new()
const settingsFilePath = "user://settings.ini"
var playerName
var highScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(settingsFilePath):
		config.set_value("settings", "master", 1.0)
		config.set_value("settings", "music", 1.0)
		config.set_value("settings", "sfx", 1.0)
		config.set_value("settings", "fullscreen", false)
		config.set_value("settings", "name", "a")
		config.set_value("others", "highScore", 0)
		config.save(settingsFilePath)
	else: 
		config.load(settingsFilePath)
		playerName = config.get_value("settings", "name")
	
	highScore = config.get_value("others", "highScore")
	
	# leaderboard initialiser
	SilentWolf.configure({
	"api_key": "ZEWwxcec4E101UyytReSE74g7Q8tIyXD3E4qlXBr",
	"game_id": "b1tjamcargame",
	"log_level": 1
	})
	SilentWolf.configure_scores({
	"open_scene_on_close": "res://Scenes/mainMenuScene.tscn"
	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
