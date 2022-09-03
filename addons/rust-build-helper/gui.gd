extends PanelContainer

signal build_completed(exit_code)

onready var status: LineEdit = $ScrollContainer/VBoxContainer/Status/LineEdit
onready var cargo_dir: LineEdit = $ScrollContainer/VBoxContainer/CargoDir/LineEdit
onready var release: CheckButton = $ScrollContainer/VBoxContainer/Release
onready var build: Button = $ScrollContainer/VBoxContainer/Build

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _ready() -> void:
	build.connect("pressed", self, "_on_build")
	connect("build_completed", self, "_on_build_completed")

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

func _on_build() -> void:
	var src_dir := cargo_dir.text
	if src_dir.empty():
		status.text = "No cargo directory set, aborting"
		return
	
	build.disabled = true
	OS.window_minimized = true
	
	var exe := ""
	
	var args := ["cd %s/%s && cargo build" % [ProjectSettings.globalize_path("res://"), src_dir]]
	if release.pressed:
		args.append("--release")
	if OS.get_name().to_lower() == "windows":
		exe = "CMD.exe"
		args.push_front("/C")
	else:
		exe = "bash"
	
	var err: int = OS.execute(exe, args, true)
	
	emit_signal("build_completed", err)

func _on_build_completed(exit_code: int) -> void:
	build.disabled = false
	OS.window_minimized = false
	
	if exit_code == 0:
		status.text = "Build successful"
	else:
		status.text = "Build error: %d" % exit_code

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#
