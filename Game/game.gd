extends Node

@export var move_speed = 50
@export var spacing_x: float = 40
@export var spacing_y: float = 40
@export var start_position_x: float = 183
@export var start_position_y: float = 172

const EnemySquidScn = preload("res://Game/Entities/Enemies/Enemy Squid/enemy_squid.tscn")
const EnemyAlienScn = preload("res://Game/Entities/Enemies/Enemy Alien/enemy_alien.tscn")
const EnemyJellyfishScn = preload("res://Game/Entities/Enemies/Enemy Jellyfish/enemy_jellyfish.tscn")

var move_direction = Vector2(1, 0)
var move_down_amount = 40
var screen_bounds = Vector2(750, 828)

var enemy_types : Array = [EnemySquidScn, EnemyAlienScn, EnemyJellyfishScn]
var enemy_layout : Array = [
	[0,0,0,0,0,0,0,0,0,0], # 10 enemy squid
	[1,1,1,1,1,1,1,1,1,1], # 10 enemy alien
	[1,1,1,1,1,1,1,1,1,1], # 10 enemy alien
	# [2,2,2,2,2,2,2,2,2,2], # 10 enemy jellyfish
	# [2,2,2,2,2,2,2,2,2,2], # 10 enemy jellyfish
]
func _ready() -> void:
	var start_spawn_vector = Vector2(start_position_x, start_position_y)
	var spacing = Vector2(spacing_x, spacing_y)
	for row_index in range(enemy_layout.size()):
		for col_index in range(enemy_layout[row_index].size()):
			var enemy_type = enemy_layout[row_index][col_index]
			var enemy_scene = enemy_types[enemy_type].instantiate()

			var position = start_spawn_vector + Vector2(col_index * spacing.x, row_index * spacing.y)

			enemy_scene.position = position
			add_child(enemy_scene)

func _process(delta) -> void:
	var should_move_down = false

	for enemy in get_children().filter(func(child): return child is Area2D):
		enemy.position += move_direction * move_speed * delta
		# Check if enemy hits edge of screen 
		if enemy.position.x <= 50 or enemy.position.x >= screen_bounds.x:
			should_move_down = true
		
	if should_move_down:
		move_direction.x *= -1 # Reverse horizontal direction
		for enemy in get_children().filter(func(child): return child is Area2D):
			enemy.position.y += move_down_amount
