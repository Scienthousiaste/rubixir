import * as THREE from "three"
import { OrbitControls } from "./OrbitControls.js"
import {
	CAMERA_FRUSTRUM,
	FACES,
	NORMALIZE_POSITION_FACTOR,
	CUBIE_GEOMETRY,
	CUBIE_MATERIALS
} from "./constants_3D.js"

const getCubieMaterials = (cubicle, cubie) => {
	const materials = FACES.map(
		face => {
			if (cubicle.includes(face)) {
				const material = CUBIE_MATERIALS[cubie[cubicle.indexOf(face)].toUpperCase()] 
				return material ? material : CUBIE_MATERIALS["x"]
			}
			else {
				return CUBIE_MATERIALS["0"]
			}
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
		CUBIE_GEOMETRY,
		getCubieMaterials(cubicle, cubie)
	)
	cubicle3D.name = cubicle

	const cubiclePosition = getCubiclePosition(cubicle)

	cubicle3D.position.set(
		cubiclePosition.x - NORMALIZE_POSITION_FACTOR,
		cubiclePosition.y - NORMALIZE_POSITION_FACTOR,
		cubiclePosition.z - NORMALIZE_POSITION_FACTOR,
	)

	rubik3D.scene.add(cubicle3D)
	return cubicle3D
}

export const initRenderer = () => {
	const renderer = new THREE.WebGLRenderer({ alpha: false })
	renderer.setClearColor(0x00A5FF)
	renderer.setPixelRatio(window.devicePixelRatio)
	renderer.setSize(450, 450)
	return renderer
}

export const initCamera = (rubik3D) => {
	const camera = new THREE.OrthographicCamera(
	   -CAMERA_FRUSTRUM,
		CAMERA_FRUSTRUM,
		CAMERA_FRUSTRUM,
	   -CAMERA_FRUSTRUM,
	)
	camera.zoom = 110
	camera.position.set(10, 10, 10)
	camera.near = 0.005
	camera.updateProjectionMatrix()
	return camera
}

export const initScene = () => {
	const scene = new THREE.Scene()
    const ambientLight = new THREE.AmbientLight(0xFCFCFC, 1)
	scene.add(ambientLight)
	return scene
}

export const initContainer = (rubik3D) => {
	const rubikPageContainer = document.getElementById("cube3D")
	const landingPageContainer = document.getElementById("cube-previsualization") 
	const container = rubikPageContainer || landingPageContainer
	container.appendChild(rubik3D.renderer.domElement)
	return container
}

export const initCube = (rubik3D, cube) => {
	const cubies = []

	for (let cubicle in cube) {
		cubies.push(makeCubie(cubicle, cube[cubicle], rubik3D))
	}
	for (let face of FACES) {
		cubies.push(makeCubie(face, face.toUpperCase(), rubik3D))
	}
	return cubies
}

export const initControls = (rubik3D) => {
	const controls = new OrbitControls(
		rubik3D.camera,
		rubik3D.renderer.domElement
	)
	controls.enablePan = false
	controls.enableZoom = false
	controls.update()
	return controls
}
