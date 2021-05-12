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
	angleFromMove,
	getCube,
	transformNTimes,
	isRegularMove,
	isDoubleMove,
	isReverseMove,
} from "./helpers.js"

import {
	displayRemainingAnimations
} from "./UI.js"

import {
	FACE_TO_AXIS,
	TRANSFORMATIONS,
	DEFAULT_MOVE_ANIMATION_DURATION,
} from "./constants_3D.js"


export default class Rubik3D {

	constructor() {
		this.scene = initScene()
		this.renderer = initRenderer()
		this.container = initContainer(this)
		this.camera = initCamera(this)	
		this.cubies = initCube(this, getCube())
		this.controls = initControls(this)
		this.moveAnimationDuration = DEFAULT_MOVE_ANIMATION_DURATION

		this.setRemainingAnimations([])
		this.initAnimationData()
	}

	initAnimationData() {
		this.cubiesToMove = []
		this.animationRunning = false
		this.faceCubie = null
		this.startAnimationTime = null
		this.lastFrameTime = null
		this.animationRotationAxis = null
		this.animationTotalAngle = null
		this.animationCurrentAngle = null
		this.animationMove = null
	}

	setRemainingAnimations(newValue) {
		this.remainingAnimations = [...newValue]
		displayRemainingAnimations(this.remainingAnimations)
	}

	setMoveAnimationDuration(newValue) {
		this.moveAnimationDuration = newValue > 10 ? newValue : 10
	}

	renderScene(timeSinceBeginning) {
		if (this.animationRunning) {
			const timeDelta = Date.now() - this.startAnimationTime
			
			if (timeDelta > this.moveAnimationDuration) {
				this.concludeAnimation()	
			}
			else {
				this.computeNextAnimationStep(timeSinceBeginning - this.lastFrameTime)
			}
		}
		this.renderer.render(this.scene, this.camera)
		this.lastFrameTime = timeSinceBeginning
	}

	computeNextAnimationStep(frameTime) {
		const proportionAngleToCoverNow = frameTime / this.moveAnimationDuration
		const angleCoveredThisFrame = proportionAngleToCoverNow * this.animationTotalAngle	
		this.faceCubie.rotateOnWorldAxis(this.animationRotationAxis, angleCoveredThisFrame)
		this.animationCurrentAngle += angleCoveredThisFrame
	}

	concludeAnimation() {
		this.faceCubie.rotateOnWorldAxis(
			this.animationRotationAxis,
			(this.animationTotalAngle - this.animationCurrentAngle)
		)
		this.endCurrentAnimation()				
	}

	endCurrentAnimation() {
		this.cubiesToMove.forEach(cubie => {
			this.scene.attach(cubie)
		})
		this.updateCubies(this.animationMove)
		this.initAnimationData()

		if (this.remainingAnimations.length > 0) {
			const animToStart = this.remainingAnimations[0]
			this.setRemainingAnimations([...this.remainingAnimations.slice(1)])
			this.startAnimation(animToStart)
		}
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
		this.animationTotalAngle = angleFromMove(move)
		this.animationCurrentAngle = 0
		this.startAnimationTime = Date.now()
		this.animationRunning = true
	}

	animateMove(move) {
		if (!this.animationRunning) {
			this.startAnimation(move)
		}
		else {
			this.setRemainingAnimations(
				this.remainingAnimations.concat([move])
			)
		}
	}

	animateMoveSequence(moves) {
		for (const move of moves) {
			this.animateMove(move)
		}
	}

	updateCubies(move, rubik3D) {
		const transformation = TRANSFORMATIONS[move.charAt(0)]
		if (isRegularMove(move)) {
			this.cubies = transformNTimes(this.cubies, transformation, 1)
		}
		else if (isDoubleMove(move)) {
			this.cubies = transformNTimes(this.cubies, transformation, 2)
		}
		else if (isReverseMove(move)) {
			this.cubies = transformNTimes(this.cubies, transformation, 3)
		}
	}

	purgeScene() {
		for (let cubie of this.cubies) {
			this.scene.remove(cubie)
		}
	}

	purgeState() {
		this.initAnimationData()
		this.setRemainingAnimations([])
		this.purgeScene()
	}

	reinitializeCube(cube) {
		this.purgeState()
		this.cubies = initCube(this, cube)
	}

	addToCrossSolutions(move_sequence) {
		//TODO: remove
		const elt = document.querySelector("#cross_solves")
		const newCrossSolution = document.createElement("div")
		const csText = document.createElement("div")
		const csNum = document.createElement("div")

		newCrossSolution.setAttribute("class", "cross_solution")
		csText.textContent = move_sequence.join(" ")
		console.dir(move_sequence)
		csNum.textContent = move_sequence.length
		newCrossSolution.appendChild(csText)
		newCrossSolution.appendChild(csNum)
		elt.appendChild(newCrossSolution)
	}

	isValidSequence(sequence) {
		//TODO
		//with regexp
		return true
	}
}
