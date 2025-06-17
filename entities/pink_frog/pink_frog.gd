class_name PinkFrog
extends Area2D

@onready var speed : int = 0
@export var log_node : Node = null

func _process(delta:float) -> void:
	var x_velocity : float = speed * delta
	position.x += x_velocity
