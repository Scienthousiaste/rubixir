import {Socket} from "phoenix"

export default class RubikSocket {

	constructor(rubik3D) {
		this.socket = new Socket("/socket", {})
		this.socket.connect()
		this.rubik3D = rubik3D
	}
	
	connectToRubik() {
		this.setupChannel()
		this.channel.on("new_cube", msg => {
			console.log("Cube received")
			this.rubik3D.reinitializeCube(msg.cube)
		})
		this.channel.on("move", msg => {
			console.log("Move received: " + msg.move)
			this.rubik3D.animateMove(msg.move, msg.cube)
		})
	}

	setupChannel() {
		this.channel = this.socket.channel("rubik:cube", {})
		this.channel
			.join()
			.receive("ok", resp => {
				console.log("Connected to socket rubik:cube")
			})
			.receive("error", resp => {
				alert("An error occurred: " + resp)
			})
	}

	fetchSolvedCube() {
		this.channel.push("get_solved_cube", {})
	}

	fetchScrambledCube() {
		this.channel.push("get_scrambled_cube", {})
	}

	makeMove(move) {
		this.channel.push("make_move", {move: move})
	}
}
