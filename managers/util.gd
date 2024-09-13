extends Node3D

var _camera : Camera3D


func _ready() -> void:
	await get_tree().physics_frame
	
	_camera = get_viewport().get_camera_3d()


func ray_from_mouse():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = _camera.project_ray_origin(get_viewport().get_mouse_position())
	query.to = query.from + _camera.project_ray_normal(get_viewport().get_mouse_position()) * 1000
	query.exclude = [self, _camera]
	var results = space.intersect_ray(query)
	
	return null if results.is_empty() else results["position"]


func get_world_node() -> Node:
	return get_node("/root/Main/Level")
