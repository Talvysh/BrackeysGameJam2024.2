class_name Plot extends Area3D

var mat : StandardMaterial3D
var original_mat_color : Color

var _selected := false
var _camera : Camera3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var plot_popup: PanelContainer = $PlotPopup


func _ready() -> void:
	mesh.material_override = mesh.get_active_material(0).duplicate()
	mat = mesh.material_override
	original_mat_color = mat.albedo_color
	_camera = get_viewport().get_camera_3d()


func _physics_process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	mat.albedo_color = mat.albedo_color.lightened(0.5)
	plot_popup.global_position = _camera.unproject_position(global_position)
	plot_popup.visible = true


func _on_mouse_exited() -> void:
	mat.albedo_color = original_mat_color
	plot_popup.visible = false


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalBus.emit_signal("plot_selected", self)
