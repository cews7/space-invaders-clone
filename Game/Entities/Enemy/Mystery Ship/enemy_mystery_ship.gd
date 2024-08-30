extends Area2D

signal died

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_entered(_area: Area2D) -> void:
	animation_player.play("Enemy Death")
	died.emit("mystery ship")


func calc_score_value() -> int:
	var score_value: int = randi_range(100, 200)
	return score_value