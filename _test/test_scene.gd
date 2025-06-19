extends Node2D
@onready var button : Button = $Button
@onready var base_vehicle : Node = $BaseVehicle

@onready var rect : Rect2 = Rect2(Vector2(20, 20), Vector2(20,20))

@onready var draw_color : Color = Color.RED
@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	pass

func _draw() -> void:
	if rect:
		draw_rect(rect, draw_color, false, 3)

func _on_button_pressed() ->  void:
	
	
	draw_color = Color.GREEN
	queue_redraw()


func _on_h_slider_value_changed(value : float) -> void:
	progress_bar.value = value# Replace with function body.
