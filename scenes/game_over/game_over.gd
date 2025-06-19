extends Control

@export var game_scene : Node
@onready var high_score_label : Label = $CenterContainer/VBoxContainer/HighScoreLabel
@onready var final_score_label : Label = $CenterContainer/VBoxContainer/FinalScoreLabel

func _ready() -> void:
	AudioManager.register("game_over", load("res://assets/audio/sfx/game_over.wav"), 10.0)

func _on_main_menu_button_pressed() -> void:
	game_scene.shutdown()
	get_tree().paused = false
	SceneManager.load_scene("Main", game_scene)

func show_overlay() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.play("game_over")
	final_score_label.text = "Final Score: %d" % game_scene.score
	if game_scene.score > StateManager.previous_high_score:
		high_score_label.visible = true
		StateManager.previous_high_score = game_scene.score
	else:
		high_score_label.visible = false
	show()


func _on_play_again_button_pressed() -> void:
	game_scene.shutdown()	
	SceneManager.load_scene("Game", game_scene)
