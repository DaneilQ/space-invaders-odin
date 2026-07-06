package main

import "core:fmt"
import rand "core:math/rand"
import rl "vendor:raylib"


Enemy :: struct {
	collider:         rl.Rectangle,
	direction:        Direction,
	speed:            f32,
	should_delete:    bool,
	color:            rl.Color,
	collider_timer:   Timer,
	projectile_timer: Timer,
	projectiles:      [dynamic]Projectile,
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
@(private = "file")
COLLISION_TIMER :: 0.1
@(private = "file")
PROJECTILE_TIMER :: 0.5
@(private = "file")
BASE_ENEMY_PROJECTILE_SPEED :: 300

@(private = "file")
MAX_SPEED :: 250.0
@(private = "file")
MIN_SPEED :: MAX_SPEED - 100.0

init_enemy :: proc(x: f32, y: f32) -> Enemy {
	return Enemy {
		collider = {x = x, y = y, width = DEFAULT_ENEMY_WIDTH, height = DEFAULT_ENEMY_HEIGHT},
		direction = Direction.Left,
		speed = rand.float32_range(MIN_SPEED, MAX_SPEED),
		should_delete = false,
		color = rand.choice(ENEMY_POSSIBLE_COLORS[:]),
		collider_timer = init_timer(COLLISION_TIMER),
		projectile_timer = init_timer(PROJECTILE_TIMER),
	}
}

@(private = "file")
set_direction :: proc(enemy: ^Enemy, new_direction: Direction) {
	enemy.direction = new_direction
	set_random_speed(enemy)
}

@(private = "file")
set_random_speed :: proc(enemy: ^Enemy) {
	enemy.speed = rand.float32_range(MIN_SPEED, MAX_SPEED)
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
	if timer_is_done(&enemy1.collider_timer) {
		if rl.CheckCollisionRecs(enemy1.collider, enemy2.collider) {
			oposite_direction(enemy1)
			reset_timer(&enemy1.collider_timer)
		}
	}
}

update_enemy :: proc(enemy: ^Enemy, enemies: ^[dynamic]Enemy, current_index: int, delta: f32) {
	update_timer(&enemy.collider_timer, delta)
	update_timer(&enemy.projectile_timer, delta)

	for pr in enemy.projectiles {
		
	}

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

	if timer_is_done(&enemy.projectile_timer) {
		init_projectile(enemy, BASE_ENEMY_PROJECTILE_SPEED)
		reset_timer(&enemy.projectile_timer)
	}

	if enemy.direction == Direction.Left {
		enemy.collider.x += (enemy.speed * delta)
	} else if enemy.direction == Direction.Right {
		enemy.collider.x -= (enemy.speed * delta)
	}
}
