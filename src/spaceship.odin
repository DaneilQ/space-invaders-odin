package main
import rl "vendor:raylib"

SPACESHIP_HEIGHT :: 30.0

Spaceship :: struct {
	collider: rl.Rectangle,
	speed:    i32,
}

init_spaceship :: proc(collider: rl.Rectangle, speed: i32) -> Spaceship {
	return Spaceship{collider = collider, speed = speed}
}

move_spaceship :: proc(ss: ^Spaceship, delta: f32) {
	if rl.IsKeyDown(rl.KeyboardKey.D) {
		if ss.collider.x + ss.collider.width >= WIDTH {
			return
		}
		ss.collider.x += f32(ss.speed) * delta
	} else if (rl.IsKeyDown(rl.KeyboardKey.A)) {
		if ss.collider.x <= 0.0 {
			return
		}
		ss.collider.x -= f32(ss.speed) * delta
	}
}
