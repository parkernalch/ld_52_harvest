extends Panel
class_name Farm

var cells
var cell_scene = preload("res://farm_cell.tscn")
onready var grid_container = $GridContainer

var selected_index = [ 0, 0 ]
var current_tool: int

func _ready():
	populate_farm(randi())
	current_tool = Globals.ACTION_TOOLS.WATER
	yield(get_tree(), "idle_frame")
	EventBus.emit_signal("tool_changed", current_tool)
	pass
	
func _draw():
	pass
	
func _input(event):
	var tool_changed = false
	if event is InputEventKey:
		if event.is_action_pressed("move_up"):
			move_up()
		if event.is_action_pressed("move_down"):
			move_down()
		if event.is_action_pressed("move_right"):
			move_right()
		if event.is_action_pressed("move_left"):
			move_left()
		if event.is_action_pressed("toggle_ability"):
			next_tool()
		if event.is_action_pressed("use_ability"):
			use_tool()
		if event.is_action_pressed("select_water"):
			current_tool = Globals.ACTION_TOOLS.WATER
			tool_changed = true
		if event.is_action_pressed("select_burn"):
			current_tool = Globals.ACTION_TOOLS.TORCH
			tool_changed = true
		if event.is_action_pressed("select_pick"):
			current_tool = Globals.ACTION_TOOLS.THRESHER
			tool_changed = true
		if event.is_action_pressed("select_sow"):
			current_tool = Globals.ACTION_TOOLS.SEEDBAG
			EventBus.emit_signal("tool_changed", current_tool)
			tool_changed = true
	if tool_changed:
		EventBus.emit_signal("tool_changed", current_tool)
		select_current_cell()
				
func populate_farm(random_seed):
	seed(random_seed)
	cells = []
	for j in range(grid_container.columns):
		cells.append([])
		for i in range(grid_container.columns):
			var instance = cell_scene.instance()
			$GridContainer.add_child(instance)
			instance.set_farm(self)
			cells[j].append(instance)
	cells[selected_index[1]][selected_index[0]].select()
	highlight_neighbors()
	pass

func select_current_cell():
	cells[selected_index[1]][selected_index[0]].select()
	highlight_neighbors()

func highlight_neighbors():
	var shape
	match current_tool:
		Globals.ACTION_TOOLS.WATER:
			shape = Globals.tool_size_water
		Globals.ACTION_TOOLS.THRESHER:
			shape = Globals.tool_size_thresher
		Globals.ACTION_TOOLS.TORCH:
			shape = Globals.tool_size_torch
		Globals.ACTION_TOOLS.SEEDBAG:
			shape = Globals.tool_size_seedbag
	for j in range(len(shape)):
		for i in range(len(shape[j])):
			if shape[j][i] == 0:
				continue
			var j_ind = selected_index[1] + j - 1
			var i_ind = selected_index[0] + i - 1
			if j_ind >= 6 or i_ind >= 6:
				continue
			if j_ind < 0 or i_ind < 0:
				continue
			cells[selected_index[1] + j - 1][selected_index[0] + i - 1].highlight()
	pass

func apply_to_neighbors():
	var shape
	match current_tool:
		Globals.ACTION_TOOLS.WATER:
			shape = Globals.tool_size_water
		Globals.ACTION_TOOLS.THRESHER:
			shape = Globals.tool_size_thresher
		Globals.ACTION_TOOLS.TORCH:	
			shape = Globals.tool_size_torch
		Globals.ACTION_TOOLS.SEEDBAG:
			shape = Globals.tool_size_seedbag
	for j in range(len(shape)):
		for i in range(len(shape[j])):
			if shape[j][i] == 0:
				continue
			var j_ind = selected_index[1] + j - 1
			var i_ind = selected_index[0] + i - 1
			if j_ind >= 6 or i_ind >= 6:
				continue
			if j_ind < 0 or i_ind < 0:
				continue
			if [i_ind, j_ind] == selected_index:
				continue
			cells[selected_index[1] + j - 1][selected_index[0] + i - 1].apply_tool_action(current_tool)
	pass

func move_up():
	if selected_index[1] == 0:
		print("bump up!")
	else:
		selected_index[1] = selected_index[1] - 1
		select_current_cell()
	pass
	
func move_down():
	if selected_index[1] == grid_container.columns - 1:
		print("bump down!")
	else:
		selected_index[1] = selected_index[1] + 1
		select_current_cell()
	pass
	
func move_right():
	if selected_index[0] == grid_container.columns - 1:
		print("bump right")
	else:
		selected_index[0] = selected_index[0] + 1
		select_current_cell()
	pass
	
func move_left():
	if selected_index[0] == 0:
		print("bump left!")
	else:
		selected_index[0] = selected_index[0] - 1
		select_current_cell()
	pass

func next_tool():
	match current_tool:
		Globals.ACTION_TOOLS.WATER:
			current_tool = Globals.ACTION_TOOLS.THRESHER
		Globals.ACTION_TOOLS.THRESHER:
			current_tool = Globals.ACTION_TOOLS.TORCH
		Globals.ACTION_TOOLS.TORCH:
			current_tool = Globals.ACTION_TOOLS.SEEDBAG
		Globals.ACTION_TOOLS.SEEDBAG:
			current_tool = Globals.ACTION_TOOLS.WATER
	EventBus.emit_signal("tool_changed", current_tool)
	select_current_cell()

func use_tool():
	var selected_cell = cells[selected_index[1]][selected_index[0]]
	selected_cell.apply_tool_action(current_tool)
	apply_to_neighbors()
