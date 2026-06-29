package main

import rand "core:math/rand"
import rl "vendor:raylib"


Enemy :: struct {
	collider:      rl.Rectangle,
	direction:     Direction,
	speed:         f32,
	should_delete: bool,
	color:         rl.Color,
}

Direction :: enum {
	Left,
	Right,
}

@(private = "file")
ENEMY_POSSIBLE_COLORS: [8]rl.Color = {
	rl.RED,
	rl.BEIGE,
	rl.BLUE,
	rl.BROWN,
	rl.GREEN,
	rl.PURPLE,
	rl.DARKPURPLE,
	rl.GRAY,
}

@(private = "file")
DEFAULT_ENEMY_HEIGHT :: 30.0
@(private = "file")
DEFAULT_ENEMY_WIDTH :: 30.0

@(private = "file")
COLLISION_MARGIN :: 10.0

init_enemy :: proc(x: f32, y: f32, speed: f32 = 250.0) -> Enemy {
	return Enemy {
		collider = {x = x, y = y, width = DEFAULT_ENEMY_WIDTH, height = DEFAULT_ENEMY_HEIGHT},
		direction = Direction.Left,
		speed = speed,
		should_delete = false,
		color = rand.choice(ENEMY_POSSIBLE_COLORS[:]),
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

@(private = "file")
handle_collisions_between_enemies :: proc(enemy1: ^Enemy, enemy2: ^Enemy) {

	if rl.CheckCollisionRecs(enemy1.collider, enemy2.collider) {
		oposite_direction(enemy1)
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
		handle_collisions_between_enemies(&en, enemy)
	}

	if enemy.direction == Direction.Left {
		enemy.collider.x += (enemy.speed * delta)
	} else if enemy.direction == Direction.Right {
		enemy.collider.x -= (enemy.speed * delta)
	}
}
