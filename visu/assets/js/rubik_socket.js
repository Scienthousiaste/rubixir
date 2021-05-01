import {Socket} from "phoenix"

export default class RubikSocket {

	constructor(rubik3D) {
		this.socket = new Socket("/socket", {})
		this.socket.connect()
		this.rubik3D = rubik3D
	}
	
	connectToRubik() {
		this.setupChannel()
		this.channel.on("cube", cube => {
			console.log("cube received in connectToRubik")
			console.dir(cube)	
		})
		this.channel.on("move", msg => {
			console.log("received a move in connectToRubik")
			this.rubik3D.animateMove(msg.move, msg.cube)
		})
	}

	setupChannel() {
		this.channel = this.socket.channel("rubik:cube", {})
		this.channel
			.join()
			.receive("ok", resp => {
				console.log("Connected: ")
				console.dir(resp)
				this.fetchCube()
			})
			.receive("error", resp => {
				alert("An error occurred: " + resp)
			})
	}

	fetchCube() {
		this.channel.push("get_cube", {})
	}

	makeMove(move) {
		this.channel.push("make_move", {move: move})
	}
}
