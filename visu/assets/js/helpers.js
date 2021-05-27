import {
	QUARTER_TURN,
	FACES,
	DEFAULT_CUBE
} from "./constants_3D.js"

export const angleFromMove = (move) => {
	if (move.length == 2) {
		return (move.charAt(1) == "'" ? -QUARTER_TURN : 2 * QUARTER_TURN)
	}
	return QUARTER_TURN
}

export const getCube = () => {
	//const cube_dom = document.querySelector('#cube3D')
	//return (JSON.parse(cube_dom.dataset.cube))
	return DEFAULT_CUBE
}

const makeTransformation = (cubies, transformation) => {
	return cubies.map(cubie => {
		if (transformation[cubie.name]) {
			cubie.name = transformation[cubie.name];
		}
		return cubie
	})
}

export const transformNTimes = (cubies, transformation, n) => {
	for (let x = 0; x < n; x++) {
		cubies = makeTransformation(cubies, transformation);
	}
	return cubies;
}

export const isRegularMove = (move) => {
	return FACES.includes(move)
}

export const isDoubleMove = (move) => {
	return (FACES.includes(move.charAt(0)) && move.charAt(1) === "2")
}

export const isReverseMove = (move) => {
	return (FACES.includes(move.charAt(0)) && move.charAt(1) === "'")
}

export const isValidSequence = (sequence) => {
	return (regexMoveSequence.test(sequence))
}

export const inverseSequence = (sequenceString) => {
	const sequence = sequenceString.split(" ")	
	return sequence.reverse().map(move => {
		if (move.length === 1) {
			return move + "'"
		}
		else if (move[1] === "'") {
			return move[0]
		}
		return move
	}).join(" ")
}

const regexMoveSequence = /^([FRUBLD][2']?)+$/
export const regexExtractMovesSequence = /([FRUBLD][2']?)/g
