package main

import rl "vendor:raylib"


Enemy :: struct {
	collider:      rl.Rectangle,
	direction:     Direction,
	speed:         f32,
	should_delete: bool,
}

Direction :: enum {
	Left,
	Right,
}

@(private = "file")
DEFAULT_ENEMY_HEIGHT :: 30.0
@(private = "file")
DEFAULT_ENEMY_WIDTH :: 30.0

init_enemy :: proc(x: f32, y: f32, speed: f32 = 250.0) -> Enemy {
	return Enemy {
		collider = {x = x, y = y, width = DEFAULT_ENEMY_WIDTH, height = DEFAULT_ENEMY_HEIGHT},
		direction = Direction.Left,
		speed = speed,
		should_delete = false,
	}
}

@(private = "file")
set_direction :: proc(enemy: ^Enemy, new_direction: Direction) {
	enemy.direction = new_direction
}

@(private = "file")
oposite_direction :: proc(enemy: ^Enemy) {
	if enemy.direction == Direction.Left {
		set_direction(enemy, Direction.Right)
	} else {
		set_direction(enemy, Direction.Left)
	}
}

update_enemy :: proc(enemy: ^Enemy, enemies: ^[dynamic]Enemy, current_index: int, delta: f32) {
	if enemy.collider.x + enemy.collider.width > WIDTH {
		set_direction(enemy, Direction.Right)
	} else if enemy.collider.x <= 0 {
		set_direction(enemy, Direction.Left)
	}

	for &en, index in enemies {
		if index == current_index {
			continue
		}
		if rl.CheckCollisionRecs(en.collider, enemy.collider) {
			oposite_direction(&en)
		}
	}

	if enemy.direction == Direction.Left {
		enemy.collider.x += (enemy.speed * delta)
	} else if enemy.direction == Direction.Right {
		enemy.collider.x -= (enemy.speed * delta)
	}
}
