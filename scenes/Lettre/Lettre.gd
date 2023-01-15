extends Control
class_name Lettre


var grid = Vector2.ZERO
var vowel = false
var consonant = false
var value = ""


func set_frame(frame_: int) -> void:
	var index = frame_-Global.NUMBER_SHIFT
	
	if index >= 0 && index < Global.ALPHABET.size():
		value = Global.ALPHABET[index]
	
	vowel = Global.VOWELS.has(value)
	consonant = Global.CONSONANTS.has(value)
	
	$Sprite.frame = frame_


func get_frame() -> int:
	return $Sprite.frame


func set_data(data_: Dictionary) -> void:
	grid = data_.grid
