extends Area2D

@export var SPEED : int = 500

var spawn_position : Vector2
var spawn_rotation : float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation

func _physics_process(delta):
	position.y += -SPEED * delta

func _on_life_span_timeout():
	queue_free()

func _on_area_entered(area:Area2D):
	queue_free()
