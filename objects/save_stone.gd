extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func interact() -> void:
	super()
	
	animation_player.play("activated")
	Game.save_game()
