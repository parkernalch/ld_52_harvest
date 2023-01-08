extends Node

func apply_tool_to_cell(cell_state, tool_applied) -> int:
	print("applying tool " + str(tool_applied) + " to growth state " + str(cell_state))
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
					return Globals.GROWTH_STAGE.DISEASED
				Globals.ACTION_TOOLS.THRESHER:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.TORCH:
					return Globals.GROWTH_STAGE.UNPLANTED
				Globals.ACTION_TOOLS.SEEDBAG:
					return Globals.GROWTH_STAGE.DISEASED
				_:
					return Globals.GROWTH_STAGE.DISEASED
		
		# DISEASED CROP
		Globals.GROWTH_STAGE.DISEASED:
			if tool_applied == Globals.ACTION_TOOLS.TORCH:
				return Globals.GROWTH_STAGE.UNPLANTED
			return Globals.GROWTH_STAGE.DISEASED
	
	print("didnt match ", cell_state)
	return -1
