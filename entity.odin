package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

EntityKind :: enum {
	TEST,
	TENTACLE,
    SLIME,
    FRIDGE,
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
    case .SLIME:
    case .FRIDGE:
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
    case .SLIME:
		rl.DrawModelEx(
			w.assets.slime_model,
			e.position + {0, 0, 1.5},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
    case .FRIDGE:
		rl.DrawModelEx(
			w.assets.fridge_model,
			e.position + {0.4, -0.7, 0.3},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)

		rl.DrawModelEx(
			w.assets.fridge_bones_model,
			e.position + {0.345, -0.5, -0.04},
			{1, 0, 0},
			0,
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

make_entity_slime :: proc() -> Entity {
	return Entity{kind = .SLIME, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}

make_entity_fridge :: proc() -> Entity {
	return Entity{kind = .FRIDGE, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}
