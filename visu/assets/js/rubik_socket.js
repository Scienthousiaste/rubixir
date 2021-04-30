import {Socket} from "phoenix"

export default class RubikSocket {

	constructor() {
		this.socket = new Socket("/socket", {})
		this.socket.connect()
	}
	
	connectToRubik() {
		this.setupChannel()
		this.channel.on("cube", cube => {
			console.dir(cube)	
		})
	}

	setupChannel() {
		this.channel = this.socket.channel("rubik:cube", {})
		this.channel
			.join()
			.receive("ok", resp => {
				console.log("Connected: " + resp)
				this.fetchCube()
			})
			.receive("error", resp => {
				alert("An error occurred: " + resp)
			})
	}

	fetchCube() {
		this.channel.push("get_cube", {})
	}

}
