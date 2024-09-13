extends StaticBody3D

"""
The goal of the player is to destroy the Corrupted's Hive.
The Hive can attack Grove units when they get within range.
"""

var health := 100

@onready var base_health = health


func _ready():
	pass


func _physics_process(delta: float):
	pass


func die():
	pass
