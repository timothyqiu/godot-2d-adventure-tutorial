@tool
extends EditorPlugin

const EditorHelper := preload("res://addons/com.timothyqiu.animation-resetter/editor_helpers.gd")

const TOOL_ANIMATION_LIBRARY := 1  # See animation_player_editor_plugin.cpp
const TOOL_COMPLETE_TRACKS := 9999

var cached_button: MenuButton
var player: AnimationPlayer
var translator := preload("res://addons/com.timothyqiu.animation-resetter/translator.gd").new()


func _enter_tree() -> void:
	translator.setup(get_editor_interface())
	
	var button := get_animation_button()
	var popup := button.get_popup()
	
	if popup.get_item_index(TOOL_COMPLETE_TRACKS) != -1:
		return
		
	var index := popup.get_item_index(TOOL_ANIMATION_LIBRARY)
	EditorHelper.insert_menu_item(
		popup,
		index + 1,
		TOOL_COMPLETE_TRACKS,
		translator.xlate(&"Complete Tracks from RESET..."),
		button.get_theme_icon(&"AnimationTrackGroup", &"EditorIcons")
	)
	
	popup.about_to_popup.connect(_on_about_to_popup)
	popup.id_pressed.connect(_on_id_pressed)
	
	# Select the last selected AnimationPlayer
	for node in get_editor_interface().get_selection().get_selected_nodes():
		if node is AnimationPlayer:
			player = node


func _exit_tree() -> void:
	var button := get_animation_button()
	var popup := button.get_popup()
	
	var index := popup.get_item_index(TOOL_COMPLETE_TRACKS)
	if index == -1:
		return
	
	popup.remove_item(index)


func _handles(object: Object) -> bool:
	return object is AnimationPlayer


func _edit(object: Object) -> void:
	if not object:
		return
	player = object as AnimationPlayer


func get_animation_button() -> MenuButton:
	if not cached_button:
		var editor := get_animation_player_editor()
		if not editor:
			return null
		
		var hb := EditorHelper.get_first_typed_child(editor, "HBoxContainer")
		if not hb:
			return null
		
		var button := EditorHelper.get_first_typed_child(hb, "MenuButton")
		if not button:
			return null
	
		cached_button = button
	
	return cached_button


func get_animation_player_editor() -> Node:
	var nodes := [get_editor_interface().get_base_control()]
	while nodes:
		var node := nodes.pop_front() as Node
		if node.get_class() == "AnimationPlayerEditor":
			return node
		nodes.append_array(node.get_children())
	return null


func _on_about_to_popup() -> void:
	var button := get_animation_button()
	var popup := button.get_popup()
	var index := popup.get_item_index(TOOL_COMPLETE_TRACKS)
	var disable := not player or not player.has_animation(&"RESET")
	popup.set_item_disabled(index, disable)
	if disable:
		popup.set_item_tooltip(index, translator.xlate(&"Please make sure an AnimationPlayer is selected and RESET animation is available."))
	else:
		popup.set_item_tooltip(index, "")


func _on_id_pressed(id: int) -> void:
	if id != TOOL_COMPLETE_TRACKS:
		return
	if not player or not player.has_animation(&"RESET"):
		return
	
	var dialog := preload("res://addons/com.timothyqiu.animation-resetter/complete_tracks_dialog.tscn").instantiate()
	dialog.setup(player, get_undo_redo(), translator)
	get_editor_interface().get_base_control().add_child(dialog)
	dialog.popup_centered_ratio(0.4)
	dialog.visibility_changed.connect(dialog.queue_free)
