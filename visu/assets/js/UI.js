
export function bindButtonToActions(rubikSocket) {

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
