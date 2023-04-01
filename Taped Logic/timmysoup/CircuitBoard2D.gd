extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_cell_tile_data(1,get_components_of_type(Vector2i(1,0))[0]).terrain)


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
	
func  tiles_connect(cell1Position = Vector2i(0,1),cell2Position = Vector2i(0,1)):
	get_cell_tile_data(1,cell1Position).terrain
