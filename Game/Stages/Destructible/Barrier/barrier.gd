extends Node2D 

# @onready var barrier_tile: TileMap = $BarrierTile  # Reference to the TileMap node

# # ID of the tiles
# const TILE_NON_DAMAGED: int = 0
# const TILE_DAMAGED: int = 1

# func _ready():
# 	# This function will be called when the node is added to the scene.
# 	pass

# # This function will be called when a projectile hits a tile in the TileMap
# func _on_projectile_hit(projectile_position: Vector2):
# 	# Convert the projectile position to the TileMap's local coordinates
# 	var local_position = barrier_tile.world_to_map(projectile_position)
	
# 	# Get the current tile at that position
# 	var current_tile = barrier_tile.get_cellv(local_position)
	
# 	if current_tile == TILE_NON_DAMAGED:
# 		# If the tile is non-damaged, replace it with the damaged tile
# 		barrier_tile.set_cellv(local_position, TILE_DAMAGED)
# 	elif current_tile == TILE_DAMAGED:
# 		# If the tile is already damaged, remove it
# 		barrier_tile.set_cellv(local_position, -1)
# 	print("test")
# 	# Optionally destroy the projectile after it hits the tile
# 	# projectile.queue_free()  # Assuming you pass the projectile node


func _on_barrier_hit(area):
	print("barrier hit!")
