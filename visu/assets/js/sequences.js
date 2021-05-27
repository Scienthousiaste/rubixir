
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

export function createSequenceButtons(sequence, rubikSocket, rubik3D) {
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
