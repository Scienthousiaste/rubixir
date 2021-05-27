import { createSequenceButtons } from "./sequences.js"


function handleSequenceInput(rubikSocket, rubik3D) {
	const moveSequenceTextarea = document.querySelector("#move_sequence_input")
	const sequence = moveSequenceTextarea.value
	
	if (rubik3D.isValidSequence(sequence)) {
		const sequenceButtonsContainer = 
			document.querySelector("#sequence_buttons_container")
		sequenceButtonsContainer.appendChild(
			createSequenceButtons(sequence, rubikSocket, rubik3D)
		)
	}
	else {
		alert("wrong sequence")
	}
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

	const saveInputButton = document.querySelector("#save_input_sequence")
	saveInputButton.onclick = () => {
		handleSequenceInput(rubikSocket, rubik3D)
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
