extends Control

const SELECTION_TOP := 20.0
const SELECTION_BOTTOM := 20.0

var dragging := false
var _begin_drag : Vector2
var _end_drag : Vector2
var _camera : Camera3D
var _check_drag := false
var _selection_rect : AABB
var selected_units : Array[Creature]

@onready var debug_dragging: Label = $"../Debug/Dragging"
@onready var debug_drag_start: Label = $"../Debug/DragStart"
@onready var debug_drag_end: Label = $"../Debug/DragEnd"
@onready var test_mesh: MeshInstance3D = $TestMesh


func _ready() -> void:
	_camera = get_viewport().get_camera_3d()
	SignalBus.connect("unit_selected", _on_unit_selected)


func _physics_process(delta: float) -> void:
	debug_dragging.text = "Dragging: %s" % dragging
	
	if dragging:		
		debug_drag_start.text = "Drag Start: %s" % _begin_drag
		debug_drag_end.text = "Drag End: %s" % _end_drag
	
	if _check_drag:
		_get_units_in_selection()
		_check_drag = false
	
	if Input.is_action_just_pressed("move_units"):
		if selected_units.is_empty():
			return
		else:
			for unit in selected_units:
				var pos = _raycast_from_mouse()
				print(pos)
				unit.move(pos)


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if dragging:
		var w = _end_drag.x - _begin_drag.x
		var h = _end_drag.y - _begin_drag.y
		draw_rect(Rect2(_begin_drag.x, _begin_drag.y, w, h), Color.WHITE_SMOKE, false)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		dragging = false
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			_begin_drag = get_global_mouse_position()
			_end_drag = _begin_drag

		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			dragging = false
			_end_drag = get_global_mouse_position()
			_check_drag = true
	
	if event is InputEventMouseMotion:
		if dragging:
			_end_drag = get_global_mouse_position()


func _get_units_in_selection() -> void:
	var start = Vector2.ZERO
	var end = Vector2.ZERO
	var temp_x = 0.0
	var temp_y = 0.0
	
	start.x = _begin_drag.x if _begin_drag.x < _end_drag.x else _end_drag.x
	start.y = _begin_drag.y if _begin_drag.y < _end_drag.y else _end_drag.y
	
	end.x = _begin_drag.x if _begin_drag.x > _end_drag.x else _end_drag.x
	end.y = _begin_drag.y if _begin_drag.y > _end_drag.y else _end_drag.y

	var size = Vector2.ZERO
	size.x = clampf(end.x - start.x, 1.0, 1000.0)
	size.y = clampf(end.y - start.y, 1.0, 1000.0)
	
	var rect = Rect2(start, size)
	print(rect)
	
	selected_units = []
	
	for unit in get_tree().get_nodes_in_group("grove_unit"):
		var unit_viewport_pos = _camera.unproject_position(unit.global_position)
		print("unit viewport position: %s" % unit_viewport_pos)
		if rect.has_point(unit_viewport_pos):
			selected_units.append(unit)
			unit.selected()
		else:
			unit.unselected()

func _raycast_from_mouse() -> Vector3:
	var space = _camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = _camera.project_ray_origin(get_global_mouse_position())
	query.to = query.from + _camera.project_ray_normal(get_global_mouse_position()) * 1000
	query.exclude = [self, _camera]
	var results = space.intersect_ray(query)
	
	if results:
		return results["position"]
	else:
		return Vector3.ZERO


func _on_unit_selected(unit : Creature) -> void:
	selected_units = []
	selected_units.append(unit)
