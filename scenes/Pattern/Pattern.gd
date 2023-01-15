extends GridContainer
class_name Pattern

var cell_scene = preload("res://scenes/Cell/Cell.tscn")
var mot_scene = preload("res://scenes/Mot/Mot.tscn")

var cols = 3
var rows = 5

var cells = []
var sequance = []
var mots
var livre

func _ready():
	columns = cols
	init_empty_cells()
	generate_sequance()
	mots = get_parent().get_parent().get_node("Mots")
	livre = get_parent().get_node("Livre")


func init_empty_cells() -> void:
	for _i in cols:
		cells.append([])
		
		for _j in rows:
			var new_cell = cell_scene.instance()
			add_child(new_cell)
	
	for _i in rows:
		for _j in cols:
			var data = {}
			data.grid = Vector2(_j,_i)
			var cell = get_cell(data.grid)
			cell.set_data(data)
			
			for neighbor in Global.arr.neighbor:
				var neighbor_grid = data.grid+neighbor
				
				if check_border(neighbor_grid):
					var neighbor_cell = get_cell(neighbor_grid)
					cell.neighbors[neighbor] = neighbor_cell


func generate_sequance() -> void:
	reset_cells()
	sequance = []
	var grid = Vector2.ZERO
	var sequance_size = 5
	
	sequance.append(grid)
	
	while sequance.size() < sequance_size:
		var cell = get_cell(sequance.back())
		var options = []
		
		for key in cell.neighbors.keys():
			var neighbor_grid = cell.neighbors[key].grid
			
			if !sequance.has(neighbor_grid):
				options.append(neighbor_grid)
		
		if options.size() > 0:
			grid = Global.get_random_element(options)
			sequance.append(grid)
		else:
			bend()
	
	get_directions()


func reset_cells() -> void:
	for child in get_children():
		child.set_visible(false)


func bend() -> void:
	var options = []
	
	for _i in sequance.size()-1:
		var begin = get_cell(sequance[_i])
		var end = get_cell(sequance[_i+1])
		
		for begin_key in begin.neighbors.keys():
			var begin_neighbor = begin.neighbors[begin_key]
			
			for begin_neighbor_key in begin_neighbor.neighbors.keys():
				var end_neighbor = begin_neighbor.neighbors[begin_neighbor_key]
				
				for end_neighbor_key in end_neighbor.neighbors.keys():
					if end_neighbor.neighbors[end_neighbor_key] == end:
						options.append([begin,begin_neighbor,end_neighbor])
	
	var option = Global.get_random_element(options)
	print("bend",options)
	var index = sequance.find(option.pop_front())
	sequance.insert(index, option.back())
	sequance.insert(index, option.front())
	sequance.pop_front()


func get_directions() -> void:
	var directions = []
	
	for _i in sequance.size()-1:
		var current_cell = get_cell(sequance[_i])
		var next_cell = get_cell(sequance[_i+1])
		var direction = Vector2.ZERO
		
		for key in current_cell.neighbors.keys():
			if current_cell.neighbors[key] == next_cell:
				direction = key
				break
		
		var direction_index = Global.arr.neighbor.find(direction)
		directions.append(direction_index)
	
	for _i in sequance.size():
		var cell = get_cell(sequance[_i])
		var frame = 0
		var tail
		
		if _i > 0:
			tail = (directions[_i-1]+2)%Global.arr.neighbor.size()
			frame += (tail+1)*4
		if _i < directions.size():
			frame += directions[_i]
		else:
			frame = (tail+1)*5-1
		
		cell.set_visible(true)
		cell.set_frame(frame)


func add_mot(anchor_: Vector2) -> void:
	var new_mot = mot_scene.instance()
	
	for grid in sequance:
		var lettre = livre.get_lettre(grid+anchor_)
		new_mot.value += lettre.value
		new_mot.lettres.append(lettre)
	
	var dublicate = false
	
	for child in mots.get_children():
		if new_mot.value == child.value:
			dublicate = true
			break
	
	if !dublicate:
		mots.add_child(new_mot)
		new_mot.fill_lettres()


func init_all_anchors() -> Array:
	var anchors = []
	var min_grid = Vector2.ONE*max(rows,cols)
	var max_grid = Vector2.ZERO
	
	for grid in sequance:
		if grid.x > max_grid.x:
			max_grid.x = grid.x
		if grid.y > max_grid.y:
			max_grid.y = grid.y
		if grid.x < min_grid.x:
			min_grid.x = grid.x
		if grid.y < min_grid.y:
			min_grid.y = grid.y
	
	var sequance_size = max_grid-min_grid
	var shifts = +Vector2(cols,rows)-sequance_size
	
	for _i in shifts.x:
		for _j in shifts.y:
			var anchor = min_grid+Vector2(_i,_j)
			anchors.append(anchor)
			add_mot(anchor)
	
	return anchors

func get_cell(grid_: Vector2) -> Cell:
	var index = grid_.y*cols+grid_.x
	var cell = get_child(index)
	return cell


func check_border(grid_: Vector2) -> bool:
	var check = grid_.x >= 0 && grid_.x < cols && grid_.y >= 0 && grid_.y < rows
	return check
