import RubikSocket from "./rubik_socket.js"

window.onload = function() {
	
	let rubik = new RubikSocket()

	rubik.connectToRubik()
}
