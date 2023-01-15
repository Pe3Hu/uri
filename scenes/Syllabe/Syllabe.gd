extends Control
class_name Syllable


const lettre_scene = preload("res://scenes/Lettre/Lettre.tscn")

var style = ""
var precedence = ""
var letters = []
#"AA","AB","BA","BB","AAA","AAB","ABA","ABB","BAA","BAB","BBA","BBB"
#	match style:
#		"Balance":
#			#"AA","BB
#			pass
#		"Imbalance":
#			#"AB","BA"
#			pass
#		"Symmetry":
#			#"AAA","ABA","BAB,"BBB"
#			pass
#		"Asymmetry":
#			#"AAB","ABB","BAA","BBA"
#			pass

func set_data(data_: Dictionary) -> void:
	$Lettres.columns = data_.frames.size()
	
	if $Lettres.columns == 2:
		$Lettres.rect_position.x += 32
	
	for frame in data_.frames:
		var new_lettre = lettre_scene.instance()
		new_lettre.set_frame(frame)
		letters.append(new_lettre.value)
		$Lettres.add_child(new_lettre)
	
	set_style()

func set_style() -> void:
	match letters.size():
		2:
			if $Lettres.get_children().front().vowel == $Lettres.get_children().back().vowel:
				style = "Balance"
			else:
				style = "Imbalance"
		3:
			if $Lettres.get_children().front().vowel == $Lettres.get_children().back().vowel:
				style = "Symmetry"
			else:
				style = "Asymmetry"
			
			$Sprite.frame += 4
	
	var grade = 1
	
	for _i in range($Lettres.get_child_count()-1,-1,-1):
		var consonant = $Lettres.get_child(_i).consonant
		
		if consonant:
			$Sprite.frame += grade
		
		grade *= 2
