import {
	inverseSequence,
	isValidSequence,
	regexExtractMovesSequence
} from "./helpers.js"

function handleSequenceInput(rubikSocket, rubik3D, reverse) {
	hideSequenceError()
	const moveSequenceTextarea = document.querySelector("#move_sequence_input")
	const sequence = moveSequenceTextarea.value.replace(/\s/g, '')

	if (isValidSequence(sequence)) {
		const allMatches = [...sequence.matchAll(regexExtractMovesSequence)]
		const cleanMoveArray = allMatches.map(e => e[0])
		if (cleanMoveArray.length >= 200) {
			alert("Not more than 200 moves in a sequence. Everything needs a limit. You reached this one, nice job!")
		}
		else {
			const cleanString = cleanMoveArray.join(" ")
			const sequenceToSend = reverse ? inverseSequence(cleanString) : cleanString	
			rubikSocket.makeMoveSequence(sequenceToSend)
		}
	}
	else {
		displaySequenceError()
	}
}

function displaySequenceError() {
	const messageSequence = document.querySelector("#error-message-sequence")
	messageSequence.style.display = "block";
}
function hideSequenceError() {
	const messageSequence = document.querySelector("#error-message-sequence")
	messageSequence.style.display = "none";
}

export function bindButtonToActions(rubikSocket, rubik3D) {
	const moveButtons = document.querySelectorAll(".move-button")
	for (const moveButton of moveButtons) {
		moveButton.onclick = () => {
			rubikSocket.makeMove(moveButton.innerHTML)
		}
	}
	const getSolvedCubeButton = document.querySelector("#get_solved_cube")
	getSolvedCubeButton.onclick = () => {
		rubikSocket.fetchSolvedCube()
	}
	const getScrambledCubeButton = document.querySelector("#get_scrambled_cube")
	getScrambledCubeButton.onclick = () => {
		rubikSocket.fetchScrambledCube()
	}
	const solveCubeButton = document.querySelector("#solve_cube")
	const solveCrossButton = document.querySelector("#solve_cross")
	const solveF2LButton = document.querySelector("#solve_f2l")
	const solveOLLButton = document.querySelector("#solve_oll")
	solveCubeButton.onclick = () => {
		rubikSocket.solveCube()
	}
	solveCrossButton.onclick = () => {
		rubikSocket.solveCross()
	}
	solveF2LButton.onclick = () => {
		rubikSocket.solveF2L()
	}
	solveOLLButton.onclick = () => {
		rubikSocket.solveOLL()
	}
	const moveAnimationDurationSlider = document.querySelector("#moveAnimationDuration")
	moveAnimationDurationSlider.oninput = (e) => {
		const newValue = e.target.value
		const moveAnimationValueElement = document.querySelector("#moveAnimationValue")
		moveAnimationValueElement.textContent = newValue + "ms"
		rubik3D.setMoveAnimationDuration(newValue)
	}
	const patternButtons = document.querySelectorAll("#patterns-buttons div")
	for (const patternButton of patternButtons) {
		patternButton.onclick = () => {
			rubikSocket.pushPattern(patternButton.id)
		}
	}
	const playInputButton = document.querySelector("#play_input_sequence")
	playInputButton.onclick = () => {
		handleSequenceInput(rubikSocket, rubik3D)
	}
	const reverseInputButton = document.querySelector("#reverse_input_sequence")
	reverseInputButton.onclick = () => {
		handleSequenceInput(rubikSocket, rubik3D, "reverse")
	}

	const textAreaSequence = document.querySelector("#move_sequence_input")
	textAreaSequence.oninput = () => {
		hideSequenceError()
	}
}

export function initRangeInput(rubik3D) {
	const rangeElement = document.querySelector("#moveAnimationDuration")
	const moveAnimationValueElement = document.querySelector("#moveAnimationValue")
	moveAnimationValue = rangeElement.value
	moveAnimationValueElement.textContent = moveAnimationValue + "ms"
	rubik3D.setMoveAnimationDuration(moveAnimationValue)
}

function formatRemainingAnimations(remainingAnimations) {
	return (remainingAnimations.join(" "))
}

export function displayRemainingAnimations(remainingAnimations) {
	const element = document.querySelector("#remaining-animations")
	if (remainingAnimations.length == 0) {
		element.textContent = ""
	}
	else {
		element.textContent = "Remaining moves: " + formatRemainingAnimations(
			remainingAnimations
		)
	}
}

export function displaySolutionBlock(moves) {
	if (moves.length > 0) {
		const solutionBlockElement = document.querySelector("#solution-block")
		const solutionTitleElement = document.createElement("div")
		const solutionElement = document.createElement("div")
		solutionBlockElement.innerHTML = ""
		solutionTitleElement.setAttribute("class", "title-section")
		solutionTitleElement.textContent = "Last solution found (" + moves.length + " move" + 
		(moves.length > 1 ? "s" : "") + ")"
		solutionElement.textContent = moves.join(" ")
		solutionBlockElement.appendChild(solutionTitleElement)
		solutionBlockElement.appendChild(solutionElement)
	}
}

