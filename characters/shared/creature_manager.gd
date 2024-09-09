extends Node

@export var Zombie : PackedScene
@export var spawn : Marker3D

@onready var path_targets: Node = $"../Path/PathTargets"
@onready var spawn_timer: Timer = $SpawnTimer


func _on_spawn_timer_timeout() -> void:
	var target = randi_range(0, path_targets.get_child_count() - 1)
	
	var creature = Zombie.instantiate()
	add_child(creature)
	creature.global_position = spawn.global_position
	
	if creature.has_method("find_path"):
		creature.find_path(path_targets.get_child(target).global_position)
	else:
		printerr("Creature did not have a 'find_path' method.")
