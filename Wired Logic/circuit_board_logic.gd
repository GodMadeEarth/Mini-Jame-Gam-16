extends "res://tile_tools.gd"

var wireLayers : int = 2

var wireLayer1 = 2
var wireLayer2 = 3

var wireIndex = {}


#[off,on]
#[right,down,left,top] 

var indicatorLightAtlas = [Vector2i(16,1),Vector2i(17,1)]
var powerButtonAtlas = [Vector2i(16,0),Vector2i(17,0)]
var boltAtlas = [Vector2i(18,0)]
var notGateAtlas = [Vector2i(4,1),Vector2i(6,0),Vector2i(4,2),Vector2i(7,2)]
var andGateAtlas = [Vector2i(8,0),Vector2i(10,0),Vector2i(8,2),Vector2i(10,2)]
var orGateAtlas = [Vector2i(12,0),Vector2i(14,0),Vector2i(12,2),Vector2i(14,2)]

@onready var indicatorLightCords = cells_in_atlas(indicatorLightAtlas,1)
@onready var powerButtonCords = cells_in_atlas(powerButtonAtlas,1)
@onready var boltCords = cells_in_atlas(boltAtlas,1)
@onready var notGateCords = cells_in_atlas(notGateAtlas,1)
@onready var andGateCords = cells_in_atlas(andGateAtlas,1)
@onready var orGateCords = cells_in_atlas(orGateAtlas,1)


func _ready():
	componentUpdate()
	wireIndex[1] = 2

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var cellPos = local_to_map(get_local_mouse_position())
		if cellPos in powerButtonCords:
			if get_cell_atlas_coords(1,cellPos) == powerButtonAtlas[0]:
				update_cell_atlas(cellPos,1,2,powerButtonAtlas[1])
			elif get_cell_atlas_coords(1,cellPos) == powerButtonAtlas[1]:
				update_cell_atlas(cellPos,1,2,powerButtonAtlas[0])
			
			componentUpdate()

	

func wire_powered(wireList=[], wireLayer = int()):
	
	for point in wireList:
		
		# Powered Button Check
		if point in powerButtonCords:
			if get_cell_atlas_coords(1,point) == powerButtonAtlas[1]:
				return true

		elif point in boltCords:
			if total_peering_bits(point,wireLayer,1) == 1:
				if wireLayer != wireLayer1 and wire_powered(terrain_group(point,wireLayer1,1),wireLayer1):
					return true
				if wireLayer != wireLayer2 and wire_powered(terrain_group(point,wireLayer2,1),wireLayer2):
					return true

		elif point in notGateCords:
			
			var wire1Result
			
			var direction  =  notGateAtlas.find(get_cell_atlas_coords(1,point))
			
			if direction == 0:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y),wireLayer,1),wireLayer)
			elif direction == 1:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y-1),wireLayer,1),wireLayer)
			elif direction == 2:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y),wireLayer,1),wireLayer)
			elif direction == 3:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y+1),wireLayer,1),wireLayer)
			
			if wire1Result == false:
				return true

		elif point in andGateCords:
			
			var wire1Result
			var wire2Result
			
			var direction  =  andGateAtlas.find(get_cell_atlas_coords(1,point))
			
			if direction == 0:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y-1),wireLayer,1),wireLayer)
			elif direction == 1:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y-1),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y-1),wireLayer,1),wireLayer)
			elif direction == 2:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y+1),wireLayer,1),wireLayer)
			elif direction == 3:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y+1),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y+1),wireLayer,1),wireLayer)
			
			if wire1Result == true and wire2Result == true:
				return true

		elif point in orGateCords:
			var wire1Result
			var wire2Result
			
			var direction  =  orGateAtlas.find(get_cell_atlas_coords(1,point))
			
			if direction == 0:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y-1),wireLayer,1),wireLayer)
			elif direction == 1:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y-1),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y-1),wireLayer,1),wireLayer)
			elif direction == 2:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x+1,point.y+1),wireLayer,1),wireLayer)
			elif direction == 3:
				wire1Result = wire_powered(terrain_group(Vector2i(point.x,point.y+1),wireLayer,1),wireLayer)
				wire2Result = wire_powered(terrain_group(Vector2i(point.x-1,point.y+1),wireLayer,1),wireLayer)
			
			if wire1Result == true or wire2Result == true:
				return true


	return false


func componentUpdate():
	
	
	for cord in indicatorLightCords:
		
		
		if wire_powered(terrain_group(cord,wireLayer1,1),wireLayer1) or wire_powered(terrain_group(cord,wireLayer2,1),wireLayer2):
			update_cell_atlas(cord,1,2,indicatorLightAtlas[1])
		else:
			update_cell_atlas(cord,1,2,indicatorLightAtlas[0])
