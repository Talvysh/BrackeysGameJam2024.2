extends Node3D

@export var BasicTower : PackedScene

var _building := false
var _tower_ghost : Tower
var _camera : Camera3D


func _ready() -> void:
	_camera = get_viewport().get_camera_3d()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("build"):
		_building = !_building
		
		if _building:
			_tower_ghost = BasicTower.instantiate()
			_tower_ghost.global_position = _camera.project_position(get_viewport().get_mouse_position(), 10)
			add_child(_tower_ghost)
		elif _tower_ghost != null:
			_tower_ghost.queue_free()
	
	if _building:
		_tower_ghost.global_position = _camera.project_position(get_viewport().get_mouse_position(), 10)
