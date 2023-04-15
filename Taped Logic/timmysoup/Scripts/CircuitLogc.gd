extends TileMap

var powerButtonAtlas = [Vector2i(0,0),Vector2i(1,0)]
var indicatorLightAtlas = [Vector2i(0,1),Vector2i(1,1)]
var notGateAtlas = [Vector2i(4,0),Vector2i(3,0),Vector2i(4,1),Vector2i(2,0)]
var andGateAtlas = [Vector2i(2,2),Vector2i(4,2),Vector2i(0,4),Vector2i(0,2)]
var orGateAtlas = [Vector2i(4,4),Vector2i(2,6),Vector2i(0,6),Vector2i(2,4)]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func int_to_cell_neighboor(integer):
	if integer == 0:
		return TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	elif integer == 1:
		return TileSet.CELL_NEIGHBOR_RIGHT_CORNER
	elif integer == 2:
		return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE
	elif integer == 3:
		return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER
	elif integer == 4:
		return TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
	elif integer == 5:
		return TileSet.CELL_NEIGHBOR_BOTTOM_CORNER
	elif integer == 6:
		return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
	elif integer == 7:
		return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER
	elif integer == 8:
		return TileSet.CELL_NEIGHBOR_LEFT_SIDE
	elif integer == 9:
		return TileSet.CELL_NEIGHBOR_LEFT_CORNER
	elif integer == 10:
		return TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	elif integer == 11:
		return TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER
	elif integer == 12:
		return TileSet.CELL_NEIGHBOR_TOP_SIDE
	elif integer == 13:
		return TileSet.CELL_NEIGHBOR_TOP_CORNER
	elif integer == 14:
		return TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE
	elif integer == 15:
		return TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER
	if integer == 0:
		return TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	elif integer == 1:
		return TileSet.CELL_NEIGHBOR_RIGHT_CORNER
	elif integer == 2:
		return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE
	elif integer == 3:
		return TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER
	elif integer == 4:
		return TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
	elif integer == 5:
		return TileSet.CELL_NEIGHBOR_BOTTOM_CORNER
	elif integer == 6:
		return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
	elif integer == 7:
		return TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
	elif integer == 8:
		return TileSet.CELL_NEIGHBOR_LEFT_SIDE
	elif integer == 9:
		return TileSet.CELL_NEIGHBOR_LEFT_CORNER
	elif integer == 10:
		return TileSet.CELL_NEIGHBOR_RIGHT_SIDE
	elif integer == 11:
		return TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER
	elif integer == 12:
		return TileSet.CELL_NEIGHBOR_TOP_SIDE
	elif integer == 13:
		return TileSet.CELL_NEIGHBOR_TOP_CORNER
	elif integer == 14:
		return TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE
	elif integer == 15:
		return TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER

func touching_terrain(cell1Cords = Vector2i(1,1),cell2Cords = Vector2i(0,1),layer = 1,terrain = -1):
	var direction = Vector2(cell1Cords - cell2Cords)
	
	var left = [7,8,11]
	var right = [3,0,15]
	var up = [11,12,15]
	var down = [7,4,3]
	
	var cell1Side = []
	var cell2Side = []
	
	var cell1Terrain = -1
	var cell2Terrain = -1
	
	if direction == Vector2i(1,0):
		cell1Side = left
		cell2Side = right
	elif direction == Vector2i(-1,0):
		cell1Side = right
		cell2Side = left
	elif  direction == Vector2i(0,1):
		cell1Side = up
		cell2Side = down
	elif  direction == Vector2i(0,-1):
		cell1Side = down
		cell2Side = up

	for i in range(3):
		cell1Terrain = get_cell_tile_data(layer,cell1Cords).get_terrain_peering_bit(int_to_cell_neighboor(cell1Side[i]))
		cell2Terrain = get_cell_tile_data(layer,cell2Cords).get_terrain_peering_bit(int_to_cell_neighboor(cell2Side[i]))
		
		if cell1Terrain == cell2Terrain and cell1Terrain + cell2Terrain != -2 or cell1Terrain + cell2Terrain == terrain*2:
			return true
	
	return false

func get_grouped_terrain_cells(startingCellCords,layer = 1):
	var cellsChecked = []
	var cellsToCheck = []
	var potentialCell = Vector2i()
	
	if startingCellCords in get_used_cells(layer):
		cellsToCheck.append(startingCellCords)
	
	while cellsToCheck.size() != 0:
		
		potentialCell = cellsToCheck[0]
		potentialCell.x += 1
		if potentialCell in get_used_cells(1) and potentialCell not in cellsChecked:
			if touching_terrain(cellsToCheck[0],potentialCell):
				cellsToCheck.append(potentialCell)
				
		potentialCell = cellsToCheck[0]
		potentialCell.x -= 1
		if potentialCell in get_used_cells(1) and potentialCell not in cellsChecked:
			if touching_terrain(cellsToCheck[0],potentialCell):
				cellsToCheck.append(potentialCell)
				
		potentialCell = cellsToCheck[0]
		potentialCell.y += 1
		if potentialCell in get_used_cells(1) and potentialCell not in cellsChecked:
			if touching_terrain(cellsToCheck[0],potentialCell):
				cellsToCheck.append(potentialCell)
				
		potentialCell = cellsToCheck[0]
		potentialCell.y -= 1
		if potentialCell in get_used_cells(1) and potentialCell not in cellsChecked:
			if touching_terrain(cellsToCheck[0],potentialCell):
				cellsToCheck.append(potentialCell)
				
		cellsChecked.append(cellsToCheck[0]);cellsToCheck.erase(cellsToCheck[0])
	return cellsChecked
