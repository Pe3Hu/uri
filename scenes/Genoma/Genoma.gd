extends Node2D
class_name Genoma


var a = 100
var block_size = 10
var n = 2
var gene_width = 5


func _ready():
	var shfit = 0
	set_sin_curve($Left, shfit)
	shfit = 1
	set_sin_curve($Right, shfit)
	add_genes()


func set_sin_curve(line_: Line2D, shfit_: int) -> void:
	line_.width = 3
	line_.default_color = Color.black
	var dots = []
	var k = 3+(n*2-1)*2
	var x = a
	var y = a/k*2
	var angle = PI*2/(k-1)
	
	if shfit_ == 1:
		shfit_ += k/2
	
	for _i in k:
		var dot = Vector2(sin(angle*(_i+shfit_))*x,_i*y)
		dot.x += 2*x
		line_.add_point(dot)


func add_genes() -> void:
	var xs = []
	var sum = 0
	
	for _i in $Left.points.size():
		var x = floor(abs($Left.points[_i].x - $Right.points[_i].x)/block_size)
		#x /= a
		xs.append(x)
		sum += x
	
	for x in xs:
		x /= 5
	print(xs.size(),sum)


func _draw():
	for _i in $Right.points.size():
		draw_line($Left.points[_i], $Right.points[_i], Color.white, gene_width)
