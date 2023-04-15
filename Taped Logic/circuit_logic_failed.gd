extends TileMap

enum components{
	ALL,
	POWER_BUTTON,
	INDICATOR_LIGHT,
	LOGIC_GATES,
	NOT_GATE,
	AND_GATE,
	OR_GATE
}

# Load atlas for each component
const powerButtontAtlas = [Vector2i(0,0),Vector2i(1,0)]
const indicatorLightAtlas = [Vector2i(0,1),Vector2i(1,1)]
const notGateAtlas = [Vector2i(4,0),Vector2i(3,0),Vector2i(4,1),Vector2i(2,0)]
const andGateAtlas = [Vector2i(2,2),Vector2i(4,2),Vector2i(0,4),Vector2i(0,2)]
const orGateAtlas = [Vector2i(4,4),Vector2i(2,6),Vector2i(0,6),Vector2i(2,4)]
const logicGatesAtlas = notGateAtlas + andGateAtlas + orGateAtlas
const allComponentsAtlas = powerButtontAtlas + indicatorLightAtlas + logicGatesAtlas

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func update():
	for component in get_components_in_atlas(components.INDICATOR_LIGHT):
		var wire_array = get_wire_group(component)
		if wire_powered(wire_array):
			update_component_atlas(component,get_componment_atlas(components.INDICATOR_LIGHT)[1])
		else:
			update_component_atlas(component,get_componment_atlas(components.INDICATOR_LIGHT)[0])
	
func tiles_connected(cell1Position = Vector2i(1,1),cell2Position = Vector2i(0,1)):
	var direction = Vector2i(cell1Position - cell2Position)
	
	if direction == Vector2i(1,0):#Left
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_RIGHT_SIDE) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1:
			return true

	if direction == Vector2i(-1,0):#Right
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_RIGHT_SIDE) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) != -1:
			return true
			
	if  direction == Vector2i(0,1):#Up
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_SIDE) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1:
			return true
			
	if direction == Vector2i(0,-1):#Down
		if get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_SIDE) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_TOP_SIDE) != -1:
			return true
		elif get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1 and get_cell_tile_data(1,cell2Position).get_terrain_peering_bit(TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER) != -1:
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
	
	var failState = false
	
	for point in wireArray:
		if point == get_components_in_atlas(components.POWER_BUTTON)[1]:
			return true

		elif point in get_components_in_atlas(components.LOGIC_GATES):
			if point in get_components_in_atlas(components.NOT_GATE):
				print("not")
				var direction = get_componment_atlas(components.NOT_GATE).find(get_cell_atlas_coords(2,point))
				var inputs = get_gate_inputs(components.NOT_GATE,point,direction)
				var results = []
				for input in inputs:
					results.append(get_wire_group(input))
				if get_gate_output(components.NOT_GATE,inputs):
					return true
				
			elif point in get_components_in_atlas(components.AND_GATE):
				var direction = get_componment_atlas(components.AND_GATE).find(get_cell_atlas_coords(2,point))
				var inputs = get_gate_inputs(components.AND_GATE,point,direction)
				var results = []
				for input in inputs:
					results.append(get_wire_group(input))
				if get_gate_output(components.AND_GATE,inputs):
					return true
				
			elif point in get_components_in_atlas(components.OR_GATE):
				var direction = get_componment_atlas(components.OR_GATE).find(get_cell_atlas_coords(2,point))
				var inputs = get_gate_inputs(components.OR_GATE,point,direction)
				var results = []
				for input in inputs:
					results.append(get_wire_group(input))
				if get_gate_output(components.OR_GATE,inputs):
					return true
		
		
	return failState

func get_componment_atlas(selectedComponent):
	if selectedComponent == components.ALL:
		return allComponentsAtlas
	elif selectedComponent == components.POWER_BUTTON:
		return powerButtontAtlas
	elif selectedComponent == components.INDICATOR_LIGHT:
		return indicatorLightAtlas
	elif selectedComponent == components.LOGIC_GATES:
		return logicGatesAtlas
	elif selectedComponent == components.NOT_GATE:
		return notGateAtlas
	elif selectedComponent == components.AND_GATE:
		return andGateAtlas
	elif selectedComponent == components.OR_GATE:
		return orGateAtlas

func get_components_in_atlas(selectedComponent):
	var allComponents = get_used_cells(2)
	var componentsInAtlas = []
	for component in allComponents:
		if get_cell_atlas_coords(2,component) in get_componment_atlas(selectedComponent):
			componentsInAtlas.append(component)
	return componentsInAtlas

func get_gate_inputs(selectedComponent,componentPosition,direction):
	if selectedComponent == components.NOT_GATE:
		var input1 = Vector2i(Vector2(-1,0).rotated(90*direction))+componentPosition
		var inputs = [input1]
		return inputs
	elif selectedComponent == components.AND_GATE:
		var input1 = Vector2i(Vector2(-1,0).rotated(90*direction))+componentPosition
		var input2 = Vector2i(Vector2(-1,-1).rotated(90*direction))+componentPosition
		var inputs = [input1,input2]
		return inputs
	elif selectedComponent == components.OR_GATE:
		var input1 = Vector2i(Vector2(-1,0).rotated(90*direction))+componentPosition
		var input2 = Vector2i(Vector2(-1,-1).rotated(90*direction))+componentPosition
		var inputs = [input1,input2]
		return inputs

func get_gate_output(selectedComponent,inputs = []):
	if selectedComponent == components.NOT_GATE:
		if false in inputs:
			return true
		else:
			return false
	if selectedComponent == components.AND_GATE:
		if false not in inputs:
			return true
		else:
			return false
	if selectedComponent == components.OR_GATE:
		if true in inputs:
			return true
		else:
			return false

func update_component_atlas(componentPosition = Vector2i(0,0),atlasCord = Vector2i(0,0)):
	if get_cell_atlas_coords(2,componentPosition) != atlasCord:
		set_cell(2,componentPosition,0,atlasCord)

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
	
