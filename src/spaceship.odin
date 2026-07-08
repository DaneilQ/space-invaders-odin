package main
import rl "vendor:raylib"

SPACESHIP_HEIGHT :: 30.0

Spaceship :: struct {
	using co:          Entity,
	speed:             i32,
	projectiles_timer: Timer,
}

init_spaceship :: proc(collider: rl.Rectangle, speed: i32, color: rl.Color) -> Spaceship {
	return Spaceship {
		collider = collider,
		speed = speed,
		projectiles_timer = init_timer(0.5),
		color = color,
	}
}

handle_spaceship_controls :: proc(ss: ^Spaceship, projectiles: ^[dynamic]Projectile, delta: f32) {
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


	update_timer(&ss.projectiles_timer, delta)

	if timer_is_done(&ss.projectiles_timer) {
		if len(projectiles) <= MAX_PROJECTILES_ON_SCREEN {
			if rl.IsKeyDown(rl.KeyboardKey.SPACE) {
				reset_timer(&ss.projectiles_timer)
				append(projectiles, init_projectile(ss))
			}
		}
	}

}
