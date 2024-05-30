package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

EntityKind :: enum {
	TEST,
	TENTACLE,
}

Entity :: struct {
	kind:     EntityKind,
	position: rl.Vector3,
	size:     rl.Vector3,
	targeted: bool,
}

entity_get_bounds :: proc(e: ^Entity) -> rl.BoundingBox {
	return rl.BoundingBox{e.position - e.size / 2, e.position + e.size / 2}
}

entity_draw_debug :: proc(e: ^Entity) {
	bb := entity_get_bounds(e)
	if e.targeted {
		rl.DrawBoundingBox(bb, rl.GREEN)
	} else {
		rl.DrawBoundingBox(bb, rl.WHITE)
	}
}

entity_interact :: proc(w: ^World, e: ^Entity) {
	switch e.kind {
	case .TEST:
		fmt.println("Hello, there")
	case .TENTACLE:
		player_hold_item(&w.player, w, .SQUID_MEAT)
	}
}

draw_entity :: proc(w: ^World, e: ^Entity) {
	switch e.kind {
	case .TEST:
	case .TENTACLE:
		rl.DrawModelEx(
			w.assets.portal_model,
			e.position + {0, 0.27, 0.0},
			{1, 0, 0},
			90,
			{1, 1, 1},
			rl.WHITE,
		)
		rl.DrawModelEx(
			w.assets.tentacle_model,
			e.position + {0, 0.1, -0.1},
			{1, 0, 0},
			-90,
			{1, 1, 1},
			rl.WHITE,
		)
	}
}

make_entity_test :: proc() -> Entity {
	return Entity{kind = .TEST, position = {0, 0.5, 5}, size = {1, 1, 1}}
}

make_entity_tentacle :: proc() -> Entity {
	return Entity{kind = .TENTACLE, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}
