class_name Main
extends Control
@onready var quit_button : Button = $CenterContainer/VBoxContainer/MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	if OS.get_name() != 'Web':
		quit_button.visible = true

func _on_play_pressed() -> void:
	SceneManager.load_scene("Game", self)


func _on_credits_pressed() -> void:
	SceneManager.load_scene("Credits", self)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_how_to_pressed() -> void:
	SceneManager.load_scene("HowTo", self)
