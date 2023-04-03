extends TileMap

# Load Component Atlas
var outputComponentAtlas = [Vector2i(0,1),Vector2i(1,1),Vector2i(2,8),Vector2i(2,9),Vector2i(5,8),Vector2i(4,8),Vector2i(4,7),Vector2i(4,6),Vector2i(0,8),Vector2i(1,8)]
var inputComponentAtlas = [Vector2i(0,0),Vector2i(1,0)]
#[off,on]
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
	
	_on_button_pressed()
	
func _process(delta):
	pass

func get_components_of_type(atlasCord = Vector2i(0,1)):
	var components = get_used_cells(2)
	var selectedComponents = []
	for component in components:
		if get_cell_atlas_coords(2,component) == atlasCord:
			selectedComponents.append(component)
	return selectedComponents

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
				
		processedWires.append(wiresToProcess[0]);wiresToProcess.erase(wiresToProcess[0])
	return processedWires

func total_peering_bits( cellPosition = Vector2i(0,1),layer = 1):
	var peering_bits = 0
	for i in [0,3,4,7,8,11,12,15]:
		if get_cell_tile_data(layer,cellPosition).get_terrain_peering_bit(i) != -1:
			peering_bits += 1
	return peering_bits

func _on_button_pressed():
	
	for outputComponent in outputComponents:
		if get_cell_atlas_coords(2,outputComponent) in outputComponentAtlas.slice(0,2):
			if wire_powered(get_wire_group(outputComponent)):
				update_cell_atlas(outputComponent,outputComponentAtlas[1])
			else:
				update_cell_atlas(outputComponent,outputComponentAtlas[0])


func update_cell_atlas(cellPosition = Vector2i(0,0),atlasCord = Vector2i(0,0)):
	if get_cell_atlas_coords(2,cellPosition) != atlasCord:
		set_cell(2,cellPosition,0,atlasCord)

func get_wire_endpoints(wireArray=[]):
	var endpointArray = []
	for wire in wireArray:
		if total_peering_bits(wire) == 1:
			endpointArray.append(wire)
	return endpointArray

func wire_powered(wireArray=[]):
	
	var wirePoints = get_wire_endpoints(wireArray)
	var returnValue = false
	
	for point in wirePoints:
		if point in inputComponents:
			if get_cell_atlas_coords(2,point) == inputComponentAtlas[1]:
				return true

		if point in logicComponents:
			
			var direction
			var wire1Result
			var wire2Result
			
			# Finding Direction
			if get_cell_atlas_coords(2,point) in notGateAtlas:
				direction = notGateAtlas.find(get_cell_atlas_coords(2,point))
			if get_cell_atlas_coords(2,point) in andGateAtlas:
				direction = andGateAtlas.find(get_cell_atlas_coords(2,point))
			if get_cell_atlas_coords(2,point) in orGateAtlas:
				direction = orGateAtlas.find(get_cell_atlas_coords(2,point))
			
			
			
			# Checking if wires conected
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
			
			#print(point,direction,wire1Result,wire2Result)
			
			# Finding Direction
			if get_cell_atlas_coords(2,point) in notGateAtlas:
				if wire1Result == false:
					return true
			elif get_cell_atlas_coords(2,point) in andGateAtlas:
				if wire1Result == true and wire2Result == true:
					return true
			elif get_cell_atlas_coords(2,point) in orGateAtlas:
				if wire1Result == true or wire2Result == true:
					return true
	return returnValue
