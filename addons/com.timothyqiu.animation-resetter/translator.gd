@tool
extends RefCounted

var translation := Translation.new()


func setup(editor: EditorInterface) -> void:
	var locale := editor.get_editor_settings().get('interface/editor/editor_language') as String
	match locale:
		"zh_CN":
			translation.add_message(&"Complete Tracks from RESET...", &"从 RESET 补全轨道...")
			translation.add_message(&"Please make sure an AnimationPlayer is selected and RESET animation is available.", &"请确保选中 AnimationPlayer，并且存在 RESET 动画。")
			translation.add_message(&"No action required", &"无需修改")
			translation.add_message(&"Copy from RESET", &"从 RESET 复制")
			translation.add_message(&"Complete Tracks", &"补全轨道")
			translation.add_message(&"OK", &"确定")
			translation.add_message(&"Cancel", &"取消")


func xlate(message: StringName) -> StringName:
	var translated := translation.get_message(message)
	if translated.is_empty():
		return message
	return translated
