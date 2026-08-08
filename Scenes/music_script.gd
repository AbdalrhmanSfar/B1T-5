extends Node

@onready var IntroPlayer: AudioStreamPlayer = $Intro
@onready var LoopPlayer: AudioStreamPlayer = $Loop

@export var intro_stream: AudioStream
@export var loop_stream: AudioStream

func _ready() -> void:
	IntroPlayer.stream = intro_stream
	LoopPlayer.stream = loop_stream
	print("music ready")
	IntroPlayer.finished.connect(_on_intro_finished)
	IntroPlayer.play()

func _on_intro_finished() -> void:
	LoopPlayer.play()
