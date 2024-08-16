extends CharacterBody2D

@export var SPEED : int = 500

var spawn_position : Vector2
var spawn_rotation : float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation

func _physics_process(delta):
	velocity = Vector2(0, -SPEED)
	move_and_slide()


func _on_life_span_timeout():
	queue_free()
