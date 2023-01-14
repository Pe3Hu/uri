extends GridContainer
class_name Mot


const lettre_scene = preload("res://scenes/Lettre/Lettre.tscn")

var cols = 5
var lettres = []
var anchor: Vector2 = Vector2.ZERO
var livre: GridContainer


func _ready():
	columns = cols
	livre = get_parent().get_node("Livre")
	init_empty_lettres()


func init_empty_lettres() -> void:
	for _i in cols:
		var new_lettre = lettre_scene.instance()
		add_child(new_lettre)


func fill_lettres():
	for _i in get_child_count():
		var child = get_child(_i)
		child.set_frame(lettres[_i].get_frame())
		print(lettres[_i].get_frame())
