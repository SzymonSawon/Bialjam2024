package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

EntityKind :: enum {
	TEST,
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

make_entity_test :: proc() -> Entity {
	return Entity{kind = .TEST, position = {0, 0.5, 5}, size = {1, 1, 1}}
}
