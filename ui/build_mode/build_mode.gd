extends PanelContainer

const StructureButton = preload("res://ui/build_mode/structure_button.tscn")

@export var structures : Array[StructureData]

var _camera : Camera3D
var _placement_data : StructureData

@onready var structures_container: GridContainer = $Structures
@onready var placement_ghost: Node3D = $PlacementGhost
@onready var placement_ghost_mesh: MeshInstance3D = $PlacementGhost/MeshInstance3D


func _ready() -> void:
	_camera = get_viewport().get_camera_3d()
	
	SignalBus.connect("structure_button_pressed", _on_structure_button_pressed)
	
	for s in structures:
		print(s.display_name)
		var node = StructureButton.instantiate()
		node.set_structure_data(s)
		structures_container.add_child(node)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("build"):
		visible = !visible
		
		GameManager.action_state = GameManager.ActionState.BUILDING if visible else GameManager.ActionState.SELECTING

	if placement_ghost.visible:
		var pos = Util.ray_from_mouse()
		if pos:
			pos = pos.snappedf(1.0)
			placement_ghost.global_position = pos
		
		if Input.is_action_just_pressed("ui_cancel"):
			placement_ghost.visible = false
				


func _unhandled_input(event: InputEvent) -> void:
	if not placement_ghost.visible:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				var node = _placement_data.scene.instantiate()
				Util.get_world_node().add_child(node)
				node.global_position = placement_ghost.global_position
				SignalBus.emit_signal("nav_updated")


func _on_structure_button_pressed(structure_data : StructureData) -> void:
	_placement_data = structure_data
	placement_ghost_mesh.mesh = structure_data.placement_mesh
	placement_ghost.visible = true
