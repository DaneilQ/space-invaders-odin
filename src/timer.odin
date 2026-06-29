package main


Timer :: struct {
	countdown: f32,
	max_time:  f32,
}

init_timer :: proc(max_time: f32) -> Timer {
	return Timer{countdown = 0.0, max_time = max_time}
}


update_timer :: proc(timer: ^Timer, delta: f32) {
	if timer.countdown > 0.0 {
		timer.countdown = timer.countdown - delta
	}
}

reset_timer :: proc(timer: ^Timer) {
	timer.countdown = timer.max_time
}

timer_is_done :: proc(timer: ^Timer) -> bool {
	return timer.countdown <= 0.0
}
