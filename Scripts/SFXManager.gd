extends Node
class_name SFXManager

var button_sound: AudioStream = preload("res://Assets/SFX/Button.wav")
var crash_sound: AudioStream = preload("res://Assets/SFX/Crash.wav")
var hover_sound: AudioStream = preload("res://Assets/SFX/Hover.wav")
var loser_sound: AudioStream = preload("res://Assets/SFX/Loser.wav")
var start_sound: AudioStream = preload("res://Assets/SFX/Loser.wav")
var vroom_sound: AudioStream = preload("res://Assets/SFX/Vroom.wav")
var switch_sound: AudioStream = preload("res://Assets/SFX/Switch.wav")
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
		p.bus = "SFX"

		get_tree().current_scene.add_child(p)

		p.play()
		await p.finished
		if is_instance_valid(p):
			p.queue_free()
	else:
		get_tree().current_scene.add_child(player)
		if "play" in player:
			player.bus = "SFX"
			player.play()



func vroom_sfx() -> void:
	var pitch := randf_range(0.9, 1.1)
	await play_sfx(vroom_sound, 1.0, pitch)

func button_sfx() -> void:
	var pitch := randf_range(0.9, 1.1)
	await play_sfx(button_sound, 1.0, pitch)

func crash_sfx() -> void:
	var pitch := randf_range(0.8, 1.2)
	await play_sfx(crash_sound, 0.8, pitch)
func hover_sfx() -> void:
	var pitch := randf_range(.9, 1.1)
	await play_sfx(hover_sound, .8, pitch)
func lose_sfx() -> void:
	var pitch := randf_range(0.8, 1.2)
	await play_sfx(loser_sound, .8, pitch)
func start_sfx() -> void:
	var pitch := randf_range(0.8, 1.2)
	await play_sfx(loser_sound, .8, pitch)
func switch_sfx() -> void:
	var pitch := randf_range(0.8, 1.2)
	await play_sfx(switch_sound, 1, pitch)
