extends Area2D

@onready var game = get_tree().get_root().get_node("Game")
@onready var alien_projectile = load("res://Game/Entities/Projectiles/Enemy Alien Projectile/enemy_alien_projectile.tscn")

var reload_time : float
var is_reload_time_complete : bool

func _ready() -> void:
	reload_time = 0


func _physics_process(delta) -> void:
	if is_able_to_shoot(delta):
		shoot()


func is_able_to_shoot(delta) -> bool:
	return reload_time_elapsed(delta) and has_line_of_sight()
		

func reload_time_elapsed(delta) -> bool:
	if reload_time >= 1:
		is_reload_time_complete = true
		reload_time = 0
	else:
		is_reload_time_complete = false
	reload_time += delta
	return is_reload_time_complete


func reload_attempt_successful() -> bool:
	var num = 1
	var rand_num = randi_range(0, 10)
	if num == rand_num:
		return true
	return false

func has_line_of_sight() -> bool:
	# print($LOSCheck.has_overlapping_areas())
	return not $LOSCheck.has_overlapping_areas()


func shoot() -> void:
	var projectile = alien_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y + 5)
	projectile.spawn_rotation = rotation
	game.add_child.call(projectile)


func _on_area_entered(area:Area2D):
	queue_free()
