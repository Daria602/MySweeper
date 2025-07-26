extends Node

const TILE_SET_ID = 0

const EMPTY_TILE = 0
const BOMB_TILE = -1

# Mask cell states
const CELL_OPEN = 'O'
const CELL_CLOSED = 'C'
const CELL_FLAGGED = 'F'

const CELLS_COORDINATES = {
	"1": Vector2i(0,0),
	"2": Vector2i(1,0),
	"3": Vector2i(2,0),
	"4": Vector2i(3,0),
	"5": Vector2i(0,1),
	"6": Vector2i(1,1),
	"7": Vector2i(2,1),
	"8": Vector2i(3,1),
	"FLAG": Vector2i(0,2),
	"BOMB": Vector2i(1,2),
	"BOMB_EXPLODED": Vector2i(2,2),
	"UNEXPLORED": Vector2i(3,2),
	"FLAG_WRONG": Vector2i(0,3),
	"EXPLORED": Vector2i(1,3)
}

const FLAG = "FLAG"
const BOMB = "BOMB"
const BOMB_EXPLODED = "BOMB_EXPLODED"
const UNEXPLORED = "UNEXPLORED"
const EXPLORED = "EXPLORED"
const FLAG_WRONG = "FLAG_WRONG"

const POSITIONS_AROUND_POINT: Array[Vector2i] = [
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(1, -1),
	Vector2i(1, 0),
	Vector2i(1, 1)
]

# Images
const BUTTON_DEAD_IMAGE = preload("res://assets/minesweeper_dead.png")

func validate_input(count: int, max_val: int, min_val: int) -> bool:
	if min_val > max_val:
		return false
	# Number of permutations with reperirions
	# number_of_values^exponent
	# where exponent is the number of spots in permutation
	# e.g. 2 for point (x,y)
	var number_of_values = max_val + 1 + min_val * (-1 if min_val > 0 else 1)
	if count > number_of_values**2:
		return false
	
	return true

func generate_unique_points(count: int, max_val: int, min_val: int = 0) -> Array:
	# Validation
	if !validate_input(count, max_val, min_val):
		return []
	
	var unique_set := {}
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Generate random point
	while unique_set.size() < count:
		var x = rng.randi_range(min_val, max_val)
		var y = rng.randi_range(min_val, max_val)
		var vec = Vector2i(x, y)
		unique_set[vec] = true
	return unique_set.keys()

func get_cell_coordinates_string_based_on_board_value(value: int) -> String:
	match value:
		-1:
			return "BOMB"
		0:
			return "EXPLORED"
	return str(value)
