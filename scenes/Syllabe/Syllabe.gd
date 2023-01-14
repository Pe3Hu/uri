extends Control
class_name Syllable


var style = ""
var precedence = ""
var value = ""
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


func set_value(value_: String) -> void:
	letters = []
	value = value_
	
	for letter in value:
		letters.append(letter)
	
	set_style()

func set_style() -> void:
	match letters.size():
		2:
			if letters.front().vowel == letters.back().vowel:
				style = "Balance"
			else:
				style = "Imbalance"
		3:
			if letters.front().vowel == letters.back().vowel:
				style = "Symmetry"
			else:
				style = "Asymmetry"
	
	
