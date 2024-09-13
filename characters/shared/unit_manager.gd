extends Node

@export var corrupted : Array[PackedScene]
@export var corrupted_spawn : Node3D
@export var grove_spawn : Node3D
@export var path : NavigationRegion3D

func _on_spawn_timer_timeout() -> void:
	var node = corrupted.pick_random().instantiate()
	path.add_child(node)
	node.global_position = corrupted_spawn.global_position
	var rand_offset = randf_range(0.0, 30.0)
	node.move(grove_spawn.global_position + Vector3(rand_offset, 0.0, 0.0))
