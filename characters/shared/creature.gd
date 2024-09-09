class_name Creature extends CharacterBody3D

@export var move_speed := 1.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/3d/default_gravity")
	
	if nav_agent.is_navigation_finished():
		return
	
	var dir = global_position.direction_to(nav_agent.get_next_path_position())
	var movement = dir * move_speed
	
	velocity = movement
	move_and_slide()
	

func find_path(_target) -> void:	
	nav_agent.target_position = _target


func path_end() -> void:
	queue_free()
	print("Creature made it to the end")
