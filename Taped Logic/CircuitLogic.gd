extends TileMap


#[off,on]
var indicatorLightAtlas = [Vector2i(0,1),Vector2i(1,1)]
var outputComponentAtlas = indicatorLightAtlas

var powerButtonAtlas = [Vector2i(0,0),Vector2i(1,0)]
var inputComponentAtlas = powerButtonAtlas

#[right,down,left,top]
var notGateAtlas = [Vector2i(4,0),Vector2i(3,0),Vector2i(4,1),Vector2i(2,0)]
var andGateAtlas = [Vector2i(2,2),Vector2i(4,2),Vector2i(0,4),Vector2i(0,2)]
var orGateAtlas = [Vector2i(4,4),Vector2i(2,6),Vector2i(0,6),Vector2i(2,4)]
var logicComponentAtlas = notGateAtlas + andGateAtlas + orGateAtlas

var outputComponents = []
var inputComponents = []
var logicComponents = []



func _ready():
	# Load Components
	for cell in outputComponentAtlas:
		outputComponents.append_array(get_components_of_type(cell))
		
	for cell in inputComponentAtlas:
		inputComponents.append_array(get_components_of_type(cell))
	
	for cell in logicComponentAtlas:
		logicComponents.append_array(get_components_of_type(cell))
	
	componentUpdate()
	
func _process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var cellPos = local_to_map(get_local_mouse_position())
		if cellPos in inputComponents:
			if get_cell_atlas_coords(2,cellPos) == powerButtonAtlas[0]:
				update_cell_atlas(cellPos,powerButtonAtlas[1])
			elif get_cell_atlas_coords(2,cellPos) == powerButtonAtlas[1]:
				update_cell_atlas(cellPos,powerButtonAtlas[0])
			
			componentUpdate()

func get_components_of_type(atlasCord = Vector2i(0,1)):
	var components = get_used_cells(2)
	var selectedComponents = []
	for component in components:
		if get_cell_atlas_coords(2,component) == atlasCord:
			selectedComponents.append(component)
	return selectedComponents

func update_cell_atlas(cellPosition = Vector2i(0,0),atlasCord = Vector2i(0,0)):
	if get_cell_atlas_coords(2,cellPosition) != atlasCord:
		set_cell(2,cellPosition,0,atlasCord)

func total_peering_bits( cellPosition = Vector2i(0,1),layer = 1):
	var peering_bits = 0
	for i in [0,3,4,7,8,11,12,15]:
		if get_cell_tile_data(layer,cellPosition).get_terrain_peering_bit(i) != -1:
			peering_bits += 1
	return peering_bits

func get_wire_endpoints(wireArray=[]):
	var endpointArray = []
	for wire in wireArray:
		if total_peering_bits(wire) == 1:
			endpointArray.append(wire)
	return endpointArray

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

func tiles_connected(cell1Position = Vector2i(1,1),cell2Position = Vector2i(0,1)):
	var direction = Vector2i(cell1Position - cell2Position)
	
	if direction == Vector2i(1,0):#Left
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(8)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(0)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) != -1:
			return true

	elif direction == Vector2i(-1,0):#Right
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(0)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(8)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) != -1:
			return true
			
	elif  direction == Vector2i(0,1):#Up
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(12)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(4)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) != -1:
			return true
			
	elif direction == Vector2i(0,-1):#Down
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(7)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(11)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(4)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(12)) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(int_to_cell_neighboor(3)) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(int_to_cell_neighboor(15)) != -1:
			return true
	
	else:
		return false

func get_wire_group(rootCellPosition = Vector2i(0,1)): #creates an array of all the positions for start?
	var processedWires = []
	var wiresToProcess = []
	var quantumWire = Vector2i()
	
	if rootCellPosition in get_used_cells(1):
		wiresToProcess.append(rootCellPosition)
	
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
		if wiresToProcess[0] not in processedWires:
			processedWires.append(wiresToProcess[0])
		wiresToProcess.erase(wiresToProcess[0])
	return processedWires

func wire_powered(wireArray=[]):
	
	var wirePoints = wireArray #get_wire_endpoints(wireArray)
	
	for point in wirePoints:
		
		# Powered Button Check
		if point in inputComponents:
			if get_cell_atlas_coords(2,point) == powerButtonAtlas[1]:
				return true

		elif point in logicComponents:
			
			var direction
			var wire1Result
			var wire2Result
			
			# Finding Direction
			direction = logicComponentAtlas.find(get_cell_atlas_coords(2,point)) % 4
			
			# Checking For Powered Wires
			if direction == 0:
				wire1Result = wire_powered(get_wire_group(Vector2i(point.x-1,point.y)))
				wire2Result = wire_powered(get_wire_group(Vector2i(point.x-1,point.y-1)))
			elif direction == 1:
				wire1Result = wire_powered(get_wire_group(Vector2i(point.x,point.y-1)))
				wire2Result = wire_powered(get_wire_group(Vector2i(point.x+1,point.y-1)))
			elif direction == 2:
				wire1Result = wire_powered(get_wire_group(Vector2i(point.x+1,point.y)))
				wire2Result = wire_powered(get_wire_group(Vector2i(point.x+1,point.y+1)))
			elif direction == 3:
				wire1Result = wire_powered(get_wire_group(Vector2i(point.x,point.y+1)))
				wire2Result = wire_powered(get_wire_group(Vector2i(point.x-1,point.y+1)))
			

			# Testing Logic Gate Conditions
			if get_cell_atlas_coords(2,point) in notGateAtlas:
				if wire1Result == false:
					return true
			elif get_cell_atlas_coords(2,point) in andGateAtlas:
				if wire1Result == true and wire2Result == true:
					return true
			elif get_cell_atlas_coords(2,point) in orGateAtlas:
				if wire1Result == true or wire2Result == true:
					return true
	return false

func componentUpdate():
	
	for outputComponent in outputComponents:
		if wire_powered(get_wire_group(outputComponent)):
			update_cell_atlas(outputComponent,outputComponentAtlas[1])
		else:
			update_cell_atlas(outputComponent,outputComponentAtlas[0])
