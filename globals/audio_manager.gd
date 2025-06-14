# AudioManager is meant to be used as a godot autolaod script
# to manage sounds
# Use:
# AudioManager.register("alien_step", load("res://audio/sfx/alien_step.wav")
# AudioManager.register("wave_start", load("res://audio/sfx/wave_start.wave")
# AudioManager.play("wave_start") #-> sound plays

extends Node

var registered_audio_streams : Dictionary[String, AudioStreamPlayer2D] = {}

func register(key_name:String, audio:AudioStream, volume: float = 0.0, looping: bool = false ) -> void:
	#audio.has_lo
	var player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	player.stream = audio
	player.volume_db = volume
	registered_audio_streams[key_name] = player
	self.add_child(player)
	
	
# TODO: Remove sounds when unloading a scene, as needed
func unregister(key_name:String) -> void:
	pass
	
func stop(key_name: String) -> void:
	registered_audio_streams[key_name].stop()


# TODO: Check if stream exists
func play(key_name: String) -> void:
	print("volume for track: ", registered_audio_streams[key_name].volume_db)
	registered_audio_streams[key_name].play()
	
# TODO: Check if stream exists
# For direct control over stream playback
func player_for(key_name: String) -> AudioStreamPlayer2D:
	return registered_audio_streams[key_name]
