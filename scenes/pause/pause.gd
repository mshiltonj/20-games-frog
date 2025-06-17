extends Control

@export var game_scene : Node;
@onready var load_wait_timer : Timer = $LoadWaitTimer
@onready var loaded_and_ready : bool = false

func _ready() -> void:
	load_wait_timer.timeout.connect(func() -> void: 
		loaded_and_ready = true
	)

func _on_quit_pressed() -> void:
	get_tree().paused = false
	game_scene.shutdown()
	SceneManager.load_scene("Main", game_scene)


func pause() -> void:
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	loaded_and_ready = false
	load_wait_timer.start()

func resume() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	self.visible=false

func _process(_delta:float) -> void:
	if ! loaded_and_ready:
		return
		
	if visible && Input.is_action_just_pressed("pause"):
		resume()

func _on_return_pressed() -> void:
	resume()
