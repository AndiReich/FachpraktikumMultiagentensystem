static func multiply_matrix_by_float(m: Array, value: float) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	var r = m.duplicate(true)
	for x in dim_x:
		for y in dim_y:
			r[x][y] *= value
	return r

static func transpose_matrix_in_place(m: Array):
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	assert(dim_x == dim_y)
	for x in dim_x:
		for y in dim_y:
			var v = m[x][y]
			m[x][y] = m[y][x]
			m[y][x] = v

static func add_matrix(m: Array, n: Array) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	assert(n.size() == dim_x)
	assert(n[0].size() == dim_y)
	var r = m.duplicate(true)
	for x in dim_x:
		for y in dim_y:
			r[x][y] += n[x][y]
	return r


static func subtract_matrix(m: Array, n: Array) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	assert(n.size() == dim_x)
	assert(n[0].size() == dim_y)
	var r = m.duplicate(true)
	for x in dim_x:
		for y in dim_y:
			r[x][y] -= n[x][y]
	return r

# verified against the NumPy roll function
static func roll_matrix(m, shift: int, axis: int) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()

	# Calculate the effective shift value
	shift = shift % dim_x if axis == 0 else shift % dim_y

	if axis == 0:
		# roll along the rows (axis 0)
		var rolled_data: Array = []
		for x in dim_x:
			var rolled_row: Array = m[(x - shift) % dim_x]
			rolled_data.append(rolled_row)

		return rolled_data
	elif axis == 1:
		# roll along the columns (axis 1)
		var rolled_data: Array = []
		for x in dim_x:
			var rolled_row: Array = []
			for y in dim_y:
				rolled_row.append(m[x][(y - shift) % dim_y])
			rolled_data.append(rolled_row)

		return rolled_data
	else:
		printerr("Unsupported axis value. Please use 0 or 1 for axis.")
		return []

# TODO: This implementation is very inefficient since we iterate over the whole 
# matrix.
static func set_matrix_edges_to_float(m: Array, v: float) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	var r = m.duplicate(true)
	for x in dim_x:
		for y in dim_y:
			if x == 0 or x == dim_x - 1 or y == 0 or y == dim_y - 1:
				r[x][y] = 0.0
	return r
