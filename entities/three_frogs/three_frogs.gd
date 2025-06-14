extends Node2D

@export var speed : int = 200
@onready var box : ReferenceRect = $ReferenceRect

func _process(_delta : float) -> void:
	var velocity : float = speed * _delta
	position += Vector2(velocity, 0)
	
func width() -> int :
	return box.size.x
