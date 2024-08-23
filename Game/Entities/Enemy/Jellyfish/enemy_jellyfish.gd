extends BaseEnemy

@onready var game = get_tree().get_root().get_node("Game")
@onready var jellyfish_projectile = load("res://Game/Entities/Projectile/Enemy/Jellyfish/enemy_jellyfish_projectile.tscn")

func _physics_process(delta) -> void:
	if is_able_to_shoot(delta):
		shoot()

func shoot() -> void:
	var projectile = jellyfish_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y + 5)
	projectile.spawn_rotation = rotation
	game.add_child.call_deferred(projectile)