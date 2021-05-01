import "../css/app.scss"
import "phoenix_html"

import initRubik3D from "./rubik_3D.js"
import bindButtonToActions from "./UI.js"
import RubikSocket from "./rubik_socket.js"

window.onload = function() {
	let rubik3D = initRubik3D()
	let rubikSocket = new RubikSocket(rubik3D)

	rubikSocket.connectToRubik()

	bindButtonToActions(rubikSocket)
}
