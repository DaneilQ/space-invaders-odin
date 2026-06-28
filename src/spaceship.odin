package main
import rl "vendor:raylib"

Spaceship :: struct {
	collider: rl.Rectangle,
	speed:    i32,
}

init_spaceship :: proc(collider: rl.Rectangle, speed: i32) -> Spaceship {
	return Spaceship{collider = collider, speed = speed}
}

move_spaceship :: proc(ss: ^Spaceship, delta: f32) {
	if rl.IsKeyDown(rl.KeyboardKey.D) {
		ss.collider.x += f32(ss.speed) * delta
	} else if (rl.IsKeyDown(rl.KeyboardKey.A)) {
		ss.collider.x -= f32(ss.speed) * delta
	}
}
