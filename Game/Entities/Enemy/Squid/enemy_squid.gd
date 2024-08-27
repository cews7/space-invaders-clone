extends BaseEnemy

@onready var game: Node2D = get_tree().get_root().get_node("Game")
@onready var squid_projectile: PackedScene = load("res://Game/Entities/Projectile/Enemy/Squid/enemy_squid_projectile.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if is_able_to_shoot(delta):
		shoot()

func shoot() -> void:
	var projectile: Area2D = squid_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y + 5)
	projectile.spawn_rotation = rotation
	game.add_child.call_deferred(projectile)


func _on_area_entered(_area: Area2D) -> void:
	animation_player.play("Enemy Death")
