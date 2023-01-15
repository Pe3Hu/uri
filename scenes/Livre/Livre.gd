extends GridContainer
class_name Livre

const lettre_scene = preload("res://scenes/Lettre/Lettre.tscn")

var cols = 3
var rows = 5

var lettres = []

func _ready():
	columns = cols
	init_empty_lettres()
	fill_livre()


func init_empty_lettres() -> void:
	for _i in cols:
		lettres.append([])
		
		for _j in rows:
			var data = {}
			data.grid = Vector2(_i,_j)
			var new_lettre = lettre_scene.instance()
			new_lettre.set_data(data)
			add_child(new_lettre)


func spawn_lettre(col_: int) -> void:
	var vocabulary = ["A","B","B","B"]
	var letter = Global.get_random_element(vocabulary)
	var frame_index = Global.ALPHABET.find(letter)+Global.NUMBER_SHIFT
	var grid = Vector2(col_,rows-1)
	var direction = Vector2(0,-1)
	var new_grid = lift_column(grid, direction, true)
	
	if lettres[new_grid.x].size() < rows:
		lettres[new_grid.x].append(new_grid)
	
	get_lettre(grid).set_frame(frame_index) 


func lift_column(grid_: Vector2, direction_: Vector2, forse_: bool) -> Vector2:
	var next = Vector2(grid_.x,0)
	
	if direction_.y == 1:
		next.y += rows-1
	
	for _i in rows-1:
		var lettre = get_lettre(next)
		
		if lettre.get_frame() >= Global.ALPHABET_END || forse_:
			swap_lettres([lettre, get_lettre(next-direction_)])
			
		next -= direction_
	
	var result = grid_
	
	if lettres[grid_.x].size() > 0:
		result.y -= lettres[grid_.x].size()
	
	return result


func swap_lettres(lettres_: Array) -> void:
	var frame  = lettres_.front().get_frame()
	lettres_.front().set_frame(lettres_.back().get_frame())
	lettres_.back().set_frame(frame)


func get_lettre(grid_: Vector2) -> Lettre:
	var index = grid_.y*cols+grid_.x
	var lettre = get_child(index)
	return lettre


func budge_lettre(grid_: Vector2, direction_: Vector2) -> void:
	if check_budge(grid_, direction_):
		swap_lettres([get_lettre(grid_), get_lettre(grid_+direction_)])
		lettres[grid_.x].erase(grid_)
		lettres[grid_.x+direction_.x].append(grid_+direction_)
		fall_column(grid_) 
		fall_column(grid_+direction_) 


func fall_column(grid_: Vector2) -> void:
	var direction = Vector2(0,1)
	var col = lettres[grid_.x]
	
	for _i in rows-1-grid_.y:
		 lift_column(Vector2(grid_.x,0), direction, false)
	
	if col.size() == 1:
		col[0].y = rows-1
	else:
		for _i in col.size()-1:
			while col[_i].y > col[_i+1].y+1:
				col[_i+1].y += 1


func fill_livre() -> void:
	var stop = false
	
	while !stop:
		var options = []
		
		for _i in lettres.size():
			for _j in rows-lettres[_i].size():
				options.append(_i)
		
		stop = options.size() == 0
		
		if !stop:
			var col = Global.get_random_element(options)
			spawn_lettre(col)


func check_budge(grid_: Vector2, direction_: Vector2) -> bool:
	var budged = grid_+direction_
	
	if !check_border(budged):
		return false
	
	var check = rows-lettres[budged.x].size() > grid_.y
	return check


func check_border(grid_: Vector2) -> bool:
	var check = grid_.x >= 0 && grid_.x < cols && grid_.y >= 0 && grid_.y < rows
	return check


func _input(event):
#	if event is InputEventMouseButton:
#		Global.mouse_pressed = !Global.mouse_pressed
#
#		if Global.mouse_pressed:
#			pass
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_S:
			budge_lettre(Vector2(0,2),Vector2(1,0))
