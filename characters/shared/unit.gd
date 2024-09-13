class_name Unit extends CharacterBody3D

""" STATS """

@export_category("Stats")

@export var move_speed := 2.0  # Character can be de/buffed
@onready var original_move_speed = move_speed

@export var health := { "current" : 10, "original" : 10 }

@export var damage := 1
@onready var original_damage = damage

@export var range := 1.0
@onready var original_range = range

@export_category("Display")

@export var display_name := "Name"
@export var description := "A short description for the character."

""" PATHING """

var target_position : Vector3
var target_unit : Unit
var path : Path3D

enum State { FOLLOWING_PATH, CHASING, ATTACKING }
var state : State


func _ready():
	pass
	

func _physics_process(dt: float):
	if state == State.FOLLOWING_PATH:
		_process_path()
		_move(dt)
	
	elif state == State.CHASING:
		if target_unit != null:
			if global_position.distance_to(target_unit.global_position) < 1.0:
				state = State.ATTACKING
			else:
				_move(dt)
		else:
			state == State.FOLLOWING_PATH

	elif state == State.ATTACKING:
		if target_unit != null:
			if global_position.distance_to(target_unit.global_position) > 1.0:
				state = State.CHASING
			else:
				_attack()
		else:
			state = State.FOLLOWING_PATH


""" NAVIGATION """


func _process_path():
	target_position = path.curve.get_closest_point(global_position)


func _move(dt : float):
	pass


func _attack():
	pass
