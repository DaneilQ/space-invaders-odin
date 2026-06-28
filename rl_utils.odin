package main

import rl "vendor:raylib"

rl_rectangle :: proc(x: f32, y: f32, width: f32, height: f32) -> rl.Rectangle {
	return rl.Rectangle{x = x, y = y, width = width, height = height}
}
