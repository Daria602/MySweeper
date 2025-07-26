extends TileMapLayer

@onready var game_mechanics_manager: Node = %GameMechanicsManager
@onready var tile_mask: TileMapLayer = %TileMask

func draw_tile_mask(height: int, width: int):
	clear()
	for row_index in height:
		for column_index in width:
			set_cell(
					Vector2i(row_index, column_index), 
					Constants.TILE_SET_ID, 
					Constants.CELLS_COORDINATES[Constants.UNEXPLORED])

func _input(event: InputEvent) -> void:
	# TODO: make a condition somewhere here to highlight the cells near the pressed number
	if event is InputEventMouseButton and event.pressed:
		var clicked_cell_coord = local_to_map(get_local_mouse_position())
		if !game_mechanics_manager.coords_within_boundaries(clicked_cell_coord):
			return
			
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Check if it's a bomb

			# If no, erase the cell
			if game_mechanics_manager.is_a_bomb(clicked_cell_coord):
				# Death and make it exploding bomb in the tiles generator, 
				# erase cells for all the other bombs except for those marked correctly
				game_mechanics_manager.set_death_state_of_bombs(clicked_cell_coord)
				return
			else:
				game_mechanics_manager.erase_mask_cell(clicked_cell_coord)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var wasFlagged = game_mechanics_manager.toggle_flag_mask_cell(clicked_cell_coord)
			toggle_flag(clicked_cell_coord, wasFlagged)

func toggle_flag(tile_coordinates: Vector2i, valueSetByManager: String):
	if valueSetByManager == Constants.CELL_FLAGGED:
		set_cell(
						tile_coordinates, 
						Constants.TILE_SET_ID, 
						Constants.CELLS_COORDINATES[Constants.FLAG])
	elif valueSetByManager == Constants.CELL_CLOSED:
		set_cell(
						tile_coordinates, 
						Constants.TILE_SET_ID, 
						Constants.CELLS_COORDINATES[Constants.UNEXPLORED])

func clear_mask_cell(tile_coordinates: Vector2i):
	erase_cell(tile_coordinates)

func set_flagged_wrong(cell_coordinates: Vector2i):
	set_cell(
					cell_coordinates,
					Constants.TILE_SET_ID,
					Constants.CELLS_COORDINATES[Constants.FLAG_WRONG])
