extends Node

var game_board: Array[Array] = []
var mask: Array[Array] = []

@onready var tile_mask: TileMapLayer = %TileMask
@onready var tiles: TileMapLayer = %Tiles

# TODO: think how to generate it for boards that are not square
# TODO: for now I just take one of the numbers as the max
func generate_boards(number_of_bombs: int, height: int, width: int):
	game_board = generate_empty_grid(height, width, Constants.EMPTY_TILE)
	var bomb_locations := Constants.generate_unique_points(number_of_bombs, height - 1)
	place_bombs_on_grid(bomb_locations)
	mask = generate_empty_grid(height, width, Constants.CELL_CLOSED)

func generate_empty_grid(height: int, width: int, empty_value) -> Array[Array]:
	var board: Array[Array] = []
	for i in height:
		var row = []
		for j in width:
			row.append(empty_value)
		board.append(row)
	return board

func place_bombs_on_grid(bomb_locations: Array):
	for element in bomb_locations:
		game_board[element.x][element.y] = Constants.BOMB_TILE
		
		# Increase the number around the bomb
		increase_counters_for_bombs_on_grid(game_board, element)

func increase_counters_for_bombs_on_grid(board: Array, bomb_location: Vector2i):
	for direction in Constants.POSITIONS_AROUND_POINT:
		var counter_position_x := bomb_location.x + direction.x
		var counter_position_y := bomb_location.y + direction.y
		if (counter_position_x >= board.size() or counter_position_x < 0
			or counter_position_y >= board[0].size() or counter_position_y < 0
			or board[counter_position_x][counter_position_y] == Constants.BOMB_TILE):
			continue
		else:
			board[counter_position_x][counter_position_y] += 1

# Toggles the flag and returns if it was flagged
func toggle_flag_mask_cell(cell_coordinates: Vector2i) -> String:
	var mask_cell_value = mask[cell_coordinates.x][cell_coordinates.y]
	if mask_cell_value == Constants.CELL_FLAGGED:
		mask[cell_coordinates.x][cell_coordinates.y] = Constants.CELL_CLOSED
		return Constants.CELL_CLOSED
	elif mask_cell_value == Constants.CELL_CLOSED:
		mask[cell_coordinates.x][cell_coordinates.y] = Constants.CELL_FLAGGED
		return Constants.CELL_FLAGGED
	else:
		return Constants.CELL_OPEN

func coords_within_boundaries(cell_coordinates: Vector2i) -> bool:
	return !(cell_coordinates.x >= game_board.size()
		|| cell_coordinates.y >= game_board[0].size()
		|| cell_coordinates.x < 0
		|| cell_coordinates.y < 0)

func erase_mask_cell(cell_coordinates: Vector2i):
	var cells_to_open = [cell_coordinates]
	while cells_to_open.size() > 0:

		var current_cell_to_open = cells_to_open.pop_front()

		mask[current_cell_to_open.x][current_cell_to_open.y] = Constants.CELL_OPEN
		tile_mask.clear_mask_cell(current_cell_to_open)

		if game_board[current_cell_to_open.x][current_cell_to_open.y] == Constants.EMPTY_TILE:
			for direction in Constants.POSITIONS_AROUND_POINT:

				var cell_next_to_current = current_cell_to_open + direction
				
				if (coords_within_boundaries(cell_next_to_current) 
					&& mask[cell_next_to_current.x][cell_next_to_current.y] != Constants.CELL_OPEN
					&& game_board[cell_next_to_current.x][cell_next_to_current.y] != Constants.BOMB_TILE):

					cells_to_open.append(current_cell_to_open + direction)

func is_a_bomb(cell_coordinates: Vector2i) -> bool:
	return game_board[cell_coordinates.x][cell_coordinates.y] == Constants.BOMB_TILE

func set_death_state_of_bombs(clicked_bomb_cell: Vector2i):
	# TODO: set the button to show dead
	var restart_button = get_node("../UI/PanelContainer/HBoxContainer/RestartButton")
	restart_button.changed_button_to_dead()
	tiles.set_exploding_bomb(clicked_bomb_cell)
	for row in game_board.size():
		for column in game_board[row].size():
			if game_board[row][column] != Constants.BOMB_TILE and mask[row][column] == Constants.CELL_FLAGGED:
				# TODO: change it to the wrongly flagged here
				continue
			elif game_board[row][column] == Constants.BOMB_TILE and mask[row][column] != Constants.CELL_FLAGGED:
				tile_mask.clear_mask_cell(Vector2i(row, column))
			
