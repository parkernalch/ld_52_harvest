extends Control

var growth_stage: int = Globals.GROWTH_STAGE.UNPLANTED
var selected: bool = false
var highlighted: bool = false
var flash_timer = 0
export var inverted = false
var parent_farm

var stylebox_override: StyleBoxFlat
var highlight_stylebox: StyleBoxFlat

func _ready():
	stylebox_override = StyleBoxFlat.new()
	highlight_stylebox = StyleBoxFlat.new()
	stylebox_override.bg_color = Color.white
	highlight_stylebox.bg_color = Color(1, 1, 1, 0.5)	
	growth_stage = Globals.random_stage()
#	growth_stage = Globals.GROWTH_STAGE.UNPLANTED
	EventBus.connect("cell_selected", self, "_on_cell_selected")
	set_process(false)
	
func set_farm(farm):
	parent_farm = farm
	
func _draw():
	var label_text = Globals.get_char_from_growth_stage(growth_stage)
	if inverted:
		label_text = Globals.get_char_from_active_tool(parent_farm.current_tool)
		$Label.add_stylebox_override("normal", stylebox_override)
		$Label.add_color_override("font_color", Color.black)
	else:
#		stylebox_override.bg_color = Color.transparent
		label_text = Globals.get_char_from_growth_stage(growth_stage)
#		$Label.add_stylebox_override("normal", stylebox_override)
		$Label.remove_stylebox_override("normal")
#		$Label.add_color_override("font_color", Color.white)
		$Label.remove_color_override("font_color")
		if highlighted:
			$Label.add_color_override("font_color", Color(1, 1, 1, 0.3))
	$Label.text = label_text

func _on_cell_selected(cell):
	if not cell == self:
		if selected == true:
			selected = false
			inverted = false
		if highlighted == true:
			highlighted = false
			selected = false
			inverted = false
		_draw()
		set_process(false)
	pass

func select():
	selected = true
	EventBus.emit_signal("cell_selected", self)
	$Label.text = Globals.get_char_from_active_tool(parent_farm.current_tool)
	$Label.remove_color_override("font_color")
	$Label.add_color_override("font_color", Color.black)
	yield(get_tree(), "idle_frame")
	inverted = true
	flash_timer = 0
	set_process(true)
	_draw()

func highlight():
	highlighted = true
	$Label.add_color_override("font_color", Color(1, 1, 1, 0.3))

func _process(delta):
	if selected:
		flash_timer += delta
		if flash_timer > Globals.flash_rate:
			flash_timer = 0
			inverted = !inverted
			_draw()

func apply_tool_action(action_tool):
	var new_state = CropLogic.apply_tool_to_cell(growth_stage, action_tool)
	growth_stage = new_state
	_draw()
	pass
