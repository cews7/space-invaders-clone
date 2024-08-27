extends Area2D
class_name BaseEnemyProjectile

@export var speed : int = 300

var spawn_position : Vector2
var spawn_rotation : float

func _ready() -> void:
	position = spawn_position
	rotation = spawn_rotation


func _physics_process(delta: float) -> void:
	position.y += speed * delta


func _on_life_span_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		queue_free()
		body.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BarrierArea":
		queue_free()
