package main

import rl "vendor:raylib"

// fix
shake_camera :: proc(camera: ^rl.Camera2D) {
	camera.offset.x += 1.0
	camera.offset.y += 1.0
}
