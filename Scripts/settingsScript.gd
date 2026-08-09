extends CanvasLayer

var masterBusID;
var musicBusID;
var SFXbusID;
@onready var masterSlider: HSlider = $settingsPanel/VBoxContainer/masterSlider/HSlider
@onready var musicSlider: HSlider = $settingsPanel/VBoxContainer/musicSlider/HSlider
@onready var SFXslider: HSlider = $settingsPanel/VBoxContainer/SFXslider/HSlider



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	masterBusID = AudioServer.get_bus_index("Master")
	musicBusID = AudioServer.get_bus_index("Music")
	SFXbusID = AudioServer.get_bus_index("SFX")
	
	masterSlider.value = Global.config.get_value("settings", "master")
	musicSlider.value = Global.config.get_value("settings", "music")
	SFXslider.value = Global.config.get_value("settings", "sfx")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_quit_settings_pressed() -> void:
	SFX.button_sfx()
	Global.closedSettings = true
	print("hide settings")
	hide()


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


func _on_quit_settings_mouse_entered() -> void:
	SFX.hover_sfx()
