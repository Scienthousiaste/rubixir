import * as THREE from "three"

import {
	initScene,
	initRenderer,
	initContainer,
	initCamera,
	initCube,
	initControls
} from "./init_three.js"

import {
	FACES,
	FACE_TO_AXIS,
	QUARTER_TURN,
	TRANSFORMATIONS,
} from "./constants_3D.js"


const moveToAngle = (move) => {
	if (move.length == 2) {
		return (move.charAt(1) == "'" ? -QUARTER_TURN : 2 * QUARTER_TURN)
	}
	return QUARTER_TURN
}

const getCube = () => {
	const cube_dom = document.querySelector('#cube3D')
	return (JSON.parse(cube_dom.dataset.cube))
}

const makeTransformation = (cubies, transformation) => {
	return cubies.map(cubie => {
		if (transformation[cubie.name]) {
			cubie.name = transformation[cubie.name];
		}
		return cubie
	})
}

export default class Rubik3D {

	constructor() {
		this.scene = initScene()
		this.renderer = initRenderer()
		this.container = initContainer(this)
		this.camera = initCamera(this)	
		this.cubies = initCube(this, getCube())
		this.controls = initControls(this)
	}

	renderScene() {
		this.renderer.render(this.scene, this.camera)
	}

	animateMove(move, newCube) {
		const face = move.charAt(0)
		const faceCubie = this.cubies.find(cubie => {
			return cubie.name === face
		})
		const cubiesToMove = this.cubies.filter(cubie => {
			return ((cubie.name !== face) && cubie.name.includes(face))
		})
		cubiesToMove.forEach(cubie => {
			faceCubie.attach(cubie)
		})
		faceCubie.rotateOnWorldAxis(FACE_TO_AXIS[face], moveToAngle(move))
		cubiesToMove.forEach(cubie => {
			this.scene.attach(cubie)
		})
		this.renameCubies(move)
	}

	renameCubies(move, rubik3D) {

		const transformation = TRANSFORMATIONS[move.charAt(0)]

		if (FACES.includes(move)) {
			this.cubies = makeTransformation(this.cubies, transformation)
		}
		else if (FACES.includes(move.charAt(0)) && move.charAt(1) === "2") {
			this.cubies = makeTransformation(
				makeTransformation(this.cubies, transformation),
				transformation
			)	
		}
		else if (FACES.includes(move.charAt(0)) && move.charAt(1) === "'") {
			this.cubies = makeTransformation(
				makeTransformation(
				makeTransformation(this.cubies, transformation),
				transformation),
				transformation
			)	
		}
	}
}
