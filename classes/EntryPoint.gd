class_name EntryPoint
extends Marker2D

@export var direction := Player.Direction.RIGHT


func _ready() -> void:
	add_to_group("entry_points")
