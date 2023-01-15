extends Control



func init_mots():
	reset_mots()
	find_all_words()


func reset_mots() -> void:
	for child in $H/Mots.get_children():
		child.queue_free()


func find_all_words() -> void:
	$H/C/Pattern.init_all_anchors()


func add_mot() -> void:
	$H/C/Pattern.add_mot()


func generate_sequance() -> void:
	$H/C/Pattern.generate_sequance()
