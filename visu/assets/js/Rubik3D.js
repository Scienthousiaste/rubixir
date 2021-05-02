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
	MOVE_ANIMATION_DURATION,
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

		this.animationRunning = false
		this.queueAnimations = []
		this.faceCubie = null
		this.cubiesToMove = []
		this.startAnimationTime = null
		this.lastFrameTime = null

		this.animationRotationAxis = null
		this.animationTotalAngle = null
		this.animationCurrentAngle = null
		this.animationMove = null
	}


	renderScene(timeSinceBeginning) {
		if (this.animationRunning) {

			const timeDelta = Date.now() - this.startAnimationTime
			console.log("here, timeDelta", timeDelta, this.animationRunning)
			
			if (timeDelta > MOVE_ANIMATION_DURATION) {

				this.faceCubie.rotateOnWorldAxis(
					this.animationRotationAxis,
					(this.animationTotalAngle - this.animationCurrentAngle)
				)
				this.endCurrentAnimation()				
			}
			else {

				const proportionAngleToCoverThisFrame =
					(timeSinceBeginning - this.lastFrameTime) / MOVE_ANIMATION_DURATION
				
				const angleCoveredThisFrame = proportionAngleToCoverThisFrame * this.animationTotalAngle	
				this.faceCubie.rotateOnWorldAxis(this.animationRotationAxis, angleCoveredThisFrame)
				this.animationCurrentAngle += angleCoveredThisFrame

			}
		}
		this.renderer.render(this.scene, this.camera)
		this.lastFrameTime = timeSinceBeginning
	}

	endCurrentAnimation() {
		this.cubiesToMove.forEach(cubie => {
			this.scene.attach(cubie)
		})
		this.renameCubies(this.animationMove)
		
		this.animationRunning = false
		this.animationMove = null
		this.faceCubie = null
		this.cubiesToMove = []
		this.startAnimationTime = null
		this.animationTotalAngle = null
		this.animationCurrentAngle = null
		this.animationRotationAxis = null

		//check queueAnimations?
	}

	startAnimation(move) {
		const face = move.charAt(0)
		this.faceCubie = this.cubies.find(cubie => {
			return cubie.name === face
		})
		this.cubiesToMove = this.cubies.filter(cubie => {
			return ((cubie.name !== face) && cubie.name.includes(face))
		})
		this.cubiesToMove.forEach(cubie => {
			this.faceCubie.attach(cubie)
		})
		this.animationMove = move
		this.animationRotationAxis = FACE_TO_AXIS[face]
		this.animationTotalAngle = moveToAngle(move)
		this.animationCurrentAngle = 0
		this.startAnimationTime = Date.now()
		this.animationRunning = true
	}

	animateMove(move, newCube) {
		if (!this.animationRunning) {
			this.startAnimation(move)
		}
		/*
		else {
			this.queueAnimations.push({move: move})
		}
		*/
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

	purgeScene() {
		for (let cubie of this.cubies) {
			this.scene.remove(cubie)
		}
	}

	reinitializeCube(cube) {
		this.purgeScene()
		this.cubies = initCube(this, cube)
	}
}
