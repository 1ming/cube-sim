extends Node3D

const ROT_ANGLE = deg_to_rad(90)

@onready var pivot_right = %PivotRight
@onready var pivot_left = %PivotLeft
@onready var pivot_cube = %Cube
@onready var pos_matrix = PosMatrix.new([%A1, %A2, %A3, %A4], [%A5, %A6, %A7, %A8])

class PosMatrix:
	var blocks_left = []
	var blocks_right = []
	
	func _init(left: Array, right: Array) -> void:
		blocks_left = left
		blocks_right = right
	
	func rotate_right():
		var block = blocks_right.pop_back()
		blocks_right.push_front(block)
		for b in blocks_right:
			print(b.name)
		print()
		pass
		

func rotate_left():
	pivot_left.rotate_x(ROT_ANGLE)

func rotate_right():
	pivot_right.rotate_x(ROT_ANGLE)
	pos_matrix.rotate_right()

func rotate_yaw():
	pass
