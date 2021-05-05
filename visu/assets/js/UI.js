
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

	const solveCrossButton = document.querySelector("#solve_cross")
	solveCrossButton.onclick = () => {
		rubikSocket.solveCross()
	}

	const cubeInCubePatternButton = document.querySelector("#cube_in_cube_pattern")
	cubeInCubePatternButton.onclick = () => {
		rubikSocket.cubeInCubeInCubePattern()
	}


	const moveAnimationDurationSlider = document.querySelector("#moveAnimationDuration")
	moveAnimationDurationSlider.oninput = (e) => {
		const newValue = e.target.value
		const moveAnimationValueElement = document.querySelector("#moveAnimationValue")
		moveAnimationValueElement.textContent = newValue + "ms"
		rubik3D.setMoveAnimationDuration(newValue)
	}

	const saveInputButton = document.querySelector("#save_input_sequence")
	saveInputButton.onclick = () => {
		handleSequenceInput(rubikSocket, rubik3D)
	}
}

export function displayRemainingAnimations(remainingAnimations) {
	const element = document.querySelector("#remaining-animations")
	if (remainingAnimations.length == 0) {
		element.textContent = ""
	}
	else {
		element.textContent = "Remaining moves: " + JSON.stringify(remainingAnimations)
	}
}


function inverseSequence(sequenceString) {
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

function createSequenceButton(sequence, rubikSocket, rubik3D, textButton) {
	const newElement = document.createElement("div")
	newElement.textContent = textButton ? textButton : "do"
	newElement.setAttribute("class", "sequence-button action-button")
	newElement.onclick = () => {
		rubikSocket.makeMoveSequence(sequence)
	}
	return newElement
}

function createSequenceCancelButton(sequence, rubikSocket, rubik3D) {
	return createSequenceButton(inverseSequence(sequence), rubikSocket, rubik3D, "undo")
}

function createSequenceNodeText(sequence) {
	const ret = document.createElement("div")
	ret.textContent = sequence
	return ret
}

function makeRemoveSequenceActionContainer(sequenceButtonContainer) {
	const elt = document.createElement("div")
	elt.textContent = "x"
	elt.setAttribute("class", "remove-sequence")
	elt.onclick = () => {
		sequenceButtonContainer.remove()	
	}
	return elt
}

function createSequenceButtons(sequence, rubikSocket, rubik3D) {
	const sequenceButtonContainer = document.createElement("div")
	sequenceButtonContainer.setAttribute("class", "sequence-button-container")
	sequenceButtonContainer.appendChild(createSequenceNodeText(sequence))
	sequenceButtonContainer.appendChild(
		makeRemoveSequenceActionContainer(sequenceButtonContainer)
	)
	sequenceButtonContainer.appendChild(createSequenceButton(sequence, rubikSocket, rubik3D))
	sequenceButtonContainer.appendChild(createSequenceCancelButton(sequence, rubikSocket, rubik3D))
	
	return sequenceButtonContainer
}

function handleSequenceInput(rubikSocket, rubik3D) {
	const moveSequenceTextarea = document.querySelector("#move_sequence_input")
	const sequence = moveSequenceTextarea.value
	
	if (rubik3D.isValidSequence(sequence)) {
		const sequenceButtonsContainer = 
			document.querySelector("#sequence_buttons_container")
		
		sequenceButtonsContainer.appendChild(createSequenceButtons(sequence, rubikSocket, rubik3D))
	}
	else {
		alert("wrong sequence")
	}
}
