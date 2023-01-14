extends Control
class_name Mot


const lettre_scene = preload("res://scenes/Lettre/Lettre.tscn")

var cols = 5
var anchor: Vector2 = Vector2.ZERO

var lettres = []
var permutations = []


func _ready():
	$Permutations/Word.columns = cols
	init_empty_lettres()


func init_empty_lettres() -> void:
	for _i in cols:
		var new_lettre = lettre_scene.instance()
		$Permutations/Word.add_child(new_lettre)


func fill_lettres() -> void:
	for _i in lettres.size():
		var child = $Permutations/Word.get_child(_i)
		child.set_frame(lettres[_i].get_frame())
	
	var sizes = get_all_sizes()
	get_all_syllabes(sizes)


func get_all_sizes() -> Array:
	var result = []
	var sizes = []
	var total_size = 0
	var min_size = Global.SYLLABLE_SIZES.front()
	var max_size = Global.SYLLABLE_SIZES.back()
	var min_count = cols/Global.SYLLABLE_SIZES.back()
	
	while total_size < cols:
		sizes.append(min_size)
		total_size += min_size
	
	if total_size > cols:
		sizes.pop_front()
		sizes.pop_front()
		sizes.append(max_size)
	
	
	while sizes.size() > min_size && sizes[2] != max_size:
		
		if sizes[2] == min_size:
			var tmp = []
			tmp.append_array(sizes)
			result.append(tmp)
			sizes.pop_front()
			sizes.pop_front()
			sizes.pop_front()
			sizes.append(max_size)
			sizes.append(max_size)
	
	
	result.append(sizes)
	return result 


func get_all_syllabes(sizes_: Array) -> void:
	permutations = []
	
	for sizes in sizes_:
		permutations.append_array(Global.get_all_perms(sizes))
