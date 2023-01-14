extends Node


func _ready():
	Global.obj.map = Classes_Map.Map.new()
	$Pattern.fill_mot()
#	Global.rng.randomize()
#	var index_r = Global.rng.randi_range(0, options.size()-1)
	
#	datas.sort_custom(Sorter, "sort_ascending")
	
#	var path = "res://json/"
#	var name_ = "name"
#	var data = ""
#	Global.save_json(data,path,name_)


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
		
		if Global.mouse_pressed:
			$Pattern.generate_sequance()
			$Pattern.fill_mot()
		
		if Global.flag.click:
			if Global.obj.keys().has("map"):
				Global.next_rank()
			Global.flag.click = !Global.flag.click
		else:
			Global.flag.click = !Global.flag.click


func _process(delta):
	pass

func _on_Timer_timeout():
	Global.node.TimeBar.value +=1
	
	if Global.node.TimeBar.value >= Global.node.TimeBar.max_value:
		Global.node.TimeBar.value -= Global.node.TimeBar.max_value
