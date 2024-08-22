extends CharacterBody2D

@onready var game = get_tree().get_root().get_node("Game")
@onready var player_projectile = load("res://Game/Entities/Projectiles/Player Projectile/player_projectile.tscn")

const SPEED = 300.0
var screen_size
var timer : float
var can_shoot : bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	timer = 0
	can_shoot = false
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_move_left", "player_move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Make sure we are within the screen
	position = position.clamp(Vector2.ZERO, screen_size)

	if is_able_to_shoot(delta):
		shoot()

	move_and_slide()

func is_able_to_shoot(delta) -> bool:
	if Input.is_action_pressed("shoot_laser"):
		if timer >= .7:
			can_shoot = true
			timer = 0
		else:
			can_shoot = false
	timer += delta
	return can_shoot


func shoot():
	var projectile = player_projectile.instantiate()
	projectile.spawn_position = Vector2(position.x, position.y - 5)
	projectile.spawn_rotation = rotation
	game.add_child.call_deferred(projectile)

