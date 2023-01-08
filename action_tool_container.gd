extends VBoxContainer

var water_label: Label
var thresher_label: Label
var torch_label: Label
var seedbag_label: Label
var labels = []

var active_tool: int = -1
var stylebox_override: StyleBoxFlat

func _ready():
	EventBus.connect("tool_changed", self, "_on_tool_changed")
	stylebox_override = StyleBoxFlat.new()
	stylebox_override.bg_color = Color.white
	water_label = $Water
	thresher_label = $Thresher
	torch_label = $Torch
	seedbag_label = $Seedbag
	labels = [
		water_label, thresher_label, torch_label, seedbag_label
	]
	
func _on_tool_changed(action_tool):
	active_tool = action_tool
	for label in labels:
		set_label_inactive(label)
	match active_tool:
		Globals.ACTION_TOOLS.WATER:
			set_label_active(water_label)
		Globals.ACTION_TOOLS.THRESHER:
			set_label_active(thresher_label)
		Globals.ACTION_TOOLS.TORCH:
			set_label_active(torch_label)
		Globals.ACTION_TOOLS.SEEDBAG:
			set_label_active(seedbag_label)
	pass
	
func set_label_active(label: Label):
	label.add_stylebox_override("normal", stylebox_override)
	label.add_color_override("font_color", Color.black)
	pass
	
func set_label_inactive(label):
	label.remove_stylebox_override("normal")
	label.remove_color_override("font_color")
	pass
