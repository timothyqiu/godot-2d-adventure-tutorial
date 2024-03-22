extends Camera2D

@export var recovery_speed := 16.0

var strength := 0.0


func _ready() -> void:
	Game.camera_should_shake.connect(func (amount: float):
		strength += amount
	)


func _process(delta: float) -> void:
	offset = Vector2(
		randf_range(-strength, +strength),
		randf_range(-strength, +strength)
	)
	strength = move_toward(strength, 0, recovery_speed * delta)
