extends Control

@onready var v: VBoxContainer = $V
@onready var new_game: Button = $V/NewGame
@onready var load_game: Button = $V/LoadGame


func _ready() -> void:
	load_game.disabled = not Game.has_save()
	
	new_game.grab_focus()
	
	for button: Button in v.get_children():
		button.mouse_entered.connect(button.grab_focus)
	
	SoundManager.setup_ui_sounds(self)
	SoundManager.play_bgm(preload("res://assets/bgm/02 1 titles LOOP.mp3"))


func _on_new_game_pressed() -> void:
	Game.new_game()


func _on_load_game_pressed() -> void:
	Game.load_game()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
