extends Node3D

const ROT_ANGLE = deg_to_rad(90)

@onready var pivot_right = %PivotRight
@onready var pivot_left = %PivotLeft
@onready var pivot_yaw = %PivotYaw
@onready var pos_matrix = PosMatrix.new([%A5, %A6, %A7, %A8], [%A1, %A2, %A3, %A4])

class PosMatrix:
	var blocks_left = []
	var blocks_right = []
	
	func _init(left: Array, right: Array) -> void:
		blocks_left = left
		blocks_right = right
	
	func rotate_right():
		var block = blocks_right.pop_back()
		blocks_right.push_front(block)

	func rotate_left():
		var block = blocks_left.pop_back()
		blocks_left.push_front(block)
		
	func rotate_yaw():
		pass

	func print_blocks():
		var names_left = ""
		var names_right = ""
		for b in blocks_left:
			names_left += " " + b.name
		for b in blocks_right:
			names_right += " " + b.name
		print("left: ", names_left)
		print("right: ", names_right)

func rotate_left():
	pivot_left.rotate_x(ROT_ANGLE)
	pos_matrix.rotate_left()
	pos_matrix.print_blocks()

func rotate_right():
	pivot_right.rotate_x(ROT_ANGLE)
	pos_matrix.rotate_right()
	pos_matrix.print_blocks()

func rotate_yaw():
	pivot_yaw.rotate_y(ROT_ANGLE)
