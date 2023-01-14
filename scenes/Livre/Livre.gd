extends GridContainer
class_name Livre

var lettre_scene = preload("res://scenes/Lettre/Lettre.tscn")

var cols = 3
var rows = 5
const NUMBER_SHIFT = 10
const ALPHABET_END = 43
var num = 0

var lettres = []

func _ready():
	columns = cols
	init_empty_lettres()


func init_empty_lettres() -> void:
	for _i in cols:
		lettres.append([])
		
		for _j in rows:
			var data = {}
			data.grid = Vector2(_i,_j)
			var new_lettre = lettre_scene.instance()
			new_lettre.set_data(data)
			#lettres[_i].append(new_lettre)
			add_child(new_lettre)


func spawn_lettre() -> void:
	var col = 0#select_random_column()
	var vocabulary = ["A","B","B"]
	var letter = Global.get_random_element(vocabulary)
	var frame_index = num#Global.ALPHABET.find(letter)+NUMBER_SHIFT
	var grid = Vector2(col,rows-1)
	var direction = Vector2(0,-1)
	var new_grid = lift_column(grid, direction)
	
	
	if lettres[new_grid.x].size() < rows:
		lettres[new_grid.x].insert(0,new_grid)
	
	get_lettre(grid).set_frame(frame_index) 
	
	num+=1
	
	if num >= NUMBER_SHIFT:
		num = 0
	
	print(lettres)


func select_random_column() -> int:
	var lettre = Global.get_random_element(lettres.front())
	return lettre.grid.x


func lift_column(grid_: Vector2, direction_: Vector2) -> Vector2:
	var next = grid_
	var frame_index = get_lettre(next).get_frame()
	
	if frame_index >= ALPHABET_END:
		return grid_
	
	next += direction_
	var d = get_lettre(next)
	frame_index = get_lettre(next).get_frame()
	
	while check_border(next) && frame_index < ALPHABET_END:
		next += direction_
		
		if check_border(next):
			frame_index = get_lettre(next).get_frame()
	
	if !check_border(next):
		next -= direction_
	
	var result = next
	
	while check_border(next-direction_):
		lift_lettre(next, direction_)
		next -= direction_
	
	return result


func lift_lettre(next_: Vector2, direction_: Vector2)  -> void:
	var previous = next_-direction_
	var frame_index = get_lettre(previous).get_frame()
	get_lettre(next_).set_frame(frame_index) 


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
		
		if Global.mouse_pressed:
			spawn_lettre()


func get_lettre(grid_: Vector2) -> Lettre:
	var index = grid_.y*cols+grid_.x
	var lettre = get_child(index)
	return lettre


func budge_lettre(grid_: Vector2, direction_: Vector2) -> void:
	if check_budge(grid_, direction_):
		fall_column(grid_) 
		fall_column(grid_+direction_) 


func fall_column(grid_: Vector2) -> void:
	var col = lettres[grid_.x]
	print(col)
	
	while col.back().y != col.size():
		for _i in range(grid_.y, col.size()-1, 1):
			col[_i].y -= 1
		print(col)


func check_budge(grid_: Vector2, direction_: Vector2) -> bool:
	var budged = grid_+direction_
	
	if !check_border(budged):
		return false
	
	var check = lettres[budged.x].size() < grid_.y
	return check


func check_border(grid_: Vector2) -> bool:
	var check = grid_.x >= 0 && grid_.x < cols && grid_.y >= 0 && grid_.y < rows
	return check
