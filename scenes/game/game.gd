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


const white_car_scene : PackedScene = preload("res://entities/vehicles/WhiteCar.tscn")
@onready var score_label : Label = $Level/ScoreLabel
@onready var tick_counter : int = 0

const PLAYER_STARTING_POSITION : Vector2 = Vector2(370, 530)

@onready var player : Player = $Player
@onready var score : int = 0
@onready var pool_ids : Dictionary[int, ObjectPool]

func _ready() -> void:
	StateManager.start_position = PLAYER_STARTING_POSITION
	add_to_score(0)

func _process(_delta:float) -> void:
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
			two_frogs_node.position.x = 800

	for five_log_node : Node2D in five_logs_set.get_children():
		if five_log_node.position.x > 800 + (five_log_node.width() - 800):
			five_log_node.position.x = -five_log_node.width()
			
	for seven_logs_node : Node2D in seven_logs_set.get_children():
		if seven_logs_node.position.x > 800 + (seven_logs_node.width() - 800):
			seven_logs_node.position.x = -seven_logs_node.width()

func add_to_score(point_change: int) -> void:
	score += point_change
	score_label.text = "%d" % score

func _on_player_jump_foward() -> void:
	add_to_score(10)


func _on_player_got_home(home: Area2D) -> void:
	add_to_score(50)
	home.set_occupied()
		
