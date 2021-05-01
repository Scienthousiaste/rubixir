import * as THREE from "three"
import { OrbitControls } from "./OrbitControls.js"

const DIM_CUBIE = 0.95
const SQUARE_CAMERA_FRUSTRUM = 300
const dims = [0, 1, 2]
const faces = ["R", "L", "U", "D", "F", "B"]
const center_factor = ((DIM_CUBIE * dims.length) - DIM_CUBIE) / 2
const cubieGeometry = new THREE.BoxGeometry(
	DIM_CUBIE,
	DIM_CUBIE,
	DIM_CUBIE,
)
const rubik3D = {}

const cubieMaterials = {
	"L": new THREE.MeshBasicMaterial({ color: 0xffaa00}),
	"R": new THREE.MeshBasicMaterial({ color: 0xcd1010}),
	"U": new THREE.MeshBasicMaterial({ color: 0xffff00}),
	"D": new THREE.MeshBasicMaterial({ color: 0xfbfbfb}),
	"F": new THREE.MeshBasicMaterial({ color: 0x1010cd}),
	"B": new THREE.MeshBasicMaterial({ color: 0x10cd10}),
	"x": new THREE.MeshBasicMaterial({ color: 0x101010}),
}

const initRenderer = (rubik3D) => {
	const renderer = new THREE.WebGLRenderer({ alpha: false })
	renderer.setClearColor(0x00A5FF)
	renderer.setPixelRatio(window.devicePixelRatio)
	renderer.setSize(450, 450)
	rubik3D.renderer = renderer
}

const initCamera = (rubik3D) => {
	const camera = new THREE.OrthographicCamera(
	   -SQUARE_CAMERA_FRUSTRUM,
		SQUARE_CAMERA_FRUSTRUM,
		SQUARE_CAMERA_FRUSTRUM,
	   -SQUARE_CAMERA_FRUSTRUM,
	)
	camera.zoom = 110
	camera.position.set(10, 10, 10)
	camera.near = 0.005
	camera.updateProjectionMatrix()
	rubik3D.camera = camera
}

const initScene = (rubik3D) => {
	const scene = new THREE.Scene()
    const ambientLight = new THREE.AmbientLight(0xFCFCFC, 1)
	scene.add(ambientLight)
	rubik3D.scene = scene
}

const initContainer = (rubik3D) => {
	const container = document.getElementById("cube3D")
	container.appendChild(rubik3D.renderer.domElement)
	rubik3D.container = container 
}

const getCubieMaterials = (cubicle, cubie) => {

	const materials = faces.map(
		face => {
			return (
				cubicle.includes(face) ?
		  		cubieMaterials[cubie[cubicle.indexOf(face)].toUpperCase()] :
				cubieMaterials["x"]
			)
		}
	)
	return materials
}

const getCubiclePosition = (c) => {
	return {
		x: (c.includes("R")? 2 : (c.includes("L") ? 0 : 1)),
		y: (c.includes("D")? 0 : (c.includes("U") ? 2 : 1)),
		z: (c.includes("B")? 0 : (c.includes("F") ? 2 : 1)),
	}
}

const makeCubie = (cubicle, cubie, rubik3D) => {

	const cubicle3D = new THREE.Mesh(
		cubieGeometry,
		getCubieMaterials(cubicle, cubie)
	)
	cubicle3D.name = cubicle

	const cubiclePosition = getCubiclePosition(cubicle)

	cubicle3D.position.set(
		cubiclePosition.x - center_factor,
		cubiclePosition.y - center_factor,
		cubiclePosition.z - center_factor,
	)

	rubik3D.scene.add(cubicle3D)
	return cubicle3D
}

const initCube = (rubik3D, cube) => {
	const cubies = []

	for (let cubicle in cube) {
		cubies.push(makeCubie(cubicle, cube[cubicle], rubik3D))
	}
	for (let face of faces) {
		cubies.push(makeCubie(face, face.toUpperCase(), rubik3D))
	}
	rubik3D.cubies = cubies
}

const initControls = (rubik3D) => {
	const controls = new OrbitControls(
		rubik3D.camera,
		rubik3D.renderer.domElement
	)
	controls.enableZoom = false
	controls.update()
	rubik3D.controls = controls
}

const animate = () => {
	requestAnimationFrame(animate)
	rubik3D.renderer.render(rubik3D.scene, rubik3D.camera)
}

const getCube = () => {
	const cube_dom = document.querySelector('#cube3D')
	return (JSON.parse(cube_dom.dataset.cube))
}

export default function initRubik3D() {

	initScene(rubik3D)
	initRenderer(rubik3D)
	initContainer(rubik3D)
	initCamera(rubik3D)	
	initCube(rubik3D, getCube())
	initControls(rubik3D)
	addMethods(rubik3D)
	animate()
	return(rubik3D)
}

const faceToAxis = {
	"R": new THREE.Vector3(-1, 0, 0),
	"L": new THREE.Vector3(1, 0, 0),
	"U": new THREE.Vector3(0, -1, 0),
	"D": new THREE.Vector3(0, 1, 0),
	"B": new THREE.Vector3(0, 0, 1),
	"F": new THREE.Vector3(0, 0, -1),
}

const quarterTurn = Math.PI / 2

const moveToAngle = (move) => {
	if (move.length == 2) {
		return (move.charAt(1) == "'" ? -quarterTurn : 2 * quarterTurn)
	}
	return quarterTurn
}

const addMethods = (rubik3D) => {
	rubik3D.renderScene = () => {
		rubik3D.renderer.render(rubik3D.scene, rubik3D.camera)
	}

	rubik3D.animateMove = (move, newCube) => {

		const face = move.charAt(0)
		const faceCubie = rubik3D.cubies.find(cubie => {
			return cubie.name === face
		})
		const cubiesToMove = rubik3D.cubies.filter(cubie => {
			return ((cubie.name !== face) && cubie.name.includes(face))
		})

		cubiesToMove.forEach(cubie => {
			faceCubie.attach(cubie)
		})
		
		faceCubie.rotateOnWorldAxis(faceToAxis[face], moveToAngle(move))
		
		cubiesToMove.forEach(cubie => {
			rubik3D.scene.attach(cubie)
		})

		renameCubies(move, rubik3D)
	}
}

const transformations = {

	"B": {
		"ULB": "DLB",
		"DLB": "DRB",
		"DRB": "URB",
		"URB": "ULB",
		"UB": "LB",
		"LB": "DB",
		"DB": "RB",
		"RB": "UB"
	},

	"U": {
		"ULB": "URB",
		"URB": "URF",
		"URF": "ULF",
		"ULF": "ULB",
		"UB": "UR",
		"UR": "UF",
		"UF": "UL",
		"UL": "UB"
	},

	"R": {
		"URF": "URB",
		"URB": "DRB",
		"DRB": "DRF",
		"DRF": "URF",
		"UR": "RB",
		"RB": "DR",
		"DR": "RF",
		"RF": "UR"
	},

	"F": {
		"ULF": "URF",
		"URF": "DRF",
		"DRF": "DLF",
		"DLF": "ULF",
		"UF": "RF",
		"RF": "DF",
		"DF": "LF",
		"LF": "UF"
	},


	"D": {
		"DLB": "DLF",
		"DLF": "DRF",
		"DRF": "DRB",
		"DRB": "DLB",
		"DF": "DR",
		"DR": "DB",
		"DB": "DL",
		"DL": "DF"
	},

	"L": {
		"ULB": "ULF",
		"ULF": "DLF",
		"DLF": "DLB",
		"DLB": "ULB",
		"UL": "LF",
		"LF": "DL",
		"DL": "LB",
		"LB": "UL"
	}

}


const makeTransformation = (cubies, transformation) => {
	return cubies.map(cubie => {
		if (transformation[cubie.name]) {
			cubie.name = transformation[cubie.name];
		}
		return cubie
	})
}

const renameCubies = (move, rubik3D) => {

	const transformation = transformations[move.charAt(0)]

	if (faces.includes(move)) {
		rubik3D.cubies = makeTransformation(rubik3D.cubies, transformation)
	}
	else if (faces.includes(move.charAt(0)) && move.charAt(1) === "2") {
		rubik3D.cubies = makeTransformation(
			makeTransformation(rubik3D.cubies, transformation),
			transformation
		)	
	}
	else if (faces.includes(move.charAt(0)) && move.charAt(1) === "'") {
		rubik3D.cubies = makeTransformation(
			makeTransformation(
			makeTransformation(rubik3D.cubies, transformation),
			transformation),
			transformation
		)	
	}

}
