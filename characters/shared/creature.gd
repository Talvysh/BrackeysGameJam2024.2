class_name Creature extends CharacterBody3D

@export var move_speed := 2.0
@export var current_health := 20
@export var max_health := 20
@export var attack_damage := 1
@export var attack_range := 1.0
@export var display_name := "Name"
@export var description := "A short description for the character."

var original_mat_albedo : Color

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var selection_size: CollisionShape3D = $SelectionSize


func _ready() -> void:
	var mat : StandardMaterial3D = mesh_instance_3d.get_active_material(0)
	original_mat_albedo = mat.albedo_color
	mesh_instance_3d.material_override = mesh_instance_3d.get_active_material(0).duplicate()


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


func get_aabb() -> AABB:
	return AABB(global_position, selection_size.shape.size)


func selected() -> void:
	mesh_instance_3d.material_override.albedo_color = original_mat_albedo.lightened(0.5)


func unselected() -> void:
	mesh_instance_3d.material_override.albedo_color = original_mat_albedo


func move(pos) -> void:
	find_path(pos)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.emit_signal("unit_selected", self)
