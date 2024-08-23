extends Area2D

@export var speed : int = 500

var spawn_position : Vector2
var spawn_rotation : float

func _ready():
	# projectile fires at start of game if we use position instead of global_position ??
	global_position = spawn_position
	rotation = spawn_rotation

func _physics_process(delta):
	position.y += -speed * delta

func _on_life_span_timeout():
	queue_free()

func _on_area_entered(area:Area2D):
	queue_free()
