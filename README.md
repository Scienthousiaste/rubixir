Author: Timothée Behra
Github Repo: https://github.com/Scienthousiaste/rubixir

#Rubixir

Welcome to Rubixir, a Rubik's Cube sandbox built in Elixir, accompanied by a 3D visualization in three.js on a Phoenix server.

## Build and run the project

To build Rubixir, one needs:
	- to install Elixir (sufficient to build the rubik executable)
	- to install Phoenix
	- to have node/npm installed
	- to install the npm dependancies (run "npm install" in the rubixir/visu/assets folder)
	- to install the dependencies of the server by running the command mix deps.get (in the visu folder)

### Troubleshooting mix deps.get

In case mix deps.get in visu doesn't respond properly, run the next two commands in visu:
	- mix deps.unlock --all
	- mix deps.update --all

If you're on MacOS, running the macos_setup_elixir.sh should install elixir and phoenix, otherwise please refer to https://elixir-lang.org/install.html and https://hexdocs.pm/phoenix/installation.html#content.

The rubik executable is then created by running "mix escript.build" in the rubik folder.

## Running the Phoenix server

The phoenix development server, is launched by running "mix phx.server" in the visu folder, and can be seen in action by opening localhost:4000 in a browser.

