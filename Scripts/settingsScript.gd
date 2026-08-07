extends Panel

@onready var settingsPanel: Panel = $"."
var masterBusID;
var musicBusID;
var SFXbusID;
@onready var masterSlider: HSlider = $VBoxContainer/masterSlider/HSlider
@onready var musicSlider: HSlider = $VBoxContainer/musicSlider/HSlider
@onready var SFXslider: HSlider = $VBoxContainer/SFXslider/HSlider
@onready var checkButton: CheckButton = $VBoxContainer/CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	masterBusID = AudioServer.get_bus_index("Master")
	musicBusID = AudioServer.get_bus_index("Music")
	SFXbusID = AudioServer.get_bus_index("SFX")
	
	checkButton.button_pressed = Global.config.get_value("settings", "fullscreen")
	masterSlider.value = Global.config.get_value("settings", "master")
	musicSlider.value = Global.config.get_value("settings", "music")
	SFXslider.value = Global.config.get_value("settings", "sfx")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_quit_settings_pressed() -> void:
	Global.closedSettings = true
	settingsPanel.hide()


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(masterBusID, linear_to_db(value))
	Global.config.set_value("settings", "master", value)
	Global.config.save(Global.settingsFilePath)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(musicBusID, linear_to_db(value))
	Global.config.set_value("settings", "music", value)
	Global.config.save(Global.settingsFilePath)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFXbusID, linear_to_db(value))
	Global.config.set_value("settings", "sfx", value)
	Global.config.save(Global.settingsFilePath)


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Global.config.set_value("settings", "fullscreen", toggled_on)
	Global.config.save(Global.settingsFilePath)
	
	
