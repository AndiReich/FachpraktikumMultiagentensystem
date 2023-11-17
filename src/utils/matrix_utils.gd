static func multiply_matrix_by_float(m: Array, value: float) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	for x in dim_x:
		for y in dim_y:
			m[x][y] *= value
	return m

static func transpose_matrix_in_place(m: Array) -> Array:
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	assert(dim_x == dim_y)
	for x in dim_x:
		for y in dim_y:
			var v = m[x][y]
			m[x][y] = m[y][x]
			m[y][x] = v
	return m

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
	var dim_x = m.size()
	var dim_y = m[0].size()

	# Calculate the effective shift value
	shift = shift % dim_x if axis == 0 else shift % dim_y

	if axis == 0:
		# roll along the rows (axis 0)
		var rolled_data = []
		for x in dim_x:
			var rolled_row = m[(x - shift) % dim_x]
			rolled_data.append(rolled_row)

		return rolled_data
	elif axis == 1:
		# roll along the columns (axis 1)
		var rolled_data = []
		for x in dim_x:
			var rolled_row = []
			for y in dim_y:
				rolled_row.append(m[x][(y - shift) % dim_y])
			rolled_data.append(rolled_row)

		return rolled_data
	else:
		printerr("Unsupported axis value. Please use 0 or 1 for axis.")
		return []

static func set_matrix_edges_to_float(m: Array, v: float):
	var dim_x: int = m.size()
	var dim_y: int = m[0].size()
	for x in dim_x:
		for y in dim_y:
			if x == 0 or x == dim_x - 1 or y == 0 or y == dim_y - 1:
				m[x][y] = 0.0
	return m
