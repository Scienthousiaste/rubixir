import { MeshBasicMaterial, BoxGeometry, Vector3 } from "three"

const DIM_CUBIE = 0.95
const DIMENSIONS = [0, 1, 2]
export const CAMERA_FRUSTRUM = 300
export const FACES = ["R", "L", "U", "D", "F", "B"]
export const NORMALIZE_POSITION_FACTOR = ((DIM_CUBIE * DIMENSIONS.length) - DIM_CUBIE) / 2
export const CUBIE_GEOMETRY = new BoxGeometry(
	DIM_CUBIE,
	DIM_CUBIE,
	DIM_CUBIE,
)

export const CUBIE_MATERIALS = {
	"L": new MeshBasicMaterial({ color: 0xffaa00}),
	"R": new MeshBasicMaterial({ color: 0xcd1010}),
	"U": new MeshBasicMaterial({ color: 0xffff00}),
	"D": new MeshBasicMaterial({ color: 0xfbfbfb}),
	"F": new MeshBasicMaterial({ color: 0x1010cd}),
	"B": new MeshBasicMaterial({ color: 0x10cd10}),
	"x": new MeshBasicMaterial({ color: 0x404040}),
	"0": new MeshBasicMaterial({ color: 0x101010}),
}

export const FACE_TO_AXIS = {
	"R": new Vector3(-1, 0, 0),
	"L": new Vector3(1, 0, 0),
	"U": new Vector3(0, -1, 0),
	"D": new Vector3(0, 1, 0),
	"B": new Vector3(0, 0, 1),
	"F": new Vector3(0, 0, -1),
}

export const QUARTER_TURN = Math.PI / 2

export const TRANSFORMATIONS = {

	"B": {
		"ULB": "DLB", "DLB": "DRB", "DRB": "URB", "URB": "ULB",
		"UB": "LB", "LB": "DB", "DB": "RB", "RB": "UB"
	},

	"U": {
		"ULB": "URB", "URB": "URF", "URF": "ULF", "ULF": "ULB",
		"UB": "UR", "UR": "UF", "UF": "UL", "UL": "UB"
	},

	"R": {
		"URF": "URB", "URB": "DRB", "DRB": "DRF", "DRF": "URF",
		"UR": "RB", "RB": "DR", "DR": "RF", "RF": "UR"
	},

	"F": {
		"ULF": "URF", "URF": "DRF", "DRF": "DLF", "DLF": "ULF",
		"UF": "RF", "RF": "DF", "DF": "LF", "LF": "UF"
	},

	"D": {
		"DLB": "DLF", "DLF": "DRF", "DRF": "DRB", "DRB": "DLB",
		"DF": "DR", "DR": "DB", "DB": "DL", "DL": "DF"
	},

	"L": {
		"ULB": "ULF", "ULF": "DLF", "DLF": "DLB", "DLB": "ULB",
		"UL": "LF", "LF": "DL", "DL": "LB", "LB": "UL"
	}
}

export const DEFAULT_MOVE_ANIMATION_DURATION = 2000

export const DEFAULT_CUBE = {"DB":"db","DF":"df","DL":"dl","DLB":"dlb","DLF":"dlf","DR":"dr","DRB":"drb","DRF":"drf","LB":"lb","LF":"lf","RB":"rb","RF":"rf","UB":"ub","UF":"uf","UL":"ul","ULB":"ulb","ULF":"ulf","UR":"ur","URB":"urb","URF":"urf"}

export const CUBE_IN_CUBE_IN_CUBE_PATTERN = ["U'", "L'", "U'", "F'", "R2", "B'", "R", "F", "U", "B2", "U", "B'", "L", "U'", "F", "U", "R", "F'"]
