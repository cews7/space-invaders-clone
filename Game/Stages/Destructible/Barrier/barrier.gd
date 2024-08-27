extends Node2D 

@onready var barrier_tile: TileMap = $BarrierTile  # Reference to the TileMap node

# ID of the tiles
const TILE_NON_DAMAGED: int = 0
const TILE_DAMAGED: int = 1


func _on_barrier_hit(area: Area2D) -> void:
	var tile_position: Vector2i = barrier_tile.local_to_map(to_local(area.global_position))
	# this is to account for a bug where y == 0 and therefore not getting the source_id for tile
	tile_position.y = -1
	var current_tile_id: int = barrier_tile.get_cell_source_id(0, tile_position)
	
	if current_tile_id == TILE_NON_DAMAGED:
		barrier_tile.erase_cell(0, tile_position)
		barrier_tile.set_cell(0, tile_position, TILE_DAMAGED, Vector2i(0, 0))
	elif current_tile_id == TILE_DAMAGED: 
		barrier_tile.erase_cell(0, tile_position)
		queue_free()
