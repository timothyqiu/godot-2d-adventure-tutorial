extends Control

@onready var resume: Button = $V/Actions/H/Resume


func _ready() -> void:
	hide()
	SoundManager.setup_ui_sounds(self)
	
	visibility_changed.connect(func ():
		get_tree().paused = visible
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		hide()
		get_window().set_input_as_handled()


func show_pause() -> void:
	show()
	resume.grab_focus()


func _on_resume_pressed() -> void:
	hide()


func _on_quit_pressed() -> void:
	Game.back_to_title()
