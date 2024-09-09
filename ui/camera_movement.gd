extends Camera3D

@export var move_speed := 10.0


func _physics_process(delta: float) -> void:
	var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	global_position.x += movement.x * move_speed * delta
	global_position.z += movement.y * move_speed * delta
	
	if Input.is_action_pressed("move_up"):
		global_position.y += move_speed * delta
	elif Input.is_action_pressed("move_down"):
		global_position.y -= move_speed * delta
