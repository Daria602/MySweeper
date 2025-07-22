extends Node

@onready var tiles: TileMapLayer = %Tiles
@onready var tile_mask: TileMapLayer = %TileMask
@onready var game_mechanics_manager: Node = %GameMechanicsManager

var width = 10
var height = 10
var n_bombs = 10

func _ready() -> void:
	# Generate both of the boards
	game_mechanics_manager.generate_boards(n_bombs, height, width)

	# Draws the board underneath
	tiles.update_visual_game_board(game_mechanics_manager.game_board)

	# Draws the tiles for the mask
	tile_mask.draw_tile_mask(height, width)

"""
TODO:
++++1. If you open an empty cell, trigger the open for the others
++++2. Implement restart
	2. Implement death
	3. If you right click on a number cell and it has sufficient number of flags around, try to open adjacent cells
	4. Implement "set board length, width, height", check for the correct amount of bombs to be generated (validator function)
	5. Check how the fucking camera is offset (it's now like 70 something on both axis)
	6. When clicking on a number, highlight the cells adjacent to it
	7. Add "wrongly flagged" tile, maybe with just some redness around it
"""
