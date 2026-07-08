package main

Obstacle :: struct {
	using co: Collider,
}

DEFAULT_OBSTACLE_HEIGHT :: 10.0
DEFAULT_OBSTACLE_WIDTH :: 10.0

init_obstacle :: proc(x: f32, y: f32) -> Obstacle {
	return Obstacle {
		collider = {
			x = x,
			y = y,
			height = DEFAULT_OBSTACLE_HEIGHT,
			width = DEFAULT_OBSTACLE_WIDTH,
		},
	}
}
