extends Area2D

@export var speed : int = 200
@onready var box : ReferenceRect = $Box

func _process(_delta : float) -> void:
	var velocity : float = speed * _delta * 0.75
	position += Vector2(velocity, 0)
	
func width() -> int :
	return box.size.x
