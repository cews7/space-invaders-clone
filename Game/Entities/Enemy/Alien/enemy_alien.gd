extends BaseEnemy

signal enemy_died

@onready var game: Node2D = get_tree().get_root().get_node("Game")
@onready var alien_projectile: PackedScene = load("res://Game/Entities/Projectile/Enemy/Alien/enemy_alien_projectile.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if is_able_to_shoot(delta):
		shoot()

func shoot() -> void:
	var projectile: Area2D = alien_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y + 5)
	projectile.spawn_rotation = rotation
	game.add_child.call_deferred(projectile)


func _on_area_entered(_area: Area2D) -> void:
	animation_player.play("Enemy Death")
	enemy_died.emit()