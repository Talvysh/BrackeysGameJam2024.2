extends Camera3D

@export var move_speed := 10.0


func _physics_process(delta: float) -> void:
	var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	global_position.x += movement.x * move_speed * delta
	global_position.z += movement.y * move_speed * delta
