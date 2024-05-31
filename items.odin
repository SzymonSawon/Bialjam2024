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
		return w.assets.dragon_scale_model
	case .EYE_OF_CTHULU:
		return w.assets.eye_model
	case .MUSHROOMS:
		return w.assets.shroom_model
	case .VOID_MAYO:
		return w.assets.spoon_model
	case .UNICORN_BONES:
		return w.assets.unicorn_bones_model
	}
	return {}
}

item_get_name :: proc(it: Item) -> string {
	switch it {
	case .NONE:
	case .SQUID_MEAT:
		return "Squid mEAT"
	case .CHINESE_SCALE:
		return "D's scALE"
	case .EYE_OF_CTHULU:
		return "Eye of C."
	case .MUSHROOMS:
		return "Schrooms"
	case .VOID_MAYO:
		return "Void Mayo"
	case .UNICORN_BONES:
		return "U-crn Bone"
	}
    return ""
}
