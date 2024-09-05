extends Node

@export var enemy_mystery_ship_move_speed: float = 75
@export var enemy_move_speed: float = 8
@export var mystery_ship_start_position: Vector2 = Vector2(-489, 100)
@export var spacing_x: float = 40
@export var spacing_y: float = 40
@export var start_position_x: float = 30
@export var start_position_y: float = 172

var enemy_count: int = 0

@onready var high_score_label: RichTextLabel = $"UserInterface/HighScoreLabel"
@onready var player_lives_label: RichTextLabel = $"UserInterface/PlayerLivesLabel"
@onready var score_label: RichTextLabel = $"UserInterface/ScoreLabel"

const ALIEN: String = "alien"
const JELLYFISH: String = "jellyfish"
const SQUID: String = "squid"
const MYSTERY_SHIP: String = "mystery ship"

const EnemySquidScn: PackedScene = preload("res://Game/Entities/Enemy/Squid/enemy_squid.tscn")
const EnemyAlienScn: PackedScene = preload("res://Game/Entities/Enemy/Alien/enemy_alien.tscn")
const EnemyJellyfishScn: PackedScene = preload("res://Game/Entities/Enemy/Jellyfish/enemy_jellyfish.tscn")
const EnemyMysteryShipScn: PackedScene = preload("res://Game/Entities/Enemy/Mystery Ship/enemy_mystery_ship.tscn")
const GameOverScn: PackedScene = preload("res://Game/UI/game_over.tscn")
const TitleScn: PackedScene = preload("res://Game/UI/title.tscn")

var basic_enemy_move_direction: Vector2 = Vector2(1, 0)
var game_title: Node2D
var player_lives_remaining: int = 3
var mystery_ship: Area2D
var mystery_ship_enemy_move_direction: Vector2 = Vector2(1, 0)
var move_down_amount: float = 40
var score: int = 0
var screen_bounds: Vector2 = Vector2(550, 828)
var show_player_lives: bool

var enemy_types : Array = [EnemySquidScn, EnemyAlienScn, EnemyJellyfishScn]
var enemy_layout : Array = [
	[0,0,0,0,0,0,0,0,0,0,0], # 11 enemy squid
	[1,1,1,1,1,1,1,1,1,1,1], # 11 enemy alien
	[1,1,1,1,1,1,1,1,1,1,1], # 11 enemy alien
	[2,2,2,2,2,2,2,2,2,2,2], # 11 enemy jellyfish
	[2,2,2,2,2,2,2,2,2,2,2], # 11 enemy jellyfish
]

func _ready() -> void:
	new_game() if Global.show_game_launcher else restart_game()


func _process(delta: float) -> void:
	if show_player_lives:
		load_game_text("player lives")

	var should_move_down: bool = false
	
	# Check to see if mystery ship has been freed from scene
	if mystery_ship != null:
		mystery_ship_movement_pattern(delta)

	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.position += basic_enemy_move_direction * enemy_move_speed * delta
		# Check if enemy hits edge of screen 
		if enemy.position.x <= 20 or enemy.position.x >= screen_bounds.x - 20:
			should_move_down = true
		
	if should_move_down:
		basic_enemy_move_direction.x *= -1 # Reverse horizontal direction
		enemy_move_speed += 1.5
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.position.y += move_down_amount

	if player_lives_remaining == 0:
		Global.show_game_launcher = false
		show_game_over()


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().paused = true


func create_enemies() -> void:
	var start_spawn_vector: Vector2 = Vector2(start_position_x, start_position_y)
	var spacing: Vector2 = Vector2(spacing_x, spacing_y)

	for row_index: int in range(enemy_layout.size()):
		for col_index: int in range(enemy_layout[row_index].size()):
			var enemy_type: int = enemy_layout[row_index][col_index]
			var enemy: Area2D = enemy_types[enemy_type].instantiate()

			var position: Vector2 = start_spawn_vector + Vector2(col_index * spacing.x, row_index * spacing.y)
			enemy_count += 1
			enemy.position = position
			add_child(enemy)

			# connect enemy died signal to track score and enemy count
			enemy.enemy_died.connect(handle_enemy_death)
			
			# Assign enemy scene to 'enemies' group
			enemy.add_to_group("enemies")


func create_mystery_ship() -> void:
	mystery_ship = EnemyMysteryShipScn.instantiate()
	add_child(mystery_ship)

	mystery_ship.died.connect(handle_enemy_death)

	mystery_ship.position = mystery_ship_start_position


func load_game() -> void:
	create_mystery_ship()
	create_enemies()
	load_game_text()
	show_player_lives = true


func load_game_text(type: String = "all") -> void:
	if type == "all":
		high_score_label.text = "High Score:" + "[color=#62E707]" + str(Global.save_data.high_score) + "[/color]"
		score_label.text = "Score:" + "[color=#62E707]" + str(score) + "[/color]"
		player_lives_label.text = "Lives: " + "[color=#62e707]" + str(player_lives_remaining) + "[/color]"
	elif type == "player lives":
		player_lives_label.text = "Lives: " + "[color=#62e707]" + str(player_lives_remaining) + "[/color]"

func new_game() -> void:
	game_title = TitleScn.instantiate()
	add_child(game_title)
	game_title.new_game.connect(start_game)


func mystery_ship_movement_pattern(delta: float) -> void:
	mystery_ship.position += mystery_ship_enemy_move_direction * enemy_mystery_ship_move_speed * delta

	if mystery_ship.position.x <= -489 or mystery_ship.position.x >= 900:
		mystery_ship_enemy_move_direction.x *= -1


func handle_enemy_death(enemy: String) -> void:
	match enemy:
		ALIEN:
			enemy_count -= 1
			score += 20
		JELLYFISH:
			enemy_count -= 1
			score += 10
		MYSTERY_SHIP:
			score += mystery_ship.calc_score_value()
		SQUID: 
			enemy_count -= 1
			score += 40
	if score > Global.save_data.high_score:
		Global.save_data.high_score = score
		Global.save_data.save()
		high_score_label.text = "[color=#62E707]" + "NEW HIGH SCORE!" + "[/color]"

	score_label.text = "Score:" + "[color=#62E707]" + str(score) + "[/color]"

	# redraw enemies in scene if all are defeated
	if enemy_count == 0:
		# increase difficulty each new round
		enemy_move_speed += 2
		# ensure new enemy doesn't spawn on top of old enemy
		await get_tree().create_timer(2).timeout
		create_enemies()


func show_game_over() -> void:
	var game_over: Control = GameOverScn.instantiate()
	add_child(game_over)

	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()


func restart_game() -> void:
	load_game()


func start_game() -> void:
	load_game()
	game_title.queue_free()
