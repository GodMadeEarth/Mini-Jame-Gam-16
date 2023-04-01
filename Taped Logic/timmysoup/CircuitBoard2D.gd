extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	print(tiles_connect())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_components_of_type(atlasCord = Vector2i(0,1)):
	var components = get_used_cells(0)
	var selectedComponents = []
	for component in components:
		if get_cell_atlas_coords(2,component) == atlasCord:
			selectedComponents.append(component)
	return selectedComponents

func emit_power(cellPosition = Vector2i(0,1)):
	get_cell_tile_data(1,cellPosition).set_custom_data("powerPathing",1)
	
func  tiles_connect(cell1Position = Vector2i(1,1),cell2Position = Vector2i(0,0)):
	return get_cell_tile_data(1,cell1Position).get_terrain_peering_bit(11)
