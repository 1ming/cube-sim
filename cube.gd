extends Node3D

const ROT_ANGLE = deg_to_rad(90)

@onready var pivot_right = %PivotRight
@onready var pivot_left = %PivotLeft
@onready var pivot_yaw = %PivotYaw
@onready var pos_matrix = PosMatrix.new([%A5, %A6, %A7, %A8], [%A1, %A2, %A3, %A4])
@onready var cube_data = CubeData.new(
	{
		Face.L: {
			"colours": [[Clr.R, Clr.R],[Clr.R, Clr.R]],
			"blocks": [[%A5, %A6],[%A8, %A7]],
		},
		Face.C: {
			"colours": [[Clr.B, Clr.B],[Clr.B, Clr.B]],
			"blocks": [[%A6, %A2],[%A7, %A3]],
		},
		Face.R: {
			"colours": [[Clr.R, Clr.R],[Clr.R, Clr.R]],
			"blocks": [[%A2, %A1],[%A3, %A4]],
		},
		Face.B: {
			"colours": [[Clr.B, Clr.B],[Clr.B, Clr.B]],
			"blocks": [[%A8, %A4],[%A5, %A1]],
		},
		Face.U: {
			"colours": [[Clr.G, Clr.G],[Clr.G, Clr.G]],
			"blocks": [[%A5, %A1],[%A6, %A2]],
		},
		Face.D: {
			"colours": [[Clr.G, Clr.G],[Clr.G, Clr.G]],
			"blocks": [[%A7, %A3],[%A8, %A4]],
		},
	}
)

# each face corresponds to a 2x2 matrix
# each cell in matrix stores a colour and node name
enum Face {L, C, R, B, U, D}

enum Clr {R, G, B}

class Cell:
	var clr
	var node
	
	func _init(c, n):
		clr = c
		node = n
	
	func _to_string() -> String:
		return "(c" + str(clr) + " " + node + ")"

class CubeData:
	var faces = {}
	
	# face_data: dictionary of key=face, val={colours: [], blocks: []}
	# where colours and blocks are 2x2 matrices corresponding to colour
	# and name of block for the cell in that position
	# populate faces with dictionary of key=face, val = 2x2 matrix of Cell items
	func _init(face_data) -> void:
		for face in face_data.keys():
			faces[face] = [[null, null],[null,null]]
			var colours = face_data[face]["colours"]
			var blocks = face_data[face]["blocks"]
			for i in range(2):
				for j in range(2):
					faces[face][i][j] = Cell.new(colours[i][j], blocks[i][j].name)
		print("faces: ", faces)

	func _rotate_matrix(matrix, is_negative = false):
		var result = [[null, null], [null, null]]
		if is_negative:
			result[0][0] = matrix[1][0]
			result[0][1] = matrix[0][0]
			result[1][0] = matrix[1][1]
			result[1][1] = matrix[0][1]
		else:
			result[0][0] = matrix[0][1]
			result[0][1] = matrix[1][1]
			result[1][0] = matrix[0][0]
			result[1][1] = matrix[1][0]
		return result

	func rotate_right():
		# rotate the right half of the cube about the x-axis
		# tangential faces:
		# - concatenate matrix of faces vertically (2x8): U -> C -> D -> B
		# - shift items in second column down by 2
		# - update faces with new values
		# normal face on right side:
		# - rotate items in face (transpose): R (positive)
		var face_list = [Face.U, Face.C, Face.D, Face.B]
		var col_left = []
		var col_right = []
		for f in face_list:
			for i in range(2):
				col_left.append(faces[f][i][0])
				col_right.append(faces[f][i][1])
		print(col_left)
		print(col_right)
		
		# shift col_right items by 2
		for i in range(2):
			var item = col_right.pop_front()
			col_right.push_back(item)

		print(col_left)
		print(col_right)
		
		# update faces
		for f in face_list:
			for row in range(2):
				faces[f][row][0] = col_left.pop_front()
				faces[f][row][1] = col_right.pop_front()
		
		print("faces: ", faces)
		
		# rotate R face
		faces[Face.R] = _rotate_matrix(faces[Face.R])
		print("faces: ", faces)
		

	func rotate_yaw():
		# rotate entire cube about the y-axis
		# tangential faces:
		# - create list of faces: [L, C, R, B]
		# - shift forward one face
		# - assign corresponding faces accordingly
		# normal faces:
		# - rotate (transpose): U (positive), D (negative)
		pass

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
	cube_data.rotate_right()

func rotate_yaw():
	pivot_yaw.rotate_y(ROT_ANGLE)
	cube_data.rotate_yaw()
