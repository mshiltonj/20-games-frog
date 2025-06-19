class_name Game
extends Node2D

@onready var hazards : Node = $Hazards
@onready var red_car_set : Node = $Level/RedCarsSet
@onready var bulldozer_set : Node = $Level/BulldozerSet
@onready var yellow_car_set : Node = $Level/YellowCarSet
@onready var white_truck_set : Node = $Level/WhiteTruckSet
@onready var white_car_set : Node = $Level/WhiteCarSet
@onready var t_turtle_set : Node = $"Level/3TurtleSet"
@onready var two_frogs_set : Node = $Level/TwoFrogsSet
@onready var three_logs_set : Node = $Level/ThreeLogsSet
@onready var five_logs_set : Node = $Level/FiveLogsSet
@onready var seven_logs_set : Node = $Level/SevenLogsSet
@onready var homes_set : Node = $Homes
@onready var pause_overlay : Node = $PauseOverlay
@onready var game_over_overlay : Node = $GameOverOverlay
@onready var level : int = 1
@onready var snake : Node = $Snake
@onready var pink_frog : PinkFrog = $PinkFrog
@onready var log_has_snake : bool = false
@onready var log_has_pink_frog : bool = false

@onready var add_snake_to_log : bool = false
@onready var add_pink_frog_to_log : bool = false
@onready var life_markers : Node2D = $Level/LifeMarkers

const white_car_scene : PackedScene = preload("res://entities/vehicles/WhiteCar.tscn")
const death_particles_scene : PackedScene = preload("res://entities/death_particles/DeathParticles.tscn")
@onready var score_label : Label = $Level/ScoreLabel
@onready var level_label : Label = $Level/LevelLabel
@onready var hi_score_label_value : Label = $Level/HiScoreLabelValue

@onready var tick_counter : int = 0

const PLAYER_STARTING_POSITION : Vector2 = Vector2(370, 530)

@onready var player : Player = $Player
@onready var score : int = 0
@onready var pool_ids : Dictionary[int, ObjectPool]

@onready var occupied_homes : int = 0

@onready var countdown_ticker : Timer = $Level/CountdownTimer
@onready var progress_bar : ProgressBar = $Level/ProgressBar
@onready var lives : int = 3

@onready var respawn_timer : Timer = $Level/RespawnTimer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player.connect("player_death", _on_player_death)
	StateManager.start_position = PLAYER_STARTING_POSITION
	AudioManager.register("soundtrack", load("res://assets/audio/music/8-bit-air-fight-158813.mp3"), -5, true)
	AudioManager.register("home", load("res://assets/audio/sfx/home.mp3"))
	AudioManager.register("success", load("res://assets/audio/sfx/success.wav"))
	AudioManager.register("tick_tock", load("res://assets/audio/sfx/tick_tock.mp3"), 7)
	AudioManager.play("soundtrack")
	add_to_score(0)
	level_label.text = "%d" % level
	reset_snake()
	countdown_ticker.connect("timeout", _on_countdown_ticker_timeout)
	countdown_ticker.start()
	set_high_score(StateManager.high_score)
	update_life_markers()
	
func pause_game() -> void:
	get_tree().paused = true
	pause_overlay.pause()
	
func update_life_markers() -> void:
	var count : int = 0
	for marker : Sprite2D in life_markers.get_children():
		count += 1
		marker.visible = count < lives

func _on_countdown_ticker_timeout() -> void:
	progress_bar.value -= 1
	
	if progress_bar.value > 10:
		progress_bar.get_theme_stylebox("fill").bg_color = Color.GREEN
	elif progress_bar.value <= 10 && progress_bar.value > 5:
		progress_bar.get_theme_stylebox("fill").bg_color = Color.YELLOW
	else:
		if is_equal_approx(5.0, progress_bar.value):
			AudioManager.play("tick_tock")
		progress_bar.get_theme_stylebox("fill").bg_color = Color.RED
		
	if progress_bar.value == 0:
		countdown_ticker.stop()
		player.death()

func shutdown() -> void:
	AudioManager.stop("soundtrack") 

func reset_pink_frog() -> void:
	pink_frog.position = Vector2(-100, -100)
	pink_frog.speed = 0
	log_has_pink_frog = false

func reset_snake() -> void:
	log_has_snake = false
	snake.position = Vector2(-100,-100)
	snake.speed = 0
	snake.platform_speed = 0
	snake.z_index = 100
	snake.log_node=null
	

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()
		return
	
	for red_cars_node : Node2D in red_car_set.get_children():
	#	print(red_cars_node.get_class())
		if red_cars_node.position.x < -red_cars_node.width():
			red_cars_node.position.x = 800
			
	for bulldozer_node : Node2D in bulldozer_set.get_children():
		if bulldozer_node.position.x > 800:
			bulldozer_node.position.x = -bulldozer_node.width()

	for yellow_car_node : Node2D in yellow_car_set.get_children():
		if yellow_car_node.position.x > 800:
			yellow_car_node.position.x = -yellow_car_node.width()

	for white_truck_node : Node2D in white_truck_set.get_children():
		var num : int = -white_truck_node.width()
		if white_truck_node.position.x < num:			
			white_truck_node.position.x = 800

	for white_car_node : Node2D in white_car_set.get_children():
		if white_car_node.position.x < -white_car_node.width():
			white_car_node.position.x = 800

	for three_turtle_node : Node2D in t_turtle_set.get_children():
		if three_turtle_node.position.x < -three_turtle_node.width():
			three_turtle_node.position.x = three_turtle_node.width()

	for three_log_node : Node2D in three_logs_set.get_children():
		if three_log_node.position.x > 800 + (three_log_node.width() - 800):
			three_log_node.position.x = -three_log_node.width()

	for two_frogs_node : Node2D in two_frogs_set.get_children():
		if two_frogs_node.position.x < -two_frogs_node.width():
			two_frogs_node.position.x = 800 + (two_frogs_node.width() - 800)

	for five_log_node : Node2D in five_logs_set.get_children():
		if five_log_node.position.x > 800 + (five_log_node.width() - 800):
			five_log_node.position.x = -five_log_node.width()
			
			if pink_frog.log_node && pink_frog.log_node == five_log_node:
				reset_pink_frog()
			if add_pink_frog_to_log && ! log_has_pink_frog:
				spawn_pink_frog_on_log(five_log_node)
			
	for seven_logs_node : Node2D in seven_logs_set.get_children():
		if seven_logs_node.position.x > 800 + (seven_logs_node.width() - 800):
			seven_logs_node.position.x = -seven_logs_node.width()
			
			if snake.log_node && snake.log_node == seven_logs_node:
				reset_snake()
				
			if add_snake_to_log && ! log_has_snake:
				spawn_snake_on_log(seven_logs_node)

func add_to_score(point_change: int) -> void:
	score += point_change
	score_label.text = "%d" % score
	if score > StateManager.high_score:
		set_high_score(score)
	
func set_high_score(high_score : int) -> void:
	hi_score_label_value.text = "%d" % high_score
	StateManager.high_score = high_score

func _on_player_jump_foward() -> void:
	add_to_score(10)

func game_over() -> void:
	#get_tree().paused = true
	countdown_ticker.stop()
	game_over_overlay.show_overlay()

func _on_player_death(player_position : Vector2) -> void:
	lives -= 1
	var death_particles : GPUParticles2D = death_particles_scene.instantiate()
	death_particles.position = Vector2(player_position)
	
	if death_particles.position.x < 8:
		death_particles.position.x = 8
	if death_particles.position.x > 792:
		death_particles.position.x = 792
		
		
	death_particles.one_shot = true
	death_particles.z_index = 10
	death_particles.connect("finished", func() -> void: death_particles.queue_free() )
	add_child(death_particles)
	respawn_timer.start()
	
func spawn_pink_frog_on_log(log_node: Node2D) -> void:
	log_has_pink_frog = true
	pink_frog.scale.x = 1;
	pink_frog.position = Vector2(log_node.position)
	pink_frog.position.x += 25
	pink_frog.position.y += 15
	pink_frog.speed = log_node.speed
	pink_frog.log_node=log_node
	pink_frog.z_index = 1

func spawn_snake_on_hedge() -> void:
	snake.speed = 55
	snake.position = Vector2(-52, 336)

func spawn_snake_on_log(log_node: Node) -> void:
	log_has_snake = true
	snake.scale.x = 1;
	snake.position = Vector2(log_node.position)
	snake.position.x += 25
	snake.position.y += 15
	snake.speed = 55
	snake.platform_speed = log_node.speed
	snake.log_node=log_node

func spawn_snake() -> void:
	if level % 2 ==  0:
		add_snake_to_log = false
		reset_snake()
		spawn_snake_on_hedge()
	else:
		add_snake_to_log = true


func _on_player_got_home(home: Area2D) -> void:
	add_to_score(50)
	if player.pink_frog.visible:
		add_to_score(200)
	add_to_score(int(progress_bar.value * 10))
	occupied_homes += 1
	if occupied_homes == 6:
		for home_node : Node in homes_set.get_children():
			home_node.reset()
		add_pink_frog_to_log = true
		occupied_homes = 0
		add_to_score(1000)
		level += 1
		level_label.text = "%d" % level 
		AudioManager.play("success")
		spawn_snake()
		add_pink_frog_to_log = true
	else:
		AudioManager.play("home")
		home.set_occupied()
		

func _on_player_got_pink_frog() -> void:
	add_pink_frog_to_log = false
	reset_pink_frog()


func _on_player_spawn() -> void:
	progress_bar.get_theme_stylebox("fill").bg_color = Color.GREEN
	progress_bar.value = progress_bar.max_value
	countdown_ticker.start()
	
func _on_respawn_timer_timeout() -> void:
	if lives <=0:
		game_over()
	else:
		update_life_markers()
		player.reset()
