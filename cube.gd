extends Node3D

const ROT_ANGLE = deg_to_rad(90)

@onready var stationary_group = %Stationary
@onready var pivot_group = %Pivot
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

# type of rotation, which part of the cube is moving
# LOWER: half away from the positive direction of the axis
# UPPER: half towards the positive direction of the axis
# FULL: entire cube
enum Rot {LOWER, UPPER, FULL}

# direction to stack the matrices of the tangent faces
# HORIZONTAL: cells shift along a row
# VERTICAL: cells shift along a column
enum StackDir {HORIZONTAL, VERTICAL}

# normal faces ordered wrt positive direction of axis of rotation
const AXIS_TO_FACES = {
	"x": {
		"tangent": [Face.U, Face.C, Face.D, Face.B],
		"normal": [Face.L, Face.R],
		"dir": StackDir.VERTICAL,
	},
	"y": {
		"tangent": [Face.L, Face.C, Face.R, Face.B],
		"normal": [Face.D, Face.U],
		"dir": StackDir.HORIZONTAL,
	}
}

class Cell:
	var clr
	var node
	
	func _init(c, n):
		clr = c
		node = n
	
	func _to_string() -> String:
		return "(" + Clr.keys()[clr] + " " + node + ")"

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
		print_faces()

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

	func rotate_axis(axis: String, rot_type: Rot):
		var tangent_faces = AXIS_TO_FACES[axis].tangent
		var dir = AXIS_TO_FACES[axis].dir
		var normal_faces = (
			AXIS_TO_FACES[axis].normal if rot_type == Rot.FULL
			else AXIS_TO_FACES[axis].normal[0] if rot_type == Rot.LOWER
			else AXIS_TO_FACES[axis].normal[1]
		)
		
		if rot_type == Rot.FULL:
			# store copy original matrix of the first face
			var first_matrix = faces[tangent_faces[0]].duplicate()
			
			# assign the matrix of each face to that of the next face
			for i in range(len(tangent_faces) - 1):
				faces[tangent_faces[i]] = faces[tangent_faces[i+1]]
			faces[tangent_faces[len(tangent_faces) - 1]] = first_matrix
		print("after full rot. tangential faces: ")
		print_faces()
		

		# rotate normal faces
		for f in normal_faces:
			faces[f] = _rotate_matrix(faces[f])
		print("after rotating normal faces: ")
		print_faces()

	func rotate_right():
		# rotate the right half of the cube about the x-axis
		# tangential faces:
		# - concatenate matrix of faces vertically (2x8): U -> C -> D -> B
		# - shift items in second column down by 2
		# - update faces with new values
		# normal face on right side:
		# - rotate items in face: R (positive)
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
		# - rotate: U (positive), D (negative)
		pass
	
	func print_faces():
		for f in faces:
			print(Face.keys()[f], ": ", faces[f])
			

func reparent_blocks(rot_axis: String, rot_type: Rot = Rot.UPPER):
	print("pivot on axis: ", rot_axis)
	
	if rot_type == Rot.FULL:
		# add all nodes in stationary group to pivot group
		for block: Block in get_tree().get_nodes_in_group("blocks"):
			if block.rot_group == block.STATIONARY:
				block.rot_group = block.PIVOT
				block.reparent(pivot_group)
				print(block.name, " switched to pivot")
		return

	for block: Block in get_tree().get_nodes_in_group("blocks"):
		if ((block.in_rot_area(rot_axis) and rot_type == Rot.UPPER)
			or (not block.in_rot_area(rot_axis) and rot_type == Rot.LOWER)
		):
			if block.rot_group == block.STATIONARY:
				# reparent to pivot group
				block.rot_group = block.PIVOT
				block.reparent(pivot_group)
				print(block.name, " switched to pivot")
		elif block.rot_group == block.PIVOT:
			# reparent to stationary group
			block.rot_group = block.STATIONARY
			block.reparent(stationary_group)
			print(block.name, " switched to stationary")

func rotate_blocks(axis: String, rot_type: Rot = Rot.UPPER):
	reparent_blocks(axis, rot_type)
	
	match axis:
		"x":
			pivot_group.rotate_x(ROT_ANGLE)
		"y":
			pivot_group.rotate_y(ROT_ANGLE)
		"z":
			pivot_group.rotate_z(ROT_ANGLE)
