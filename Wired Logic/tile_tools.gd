extends TileMap

func int_to_cell_neighboor(integer = int()):
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

func total_peering_bits(cellPosition = Vector2i(), layer = int(), terrainId = int()):
	var peering_bits = 0
	for i in [0,3,4,7,8,11,12,15]:
		if get_cell_tile_data(layer,cellPosition).get_terrain_peering_bit(i) == terrainId:
			peering_bits += 1
	return peering_bits

func cell_terrain_touching(cell1Position = Vector2i(), cell2Position = Vector2i(), layer = int(), terrainId = int()):
	var direction = Vector2i(cell1Position - cell2Position)
	
	if direction == Vector2i(1,0):#Left
		if get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(8)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(0)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) == terrainId:
			return true

	elif direction == Vector2i(-1,0):#Right
		if get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(0)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(8)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) == terrainId:
			return true
			
	elif  direction == Vector2i(0,1):#Up
		if get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(12)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(4)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) == terrainId:
			return true
			
	elif direction == Vector2i(0,-1):#Down
		if get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(4)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(12)) == terrainId:
			return true
		elif get_cell_tile_data(layer,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) == terrainId and get_cell_tile_data(layer,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) == terrainId:
			return true
	
	else:
		return false

func terrain_group(rootCellPosition = Vector2i(), layer = int(), terrainId = int()):
	var processedCells = []
	var cellsToProcess = []
	var testingCell = Vector2i()
	
	if rootCellPosition in get_used_cells(layer):
		cellsToProcess.append(rootCellPosition)
	
	while cellsToProcess.size() != 0:
		
		testingCell = cellsToProcess[0]
		testingCell.x += 1
		if testingCell in get_used_cells(layer) and testingCell not in processedCells:
			if cell_terrain_touching(cellsToProcess[0],testingCell,layer,terrainId):
				cellsToProcess.append(testingCell)
				
		testingCell = cellsToProcess[0]
		testingCell.x -= 1
		if testingCell in get_used_cells(layer) and testingCell not in processedCells:
			if cell_terrain_touching(cellsToProcess[0],testingCell,layer,terrainId):
				cellsToProcess.append(testingCell)
				
		testingCell = cellsToProcess[0]
		testingCell.y += 1
		if testingCell in get_used_cells(layer) and testingCell not in processedCells:
			if cell_terrain_touching(cellsToProcess[0],testingCell,layer,terrainId):
				cellsToProcess.append(testingCell)
				
		testingCell = cellsToProcess[0]
		testingCell.y -= 1
		if testingCell in get_used_cells(layer) and testingCell not in processedCells:
			if cell_terrain_touching(cellsToProcess[0],testingCell,layer,terrainId):
				cellsToProcess.append(testingCell)
		if cellsToProcess[0] not in processedCells:
			processedCells.append(cellsToProcess[0])
		cellsToProcess.erase(cellsToProcess[0])
	return processedCells

func cells_with_peering_bit_total(cellList = [Vector2i()], layer = int(), terrainId = int(), endpoints = int()):
	var selectedCells = []
	for cell in cellList:
		if total_peering_bits(cell,layer,terrainId) == endpoints:
			selectedCells.append(cell)
	return selectedCells

func update_cell_atlas(cellPosition = Vector2i(), layer = int(), atlasId = int(), atlasCord = Vector2i()):
	if cellPosition in get_used_cells(layer):
		set_cell(layer,cellPosition,atlasId,atlasCord)

func cells_in_atlas(atlasCords = [Vector2i()], layer = int()):
	var cells = get_used_cells(layer)
	var selectedCells = []
	for cell in cells:
		for atlasCord in atlasCords:
			if get_cell_atlas_coords(layer,cell) == atlasCord:
				selectedCells.append(cell)
	return selectedCells

