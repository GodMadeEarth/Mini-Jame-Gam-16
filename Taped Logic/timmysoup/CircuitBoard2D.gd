extends TileMap



func _ready():
	print(get_wire_group(Vector2i(1,1)))

func _process(delta):
	pass

func get_components_of_type(atlasCord = Vector2i(0,1)):
	var components = get_used_cells(0)
	var selectedComponents = []
	for component in components:
		if get_cell_atlas_coords(2,component) == atlasCord:
			selectedComponents.append(component)
	return selectedComponents

#func emit_power(cellPosition = Vector2i(0,1)):
#
#	get_cell_tile_data(1,cellPosition).set_custom_data("powerPathing",1)

func tiles_connected(cell1Position = Vector2i(1,1),cell2Position = Vector2i(0,1)):
	var direction = Vector2i(cell1Position - cell2Position)
	
	if direction == Vector2i(1,0):#Left
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(7) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(3) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(8) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(0) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(11) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(15) != -1:
			return true

	elif direction == Vector2i(-1,0):#Right
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(3) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(7) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(0) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(8) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(15) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(11) != -1:
			return true
			
	elif  direction == Vector2i(0,1):#Up
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(11) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(7) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(12) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(4) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(15) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(3) != -1:
			return true
			
	elif direction == Vector2i(0,-1):#Down
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(7) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(11) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(4) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(12) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(3) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(15) != -1:
			return true
	
	else:
		return false

func get_wire_group(rootCellPosition = Vector2i(0,1)):
	var processedWires = []
	var wiresToProcess = [rootCellPosition]
	var quantumWire = Vector2i()
	
	while wiresToProcess.size() != 0:
		
		quantumWire = wiresToProcess[0]
		quantumWire.x += 1
		if quantumWire in get_used_cells(1) and quantumWire not in processedWires:
			if tiles_connected(wiresToProcess[0],quantumWire):
				wiresToProcess.append(quantumWire)
				
		quantumWire = wiresToProcess[0]
		quantumWire.x -= 1
		if quantumWire in get_used_cells(1) and quantumWire not in processedWires:
			if tiles_connected(wiresToProcess[0],quantumWire):
				wiresToProcess.append(quantumWire)
				
		quantumWire = wiresToProcess[0]
		quantumWire.y += 1
		if quantumWire in get_used_cells(1) and quantumWire not in processedWires:
			if tiles_connected(wiresToProcess[0],quantumWire):
				wiresToProcess.append(quantumWire)
				
		quantumWire = wiresToProcess[0]
		quantumWire.y -= 1
		if quantumWire in get_used_cells(1) and quantumWire not in processedWires:
			if tiles_connected(wiresToProcess[0],quantumWire):
				wiresToProcess.append(quantumWire)
				
		processedWires.append(wiresToProcess[0]);wiresToProcess.erase(wiresToProcess[0])
	return processedWires

