class_name Player
extends CharacterBody2D

enum Facing { UP, DOWN, LEFT, RIGHT }

signal jump_foward
signal got_home
@onready var move_detector_collision_shape : CollisionShape2D = $MoveDetector/CollisionShape2D


@export var speed : float;
@onready var sprite : Sprite2D = $Sprite2D

@onready var jumping : bool = false
@onready var facing : Facing = Facing.UP
@onready var direction : Vector2
@onready var target_position : Vector2
@onready var target_speed : int

@onready var entering_platform : Area2D
@onready var exiting_platform: Area2D
@onready var platform_speed : int = 0

@onready var frame_counter : int = 0

func _ready() -> void:
	AudioManager.register("jump", load("res://assets/audio/sfx/jump.mp3"), 5)
	AudioManager.register("death", load("res://assets/audio/sfx/death.mp3"), 5)

func _input(event : InputEvent) -> void:

	if jumping:
		return 
	if event is not InputEventKey:
		return
	
	target_position = Vector2(self.position)
	if Input.is_action_just_pressed("ui_up"):
		facing = Facing.UP
		target_position.y -= 32
		emit_signal("jump_foward")
	elif Input.is_action_just_pressed("ui_down"):
		facing = Facing.DOWN
		target_position.y += 32
		
	elif Input.is_action_just_pressed("ui_right"):
		facing = Facing.RIGHT
		target_position.x += 32
		
	elif Input.is_action_just_pressed("ui_left"):
		facing = Facing.LEFT
		target_position.x -= 32
	else:
		# NOT JUMPING
		return

	sprite.set_frame(1)
	
	
	if platform_speed !=0 && (facing == Facing.LEFT || facing == Facing.RIGHT):
		target_speed = platform_speed
	else:
		target_speed = 0
	
	#platform_speed = 0
	jumping = true
	AudioManager.play("jump")
	#move_timer.start()
	

	
func is_current_position_intersecting_hazards() -> bool:
	var on_hazard : bool = false
	var intersect_params : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	intersect_params.shape = move_detector_collision_shape.shape
	intersect_params.shape_rid = move_detector_collision_shape.shape.get_rid()
	intersect_params.transform = move_detector_collision_shape.global_transform
	
	intersect_params.collide_with_areas = true
	intersect_params.collision_mask = 10000010
	
	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var results : Array = space_state.intersect_shape(intersect_params)
		
	if results.size() > 0:
		for dict : Dictionary in results:
			#print(dict)
			if dict.collider.is_in_group("platform"):
				#print("on platform")
				platform_speed = dict.collider.get_parent().speed
				print("landed on platform: ", platform_speed)
			elif dict.collider.is_in_group("vehicles") || dict.collider.is_in_group("splash") :				
				on_hazard = true
	return on_hazard

func face_direction() -> void:
	match facing:
		Facing.UP:
			sprite.rotation = deg_to_rad(0)
		Facing.DOWN:
			sprite.rotation = deg_to_rad(180)
		Facing.RIGHT:
			sprite.rotation = deg_to_rad(90)
		Facing.LEFT:
			sprite.rotation = deg_to_rad(-90)

func move_player(delta : float) -> void:
	frame_counter += 1
	if ! jumping:
		velocity = Vector2(platform_speed, 0)
		target_speed = 0
	
		move_and_collide(velocity * delta)
		return
		
	if target_speed != 0:
		target_position.x += delta * target_speed
		
		
	direction = position.direction_to(target_position)
	var distance : float = position.distance_to(target_position);
	
	var speed_vec : Vector2 = Vector2(speed + abs(platform_speed), speed)
	
	var collision : KinematicCollision2D = move_and_collide(direction * speed_vec * delta)

	if collision :
		jumping = false
		target_speed = 0
		sprite.set_frame(0)
	if distance <= 2.0:
		position = target_position
	
	if (position - target_position).is_zero_approx():
		if is_current_position_intersecting_hazards():
			death()
		else:
			jumping = false
			target_speed = 0
			sprite.set_frame(0)


func _process(delta: float) -> void:
	face_direction()
	move_player(delta)


func death() -> void:
	AudioManager.play('death')
	reset()

func reset() -> void:
	jumping = false
	target_speed = 0
	sprite.set_frame(0)
	facing = Facing.UP
	position = Vector2(StateManager.start_position)
	target_position = position
	platform_speed = 0

func _on_area_2d_area_entered(area :Area2D) -> void:
	if area.is_in_group("vehicles") || area.is_in_group("splash") :
		if ! jumping:
			death()
	elif area.is_in_group("platform"):
		pass
		#player.
	else:
		emit_signal("got_home", area)
		reset()


func _on_move_detector_area_entered(area : Area2D) -> void:
	pass
	#if area.is_in_group('platform'):
		#entering_platform = area
		#platform_speed = area.get_parent().speed
		#print("setting platform speed to: %d" % platform_speed)


func _on_move_detector_area_exited(area : Area2D) -> void:
	pass
	#print("exiting move detector area")
	#if area.is_in_group('platform'):
		#if area == entering_platform:
			#entering_platform = null
			#platform_speed = 0
		#else:
			#entering_platform = area
			
		
