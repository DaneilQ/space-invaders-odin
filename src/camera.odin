package main

import rand "core:math/rand"
import rl "vendor:raylib"

// Replace with real tweens
shake_camera :: proc(camera: ^rl.Camera2D) {
	camera.offset.x += rand.float32_range(-1.0, 1.0)
	camera.offset.y += rand.float32_range(-1.0, 1.0)
}
