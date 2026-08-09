extends Node
class_name SFXManager

var button_sound: AudioStream = preload("res://Assets/SFX/Button.wav")
var crash_sound: AudioStream = preload("res://Assets/SFX/Crash.wav")
var hover_sound: AudioStream = preload("res://Assets/SFX/Hover.wav")
var sfx_player_scene: PackedScene = preload("res://Scenes/SFXPlayer.tscn")

@export var default_volume_linear: float = 1.0 
@export var default_pitch: float = 1.0

func _ready() -> void:
	randomize()

func _linear_to_db(linear: float) -> float:
	if linear <= 0.0001:
		return -80.0
	return 20.0 * (log(linear) / log(10.0))


func play_sfx(clip: AudioStream, volume_linear: float = -1.0, pitch: float = 1.0) -> void:
	if clip == null or sfx_player_scene == null:
		return
	var player = sfx_player_scene.instantiate()
	if player is AudioStreamPlayer:
		var p := player as AudioStreamPlayer
		p.stream = clip
		p.volume_db = _linear_to_db(default_volume_linear if volume_linear < 0.0 else volume_linear)
		p.pitch_scale = pitch
	get_tree().current_scene.add_child(player)

	if "play" in player:
		player.play()
	var length := clip.get_length()
	if length > 0.0:
		await get_tree().create_timer(length + 0.05).timeout
	else:
		await get_tree().create_timer(1.0).timeout

	player.queue_free()


func button_sfx() -> void:
	var pitch := randf_range(0.9, 1.1)
	play_sfx(button_sound, 1.0, pitch)

func interact_sfx() -> void:
	var pitch := randf_range(0.8, 1.2)
	play_sfx(crash_sound, 0.8, pitch)
func hover_sfx() -> void:
	var pitch := randf_range(.9, 1.1)
	play_sfx(hover_sound, .8, pitch)
