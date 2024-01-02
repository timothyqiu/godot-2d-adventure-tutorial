extends Node

# 场景的名称 => {
#   enemies_alive => [ 敌人的路径 ]
# }
var world_states := {}

@onready var player_stats: Node = $PlayerStats
@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	color_rect.color.a = 0


func change_scene(path: String, entry_point: String) -> void:
	var tree := get_tree()
	tree.paused = true
	
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.2)
	await tween.finished
	
	var old_name := tree.current_scene.scene_file_path.get_file().get_basename()
	world_states[old_name] = tree.current_scene.to_dict()
	
	tree.change_scene_to_file(path)
	await tree.process_frame  # 4.2 以前
#	await tree.tree_changed  # 4.2 开始
	
	var new_name := tree.current_scene.scene_file_path.get_file().get_basename()
	if new_name in world_states:
		tree.current_scene.from_dict(world_states[new_name])
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction)
			break
	
	tree.paused = false
	
	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0, 0.2)
