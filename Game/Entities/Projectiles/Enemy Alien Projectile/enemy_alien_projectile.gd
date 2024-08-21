extends Area2D

@export var speed : int = 500

var spawn_position : Vector2
var spawn_rotation : float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation

func _physics_process(delta):
	position.y += speed * delta

func _on_life_span_timeout():
	queue_free()

func _on_body_entered(body:Node2D):
	if body.name == "Player":
		queue_free()
