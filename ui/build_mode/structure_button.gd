extends TextureButton

var structure_data : StructureData

@onready var structure_details: PanelContainer = $StructureDetails
@onready var display_name: Label = $StructureDetails/VBoxContainer/DisplayName
@onready var description: Label = $StructureDetails/VBoxContainer/Description


func _ready() -> void:
	display_name.text = structure_data.display_name
	description.text = structure_data.description


func set_structure_data(_data : StructureData) -> void:
	structure_data = _data


func _on_mouse_entered() -> void:
	structure_details.visible = true


func _on_mouse_exited() -> void:
	structure_details.visible = false


func _on_pressed() -> void:
	SignalBus.emit_signal("structure_button_pressed", structure_data)
