package main

import rl "vendor:raylib"
Obstacle :: struct {
	collider: rl.Rectangle,
}

init_obstacle :: proc(x: f32, y: f32) -> Obstacle {
	return Obstacle{collider = {x = x, y = y, height = 10.0, width = 10.0}}
}
