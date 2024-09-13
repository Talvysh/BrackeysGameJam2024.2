extends Camera3D

@export var move_speed := 20.0
@export var sprint_speed := 40.0


func _physics_process(delta: float) -> void:
	var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement := Vector3.ZERO
	
	if Input.is_action_pressed("sprint"):
		movement.x = move_input.x * sprint_speed * delta
		movement.z = move_input.y * sprint_speed * delta
	else:
		movement.x = move_input.x * move_speed * delta
		movement.z = move_input.y * move_speed * delta
	
	global_position += movement
	
	if Input.is_action_pressed("move_up"):
		global_position.y += move_speed * delta
	elif Input.is_action_pressed("move_down"):
		global_position.y -= move_speed * delta
