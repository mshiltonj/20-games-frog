extends Area2D

@onready var occupied : bool = false
@onready var home_in_use : StaticBody2D = $HomeInUse
@onready var occupied_sprite : Sprite2D = $OccupiedSprite
@onready var home_collision_shape : CollisionShape2D = $HomeInUse/CollisionShape2D

func _ready() -> void:
	reset()
	
func set_occupied() -> void:
	occupied = true
	set_collision_layer_value(2, false)
	home_in_use.set_collision_layer_value(2, true)
	occupied_sprite.visible = true
	

func reset() -> void:
	occupied_sprite.visible = false
	occupied = false
	set_collision_layer_value(2, true)
	home_in_use.set_collision_layer_value(2, false)
