package main

import rand "core:math/rand"

get_random_between :: proc(x: f32, y: f32) -> f32 {
	return rand.float32_range(x, y)
}

random_choice :: proc(array: $T/[]$E) -> E {
	return rand.choice(array)
}
