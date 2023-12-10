static func count_matching_bits(a: int, b: int, max_bits: int) -> int:
	if a == b:
		return max_bits
	
	var xor_result = a ^ b 
	var count = 0
	
	for i in range(min(max_bits, 64)):
		if (xor_result & (1 << i)) == 0:
			count += 1
	
	return count
