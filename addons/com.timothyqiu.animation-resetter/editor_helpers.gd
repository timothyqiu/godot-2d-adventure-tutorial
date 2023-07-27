@tool
extends Object


static func get_first_typed_child(parent: Node, klass: String) -> Node:
	for i in parent.get_child_count():
		var node := parent.get_child(i) as Node
		if node.get_class() == klass:
			return node
	return null


static func insert_menu_item(menu: PopupMenu, index: int, id: int, text: String, icon: Texture2D) -> void:
	var items: Array[Dictionary] = []
	
	for i in range(index, menu.item_count):
		items.append({
			accelerator=menu.get_item_accelerator(i),
			icon=menu.get_item_icon(i),
			id=menu.get_item_id(i),
			indent=menu.get_item_indent(i),
			metadata=menu.get_item_metadata(i),
			language=menu.get_item_language(i),
			shortcut=menu.get_item_shortcut(i),
			submenu=menu.get_item_submenu(i),
			text=menu.get_item_text(i),
			text_direction=menu.get_item_text_direction(i),
			tooltip=menu.get_item_tooltip(i),
			checkable=menu.is_item_checkable(i),
			checked=menu.is_item_checked(i),
			disabled=menu.is_item_disabled(i),
			radio_checkable=menu.is_item_radio_checkable(i),
			separator=menu.is_item_separator(i),
			shortcut_disabled=menu.is_item_shortcut_disabled(i),
		})
	
	for i in range(menu.item_count - 1, index - 1, -1):
		menu.remove_item(i)
	
	menu.add_icon_item(icon, text, id)
	
	for item in items:
		var item_index := menu.item_count
		
		if item.separator:
			menu.add_separator(item.text, item.id)
		else:
			menu.add_item(item.text, item.id)
		
		menu.set_item_accelerator(item_index, item.accelerator)
		menu.set_item_icon(item_index, item.icon)
		menu.set_item_indent(item_index, item.indent)
		menu.set_item_metadata(item_index, item.metadata)
		menu.set_item_language(item_index, item.language)
		menu.set_item_shortcut(item_index, item.shortcut)
		menu.set_item_text_direction(item_index, item.text_direction)
		menu.set_item_tooltip(item_index, item.tooltip)
		menu.set_item_as_checkable(item_index, item.checkable)
		menu.set_item_as_radio_checkable(item_index, item.radio_checkable)
		menu.set_item_shortcut_disabled(item_index, item.shortcut_disabled)

