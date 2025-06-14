class_name Main
extends Control


func _on_play_pressed() -> void:
	SceneManager.load_scene("Game", self)
