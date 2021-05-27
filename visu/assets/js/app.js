import "../css/app.scss"
import "phoenix_html"

import Rubik3D from "./Rubik3D.js"
import { bindButtonToActions, initRangeInput } from "./UI.js"
import RubikSocket from "./rubik_socket.js"

let rubik3D = {}
const animate = (timeSinceBeginning) => {
	requestAnimationFrame(animate)
	rubik3D.renderScene(timeSinceBeginning)
}

const isOnRubikPage = () => {
	return (window.location.pathname === "/rubik")
}

window.onload = function() {
	if (isOnRubikPage()) {
		manageRubikPage()
	}
}

const manageRubikPage = () => {
	rubik3D = new Rubik3D()
	let rubikSocket = new RubikSocket(rubik3D)
	rubikSocket.connectToRubik()
	bindButtonToActions(rubikSocket, rubik3D)
	initRangeInput(rubik3D)
	animate()
}

