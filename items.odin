package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Item :: enum {
	NONE = 0,
	SQUID_MEAT,
}

item_get_model :: proc(w: ^World, it: Item) -> rl.Model {
	switch it {
	case .NONE:
		return {}
	case .SQUID_MEAT:
		return w.assets.squid_meat_model
	}
	return {}
}
