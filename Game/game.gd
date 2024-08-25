extends Node

@export var enemy_move_speed: float = 12
@export var spacing_x: float = 40
@export var spacing_y: float = 40
@export var start_position_x: float = 30
@export var start_position_y: float = 172

const EnemySquidScn = preload("res://Game/Entities/Enemy/Squid/enemy_squid.tscn")
const EnemyAlienScn = preload("res://Game/Entities/Enemy/Alien/enemy_alien.tscn")
const EnemyJellyfishScn = preload("res://Game/Entities/Enemy/Jellyfish/enemy_jellyfish.tscn")

var move_direction: Vector2 = Vector2(1, 0)
var move_down_amount: float = 40
var screen_bounds: Vector2 = Vector2(550, 828)

var enemy_types : Array = [EnemySquidScn, EnemyAlienScn, EnemyJellyfishScn]
var enemy_layout : Array = [
	[0,0,0,0,0,0,0,0,0,0,0], # 11 enemy squid
	[1,1,1,1,1,1,1,1,1,1,1], # 11 enemy alien
	[1,1,1,1,1,1,1,1,1,1,1], # 11 enemy alien
	[2,2,2,2,2,2,2,2,2,2,2], # 11 enemy jellyfish
	[2,2,2,2,2,2,2,2,2,2,2], # 11 enemy jellyfish
]

func _ready() -> void:
	var start_spawn_vector: Vector2 = Vector2(start_position_x, start_position_y)
	var spacing: Vector2 = Vector2(spacing_x, spacing_y)

	for row_index: int in range(enemy_layout.size()):
		for col_index: int in range(enemy_layout[row_index].size()):
			var enemy_type = enemy_layout[row_index][col_index]
			var enemy_scene = enemy_types[enemy_type].instantiate()

			var position = start_spawn_vector + Vector2(col_index * spacing.x, row_index * spacing.y)

			enemy_scene.position = position
			add_child(enemy_scene)
			# Assign enemy scene to 'enemies' group
			enemy_scene.add_to_group("enemies")


func _process(delta) -> void:
	var should_move_down: bool = false

	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.position += move_direction * enemy_move_speed * delta
		# Check if enemy hits edge of screen 
		if enemy.position.x <= 20 or enemy.position.x >= screen_bounds.x - 20:
			should_move_down = true
		
	if should_move_down:
		move_direction.x *= -1 # Reverse horizontal direction
		enemy_move_speed += 3.5
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.position.y += move_down_amount

