import "../css/app.scss"
import "phoenix_html"

import Rubik3D from "./Rubik3D.js"
import { bindButtonToActions } from "./UI.js"
import RubikSocket from "./rubik_socket.js"

let rubik3D = {}
const animate = (timeSinceBeginning) => {
	requestAnimationFrame(animate)
	rubik3D.renderScene(timeSinceBeginning)
}

window.onload = function() {
	rubik3D = new Rubik3D()
	let rubikSocket = new RubikSocket(rubik3D)
	rubikSocket.connectToRubik()
	bindButtonToActions(rubikSocket, rubik3D)
	animate()
}

