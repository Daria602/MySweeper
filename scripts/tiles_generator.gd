extends TileMapLayer

func update_visual_game_board(board: Array[Array]):
	for row_index in board.size():
		for column_index in board[0].size():
			set_tile(Vector2i(row_index, column_index), 
					Constants.get_cell_coordinates_string_based_on_board_value(board[row_index][column_index]))

func set_tile(tile_coordinates: Vector2i, tile_type: String):
	set_cell(tile_coordinates, Constants.TILE_SET_ID, Constants.CELLS_COORDINATES[tile_type])

func set_exploding_bomb(tile_coordinates: Vector2i):
	set_cell(tile_coordinates, Constants.TILE_SET_ID, Constants.CELLS_COORDINATES[Constants.BOMB_EXPLODED])
