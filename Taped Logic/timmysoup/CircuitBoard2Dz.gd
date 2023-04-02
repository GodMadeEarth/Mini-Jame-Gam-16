extends TileMap



func _ready():
	pass
	#print(get_wire_group(Vector2i(0,0)))

func _process(delta):
	pass

func get_components_of_type(atlasCord = Vector2i(0,1)):
	var components = get_used_cells(2)
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

func get_wire_group(rootCellPosition = Vector2i(0,1)): #creates an array of all the positions for start?
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



func _on_button_pressed():
	####SETUP###################
	## OFF
	var offButtonLoc = Vector2i(0,0) #RED POWER
	var offEndLoc = Vector2i(0,1) #RED node
	## ON
	var onButtonLoc = Vector2i(1,0) #GREEN POWER
	var onEndLoc = Vector2i(1,1) #GREEN node
	##ARRAY MAKER
	var powerButtonOffArray := []
	var powerButtonOnArray := []
	var circuitWireArray :=[]
	var circuitTerminationOffArray := []
	var circuitTerminationOnArray :=[]
	#######################################
	
	##OFF BUTTON + OFF END POINT INTO ARRAYS
	powerButtonOffArray.append_array(get_components_of_type(offButtonLoc))
	circuitTerminationOffArray.append_array(get_components_of_type(offEndLoc))
		
	##ON BUTTON + ON END POINT INTO ARRAYS
	powerButtonOnArray.append_array(get_components_of_type(onButtonLoc))
	circuitTerminationOnArray.append_array(get_components_of_type(onEndLoc))
	
	#print(get_wire_group(powerButtonOffArray[0]))
	#circuitWireArray.append(temp)


	
	print("###Power Buttons in the OFF STATE location###")
	print(powerButtonOffArray)
	print("\n")
	print("###End Points in the OFF STATE location###")
	print(circuitTerminationOffArray)
	
	pass # Replace with function body.

func update_cells_atlas(cellPositions = [Vector2i(0,0)],atlasCord = Vector2i(0,0)):
	for cellPosition in cellPositions:
		if get_cell_atlas_coords(2,cellPosition) != atlasCord:
			set_cell(2,cellPosition,0,atlasCord)
