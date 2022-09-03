tool
extends EditorPlugin

var gui: Control

func _enter_tree() -> void:
	gui = preload("./gui.tscn").instance()
	_inject_tool(gui)
	add_control_to_bottom_panel(gui, "Rust Build")

func _exit_tree() -> void:
	if gui != null:
		remove_control_from_bottom_panel(gui)
		gui.queue_free()

func _inject_tool(node: Node) -> void:
	var script: GDScript = node.get_script().duplicate()
	
	script.source_code = "tool\n%s" % script.source_code
	script.reload(false)
	
	node.set_script(script)
