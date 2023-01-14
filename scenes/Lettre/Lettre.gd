extends Control
class_name Lettre


var grid = Vector2.ZERO


func set_frame(frame_: int) -> void:
	$Sprite.frame = frame_


func get_frame() -> int:
	return $Sprite.frame


func set_data(data_: Dictionary) -> void:
	grid = data_.grid






