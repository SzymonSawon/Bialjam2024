package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

SPEED :: 3

Player :: struct {
	position:              rl.Vector3,
	yaw:                   f32,
	pitch:                 f32,
	held_item:             Item,
	held_item_change_time: f32,
}

init_player :: proc(p: ^Player) {
	p.position = {-1, 0, 0}
	p.yaw = 0
	p.pitch = rl.PI / 2
	p.held_item = .NONE
}

player_get_forward :: proc(p: ^Player) -> rl.Vector3 {
	return {
		math.cos(p.yaw) * math.sin(p.pitch),
		math.cos(p.pitch),
		math.sin(p.yaw) * math.sin(p.pitch),
	}
}

player_hold_item :: proc(p: ^Player, w: ^World, it: Item) {
	p.held_item = it
    p.held_item_change_time = w.now
}

update_player_movement :: proc(p: ^Player, dt: f32) {
	rotation := rl.GetMouseDelta()
	rotation *= 0.01
	p.pitch += rotation.y
	p.pitch = math.clamp(p.pitch, 0.1, rl.PI - 0.1)
	p.yaw += rotation.x

	movement := rl.Vector3{0, 0, 0}
	if rl.IsKeyDown(.W) {
		movement.z += 1
	}
	if rl.IsKeyDown(.S) {
		movement.z -= 1
	}
	if rl.IsKeyDown(.A) {
		movement.x -= 1
	}
	if rl.IsKeyDown(.D) {
		movement.x += 1
	}
	movement *= dt
	movement *= SPEED

	p.position += {movement.z * math.cos(p.yaw), 0, movement.z * math.sin(p.yaw)}
	p.position += {
		movement.x * math.cos(p.yaw + rl.PI / 2),
		0,
		movement.x * math.sin(p.yaw + rl.PI / 2),
	}
}
