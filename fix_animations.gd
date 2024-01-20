@tool
extends EditorScript


func _run() -> void:
	fix_scene("res://enemies/boar.tscn")
	fix_scene("res://player.tscn")


func fix_scene(path: String) -> void:
	EditorInterface.open_scene_from_path(path)
	
	for node in EditorInterface.get_edited_scene_root().get_children():
		if node is AnimationPlayer:
			fix_animation_player(node)
	
	EditorInterface.save_scene()


func fix_animation_player(animation_player: AnimationPlayer) -> void:
	if not animation_player.has_animation("RESET"):
		return
	var reset := animation_player.get_animation("RESET")
	
	for animation_name in animation_player.get_animation_list():
		if animation_name == "RESET":
			continue
		
		var animation := animation_player.get_animation(animation_name)
		fix_animation(animation, reset)


func fix_animation(animation: Animation, reset: Animation) -> void:
	for src in reset.get_track_count():
		var type := reset.track_get_type(src)
		var path := reset.track_get_path(src)
		
		if type != Animation.TYPE_VALUE:
			continue
		
		var dst := find_track(animation, type, path)
		if dst == -1:
			continue
		
		animation.value_track_set_update_mode(dst, reset.value_track_get_update_mode(src))


func find_track(animation: Animation, type: Animation.TrackType, path: NodePath) -> int:
	for i in animation.get_track_count():
		if animation.track_get_type(i) != type:
			continue
		if animation.track_get_path(i) != path:
			continue
		return i
	return -1
