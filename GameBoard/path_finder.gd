extends RefCounted

class_name PathFinder

const DIRECTIONS = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]

var _grid: Resource
var _astar := AStar2D.new()


func _init(grid: Grid, walkable_cells: Array) -> void:
	_grid = grid
	var cell_mappings := {}
	for cell: Vector2 in walkable_cells:
		cell_mappings[cell] = _grid.as_index(cell)
	_add_and_connect_points(cell_mappings)


func calculate_point_path(start: Vector2, end: Vector2) -> PackedVector2Array:
	var start_index: int = _grid.as_index(start)
	var end_index: int = _grid.as_index(end)
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index, end_index)
	else:
		return PackedVector2Array()


func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	for point: Vector2 in cell_mappings:
		_astar.add_point(cell_mappings[point], point)

	for point: Vector2 in cell_mappings:
		for neighbor_index: int in _find_neighbor_indices(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighbor_index)


func _find_neighbor_indices(cell: Vector2, cell_mappings: Dictionary) -> Array:
	var out := []
	for direction: Vector2 in DIRECTIONS:
		var neighbor: Vector2 = cell + direction
		if not cell_mappings.has(neighbor):
			continue
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
			out.push_back(cell_mappings[neighbor])
	return out
