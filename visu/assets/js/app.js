import "../css/app.scss"
import "phoenix_html"

import Rubik3D from "./Rubik3D.js"
import bindButtonToActions from "./UI.js"
import RubikSocket from "./rubik_socket.js"

let rubik3D = {}
const animate = () => {
	requestAnimationFrame(animate)
	rubik3D.renderer.render(rubik3D.scene, rubik3D.camera)
}

window.onload = function() {
	rubik3D = new Rubik3D()
	let rubikSocket = new RubikSocket(rubik3D)
	rubikSocket.connectToRubik()
	bindButtonToActions(rubikSocket)
	animate()
}

