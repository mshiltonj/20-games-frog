class_name Snake
extends Area2D

@export var speed : int = 55
@export var platform_speed : int = 0
@export var log_node : Node = null

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast : RayCast2D = $RayCast2D


func _ready() -> void:
	sprite.play('default')


func _process(delta:float) -> void:
	var velocity : float = (speed + platform_speed )* delta
	position.x += velocity
	
	if raycast.is_colliding():
		self.scale.x *= -1
		self.speed *= -1
