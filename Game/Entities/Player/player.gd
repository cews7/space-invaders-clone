extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game: Node2D = get_tree().get_root().get_node("Game")
@onready var player_projectile: PackedScene = load("res://Game/Entities/Projectile/Player/player_projectile.tscn")

const SPEED: float = 150.0
var can_shoot: bool
var screen_size: Vector2
var timer: float

func _ready() -> void:
	timer = 0
	can_shoot = false
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("player_move_left", "player_move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Make sure we are within the screen
	position = position.clamp(Vector2.ZERO, screen_size)

	if is_able_to_shoot(delta):
		shoot()

	move_and_slide()


func is_able_to_shoot(delta: float) -> bool:
	if Input.is_action_pressed("shoot_laser"):
		if timer >= .7:
			can_shoot = true
			timer = 0
		else:
			can_shoot = false
	timer += delta
	return can_shoot


func shoot() -> void:
	var projectile: Area2D = player_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y - 5)
	projectile.spawn_rotation = rotation
	game.add_child.call_deferred(projectile)
	animation_player.play("Player Projectile Fired")


func handle_death() -> void:
	animation_player.play("Player Death")
	if get_parent().player_lives_remaining > 0:
		get_parent().player_lives_remaining -= 1

