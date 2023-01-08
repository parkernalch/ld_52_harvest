extends Node

func apply_tool_to_cell(cell_state, tool_applied) -> int:
	match cell_state:
		# UNPLANTED CROP
		Globals.GROWTH_STAGE.UNPLANTED:
			match tool_applied:
				Globals.ACTION_TOOLS.WATER:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.THRESHER:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					return Globals.GROWTH_STAGE.SEEDLING
				_:
					return Globals.GROWTH_STAGE.UNPLANTED
		
		# SEEDLING CROP
		Globals.GROWTH_STAGE.SEEDLING:
			match tool_applied:
				Globals.ACTION_TOOLS.WATER:
					return Globals.GROWTH_STAGE.BUD
				Globals.ACTION_TOOLS.THRESHER:
					return Globals.GROWTH_STAGE.SEEDLING
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					return Globals.GROWTH_STAGE.SEEDLING
				_:
					return Globals.GROWTH_STAGE.SEEDLING
		
		# BUDDING CROP
		Globals.GROWTH_STAGE.BUD:
			match tool_applied:
				Globals.ACTION_TOOLS.WATER:
					return Globals.GROWTH_STAGE.FRUITING
				Globals.ACTION_TOOLS.THRESHER:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					return Globals.GROWTH_STAGE.BUD
				_:
					return Globals.GROWTH_STAGE.BUD
			pass
		
		# FRUITING CROP
		Globals.GROWTH_STAGE.FRUITING:
			match tool_applied:
				Globals.ACTION_TOOLS.WATER:
					return Globals.GROWTH_STAGE.RIPE
				Globals.ACTION_TOOLS.THRESHER:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					return Globals.GROWTH_STAGE.RIPE
				_:
					return Globals.GROWTH_STAGE.FRUITING
		
		# RIPE CROP
		Globals.GROWTH_STAGE.RIPE:
			match tool_applied:
				Globals.ACTION_TOOLS.WATER:
					Globals.crops_spoiled += 1
					EventBus.emit_signal("spoiled_count_changed", Globals.crops_spoiled)
					return Globals.GROWTH_STAGE.DISEASED
				Globals.ACTION_TOOLS.THRESHER:
					Globals.crops_harvested += 1
					Globals.water_level = min(10, Globals.water_level + 5)
					Globals.seed_stores = min(10, Globals.water_level + 3)
					Globals.torch_fuel = min(10, Globals.water_level + 2)
					EventBus.emit_signal("ripe_count_changed", Globals.crops_harvested)
					EventBus.emit_signal("water_level_changed", Globals.water_level)
					EventBus.emit_signal("seed_level_changed", Globals.seed_stores)
					EventBus.emit_signal("torch_level_changed", Globals.torch_fuel)
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					Globals.crops_spoiled += 1
					EventBus.emit_signal("spoiled_count_changed", Globals.crops_spoiled)
					return Globals.GROWTH_STAGE.DISEASED
				_:
					Globals.crops_spoiled += 1
					EventBus.emit_signal("spoiled_count_changed", Globals.crops_spoiled)
					return Globals.GROWTH_STAGE.DISEASED
		
		# DISEASED CROP
		Globals.GROWTH_STAGE.DISEASED:
			if tool_applied == Globals.ACTION_TOOLS.TORCH:
				return Globals.GROWTH_STAGE.UNPLANTED
			return Globals.GROWTH_STAGE.DISEASED
	
	return -1
