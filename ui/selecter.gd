extends Control

const SELECTION_TOP := 20.0
const SELECTION_BOTTOM := 20.0

var dragging := false
var _begin_drag : Vector2
var _end_drag : Vector2
var _camera : Camera3D
var _check_drag := false
var _selection_rect : AABB
var selected_units : Array[Unit]

@onready var debug_dragging: Label = $"../VBoxContainer/Debug/Dragging"
@onready var debug_drag_start: Label = $"../VBoxContainer/Debug/DragStart"
@onready var debug_drag_end: Label = $"../VBoxContainer/Debug/DragEnd"
@onready var debug_camera_position : Label = $"../VBoxContainer/CameraPosition"


func _ready() -> void:
	_camera = get_viewport().get_camera_3d()
	SignalBus.connect("unit_selected", _on_unit_selected)


func _physics_process(delta: float) -> void:
	debug_dragging.text = "Dragging: %s" % dragging
	
	# TODO: Move this to ui.gd
	debug_camera_position.text = "Camera Position: %s" % _camera.global_position
	
	if dragging:		
		debug_drag_start.text = "Drag Start: %s" % _begin_drag
		debug_drag_end.text = "Drag End: %s" % _end_drag
	
	# No need to check if we are in building mode
	if GameManager.action_state == GameManager.ActionState.BUILDING:
		_deselect_units()
		return
	
	if _check_drag:
		_get_units_in_selection()
		_check_drag = false
	
	if Input.is_action_pressed("move_units"):
		if not selected_units.is_empty():
			for unit in selected_units:
				var pos = Util.ray_from_mouse()
				print(pos)
				unit.move(pos)


func _process(delta: float) -> void:
	# No need to check if we are in building mode
	if GameManager.action_state == GameManager.ActionState.BUILDING:
		return

	queue_redraw()


func _draw() -> void:
	# No need to check if we are in building mode
	if GameManager.action_state == GameManager.ActionState.BUILDING:
		return
	
	if dragging:
		var w = _end_drag.x - _begin_drag.x
		var h = _end_drag.y - _begin_drag.y
		draw_rect(Rect2(_begin_drag.x, _begin_drag.y, w, h), Color.WHITE_SMOKE, false)


func _unhandled_input(event: InputEvent) -> void:
	# No need to check if we are in building mode
	if GameManager.action_state == GameManager.ActionState.BUILDING:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		_deselect_units()
	
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
	if _begin_drag.distance_to(_end_drag) < 10.0:
		return
	
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
	
	_deselect_units()
	
	for unit in get_tree().get_nodes_in_group("grove_unit"):
		var unit_viewport_pos = _camera.unproject_position(unit.global_position)
		print("unit viewport position: %s" % unit_viewport_pos)
		if rect.has_point(unit_viewport_pos):
			selected_units.append(unit)
			unit.selected()


func _on_unit_selected(unit : Unit) -> void:
	_deselect_units()
	selected_units.append(unit)


func _deselect_units() -> void:
	if selected_units.is_empty():
		return
	
	for u in selected_units:
		u.unselected()
	
	selected_units = []
