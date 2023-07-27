@tool
extends ConfirmationDialog

var player: AnimationPlayer
var undo_redo: EditorUndoRedoManager
var translator
var new_tracks: Dictionary

@onready var tree: Tree = $Tree


func _ready() -> void:
	get_ok_button().pressed.connect(_on_ok_pressed)
	
	if not player or not player.has_animation(&"RESET"):
		return
	
	var reset := player.get_animation(&"RESET")
	var root := tree.create_item()
	
	for animation_name in player.get_animation_list():
		var animation := player.get_animation(animation_name)
		if animation == reset:
			continue
		
		var item := root.create_child()
		item.set_text(0, animation_name)
		
		var tracks: Array[Dictionary] = []
		
		for i in reset.get_track_count():
			if reset.track_get_key_count(i) == 0:
				continue
			
			var path := reset.track_get_path(i)
			var type := reset.track_get_type(i)
			var key_transition := reset.track_get_key_transition(i, 0)
			var key_time := reset.track_get_key_time(i, 0)
			var key_value = reset.track_get_key_value(i, 0)
		
			if not has_track(animation, type, path):
				tracks.push_back({
					type=type,
					path=path,
					key_transition=key_transition,
					key_time=key_time,
					key_value=key_value,
				})
		
		if tracks:
			for track in tracks:
				var subitem := item.create_child()
				subitem.set_text(0, translator.xlate(&"Copy from RESET"))
				subitem.set_text(1, track.path)
			new_tracks[animation_name] = tracks
		else:
			var subitem := item.create_child()
			subitem.set_text(0, translator.xlate(&"No action required"))


func setup(player: AnimationPlayer, undo_redo: EditorUndoRedoManager, translator) -> void:
	self.player = player
	self.translator = translator
	self.undo_redo = undo_redo
	
	ok_button_text = translator.xlate(&"OK")
	cancel_button_text = translator.xlate(&"Cancel")
	title = translator.xlate(&"Complete Tracks")


func has_track(animation: Animation, type: int, node_path: NodePath) -> bool:
	for i in animation.get_track_count():
		if animation.track_get_type(i) != type:
			continue
		if animation.track_get_path(i) != node_path:
			continue
		return true
	return false


func _on_ok_pressed() -> void:
	if new_tracks.is_empty():
		return
	
	undo_redo.create_action(translator.xlate(&"Complete Tracks"))
	
	for animation_name in new_tracks:
		var animation := player.get_animation(animation_name)
		undo_redo.add_do_reference(animation)
		undo_redo.add_undo_reference(animation)
		
		var base_index := animation.get_track_count()
		var tracks: Array[Dictionary] = new_tracks[animation_name]
		for i in tracks.size():
			var track := tracks[i]
			var index := base_index + i
			undo_redo.add_do_method(animation, &"add_track", track.type)
			undo_redo.add_do_method(animation, &"track_set_path", index, track.path)
			undo_redo.add_do_method(animation, &"track_insert_key", index, track.key_time, track.key_value, track.key_transition)
		
		for i in range(tracks.size() - 1, -1, -1):
			var index := base_index + i
			undo_redo.add_undo_method(animation, &"remove_track", index)
	
	undo_redo.commit_action()
