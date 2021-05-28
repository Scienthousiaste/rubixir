import "../css/app.scss"
import "phoenix_html"

import Rubik3D from "./Rubik3D.js"
import { bindButtonToActions, initRangeInput } from "./UI.js"
import RubikSocket from "./rubik_socket.js"
import { CUBE_IN_CUBE_IN_CUBE_PATTERN } from "./constants_3D.js"

let rubik3D = {}
const animate = (timeSinceBeginning) => {
	requestAnimationFrame(animate)
	rubik3D.renderScene(timeSinceBeginning)
}

const isOnRubikPage = () => {
	return (window.location.pathname === "/rubik")
}
const isOnLandingPage = () => {
	return (window.location.pathname === "/")
}

window.onload = function() {
	if (isOnRubikPage()) {
		manageRubikPage()
	}
	if (isOnLandingPage()) {
		manageLandingPage()
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

const manageLandingPage = () => {
	rubik3D = new Rubik3D("noInteraction")
	setTimeout(function() { 
		rubik3D.launchAnimation()
	}, 1000);
	animate()
}
