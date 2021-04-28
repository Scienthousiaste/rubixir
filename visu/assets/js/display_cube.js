import * as THREE from "three";
import { OrbitControls } from "./OrbitControls.js";

const DIM_CUBIE = 0.99;
const SQUARE_CAMERA_FRUSTRUM = 300;
const rubik3D = {};
const dims = [0, 1, 2];
const center_factor = ((DIM_CUBIE * dims.length) - DIM_CUBIE) / 2
const cubieGeometry = new THREE.BoxGeometry(
	DIM_CUBIE,
	DIM_CUBIE,
	DIM_CUBIE,
);

const cubieMaterials =[
	new THREE.MeshBasicMaterial({ color: 0xffaa00}),
	new THREE.MeshBasicMaterial({ color: 0xcd1010}),
	new THREE.MeshBasicMaterial({ color: 0xffff00}),
	new THREE.MeshBasicMaterial({ color: 0xfbfbfb}),
	new THREE.MeshBasicMaterial({ color: 0x1010cd}),
	new THREE.MeshBasicMaterial({ color: 0x10cd10}),
];

const initRenderer = (rubik3D) => {
	const renderer = new THREE.WebGLRenderer({ alpha: false });
	renderer.setClearColor(0x00A5FF);
	renderer.setPixelRatio(window.devicePixelRatio);
	renderer.setSize(450, 450);
	rubik3D.renderer = renderer;
};

const initCamera = (rubik3D) => {
	const camera = new THREE.OrthographicCamera(
	   -SQUARE_CAMERA_FRUSTRUM,
		SQUARE_CAMERA_FRUSTRUM,
		SQUARE_CAMERA_FRUSTRUM,
	   -SQUARE_CAMERA_FRUSTRUM,
	);
	camera.zoom = 110;
	camera.position.set(-10, 0, 0);
	camera.near = 0.005;
	camera.updateProjectionMatrix();
	rubik3D.camera = camera;
};

const initScene = (rubik3D) => {
	const scene = new THREE.Scene();
    const ambientLight = new THREE.AmbientLight(0xFCFCFC, 1);
	scene.add(ambientLight);
	rubik3D.scene = scene;
};

const initContainer = (rubik3D) => {
	const container = document.getElementById("cube3D");
	container.appendChild(rubik3D.renderer.domElement);
	rubik3D.container = container; 
};

const addFunctions = (rubik3D) => {
	rubik3D.renderScene = () => {
		rubik3D.renderer.render(rubik3D.scene, rubik3D.camera);
	};
};

const makeCubie = (x, y, z, rubik3D) => {
	if (!rubik3D.cubie_number) rubik3D.cubie_number = 0;
	rubik3D.cubie_number++;

	const cubie = new THREE.Mesh(cubieGeometry, cubieMaterials);
	cubie.name = "cubie" + rubik3D.cubie_number;
	cubie.position.set(
		x - center_factor,
		y - center_factor,
		z - center_factor
	);

	cubie.initialPosition = {x, y, z};
	rubik3D.scene.add(cubie);
	return cubie;
};

const initCube = (rubik3D) => {
	const cubies = [];

	for (let x of dims) {
		for (let y of dims) {
			for (let z of dims) {
				if (!(x === 1 && y === 1 && z ===1)) {
					cubies.push(makeCubie(x, y, z, rubik3D));	
				}
			}
		}
	}
	rubik3D.cubies = cubies;
};

const initControls = (rubik3D) => {
	const controls = new OrbitControls(
		rubik3D.camera,
		rubik3D.renderer.domElement
	);
	controls.enableZoom = false;
	controls.update();
	rubik3D.controls = controls;
}

const animate = () => {
	requestAnimationFrame(animate);
	rubik3D.renderer.render(rubik3D.scene, rubik3D.camera);
}

const initRubik3D = () => {
	initScene(rubik3D);
	initRenderer(rubik3D);
	initContainer(rubik3D);
	initCamera(rubik3D);	
	initCube(rubik3D);
	initControls(rubik3D);
	addFunctions(rubik3D);
	animate();
};

const makeMove = (move) => {
	const group = new THREE.Group();
	switch(move) {
		case "U":
			const cb_U = rubik3D.cubies.filter(cb => cb.initialPosition.y == 2);
			console.log("cb_U", cb_U);
			for (const cb of cb_U) {
				group.add(cb);	
			}
			console.log("GROUP", group);
			group.rotation.y += 1;
			rubik3D.scene.add(group);
			break;
		case "R":
			break;
		default:
			;
	}
};

initRubik3D();
