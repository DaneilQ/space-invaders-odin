package main

import "core:fmt"
import "core:strings"
import texts "texts"
State :: struct {
	level:            u8,
	movement_speed:   int,
	projectile_speed: int,
}

start_state :: proc() -> State {
	return State {
		level = 1,
		movement_speed = BASE_SPACESHIP_SPEED,
		projectile_speed = BASE_PROJECTILE_SPEED,
	}
}

get_current_level :: proc(state: ^State) -> cstring {
	str := strings.concatenate([]string{texts.LEVEL, fmt.tprint(state.level)})
	return strings.clone_to_cstring(str)
}
