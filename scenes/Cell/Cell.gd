extends Control
class_name Cell

var grid = Vector2.ZERO
var neighbors = {}


func set_frame(frame_: int) -> void:
	$Sprite.frame = frame_


func get_frame() -> int:
	return $Sprite.frame


func set_visible(flag_: bool) -> void:
	$Sprite.visible = flag_


func set_data(data_: Dictionary) -> void:
	grid = data_.grid
