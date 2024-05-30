package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Item :: enum {
	NONE = 0,
	SQUID_MEAT,
    CHINESE_SCALE,
    EYE_OF_CTHULU,
    UNICORN_BONES,
    MUSHROOMS,
    VOID_MAYO,
}

item_get_model :: proc(w: ^World, it: Item) -> rl.Model {
	switch it {
	case .NONE:
		return {}
	case .SQUID_MEAT:
		return w.assets.squid_meat_model
    case .CHINESE_SCALE:
		return w.assets.squid_meat_model
    case .EYE_OF_CTHULU:
		return w.assets.squid_meat_model
    case .MUSHROOMS:
		return w.assets.squid_meat_model
    case .VOID_MAYO:
		return w.assets.squid_meat_model
    case .UNICORN_BONES:
		return w.assets.squid_meat_model
	}
	return {}
}
