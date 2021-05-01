
export default function bindButtonToActions(rubikSocket) {

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
