
export default function bindButtonToActions(rubik3D) {

	const moveButtons = document.querySelectorAll(".move-button")

	for (const moveButton of moveButtons) {
		moveButton.onclick = () => {
			console.log(moveButton.innerHTML)	
			rubik3D.makeMove(moveButton.innerHTML)
		}
	}
}
