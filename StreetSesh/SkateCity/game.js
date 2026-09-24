// SkateCity — a StreetSesh world. three.js rendering + cannon-es physics.
import * as THREE from 'three';
import * as CANNON from 'cannon-es';
import { mergeGeometries } from 'three/addons/utils/BufferGeometryUtils.js';
import { Sky } from 'three/addons/objects/Sky.js';
import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js';
import { RenderPass } from 'three/addons/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/addons/postprocessing/UnrealBloomPass.js';
import { SMAAPass } from 'three/addons/postprocessing/SMAAPass.js';
import { GTAOPass } from 'three/addons/postprocessing/GTAOPass.js';
import { OutputPass } from 'three/addons/postprocessing/OutputPass.js';
import * as A from './assets.js';

/* ============================== utils ============================== */
const $ = (id) => document.getElementById(id);
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const lerp = (a, b, t) => a + (b - a) * t;
const damp = (a, b, k, dt) => lerp(a, b, 1 - Math.exp(-k * dt));
const wrap = (a) => { a = (a + Math.PI) % (Math.PI * 2); if (a < 0) a += Math.PI * 2; return a - Math.PI; };
const dampAngle = (a, b, k, dt) => a + wrap(b - a) * (1 - Math.exp(-k * dt));
const rand = (a, b) => a + Math.random() * (b - a);
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
let seed = 20260922;
const srand = () => { seed = (seed * 16807) % 2147483647; return (seed - 1) / 2147483646; };
const srange = (a, b) => a + srand() * (b - a);
const fmt = (n) => Math.round(n).toLocaleString('en-US');
const V3 = (x = 0, y = 0, z = 0) => new THREE.Vector3(x, y, z);

/* ============================== renderer ============================== */
const canvas = $('game');
const renderer = new THREE.WebGLRenderer({ canvas, antialias: true, powerPreference: 'high-performance' });
renderer.setPixelRatio(Math.min(devicePixelRatio, 1.75));
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;
const SKY = '#e3ebf1';
const scene = new THREE.Scene();
scene.background = new THREE.Color(SKY);
scene.fog = new THREE.Fog(SKY, 120, 320);
const camera = new THREE.PerspectiveCamera(62, 1, 0.2, 2000);
let composer = null, bloomPass = null;
function resize() { renderer.setSize(innerWidth, innerHeight, false); camera.aspect = innerWidth / innerHeight; camera.updateProjectionMatrix(); if (composer) composer.setSize(innerWidth, innerHeight); }
addEventListener('resize', resize); resize();

const hemi = new THREE.HemisphereLight('#ffffff', '#d6cfc2', 1.2);
scene.add(hemi);
const sun = new THREE.DirectionalLight('#fff4e2', 1.45);
sun.castShadow = true;
sun.shadow.mapSize.set(2048, 2048);
Object.assign(sun.shadow.camera, { left: -45, right: 45, top: 45, bottom: -45, near: 1, far: 220 });
sun.shadow.bias = -0.0005; sun.shadow.normalBias = 0.04;
scene.add(sun, sun.target);

/* ============================== graphics: sky, time of day, quality ============================== */
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 0.85;
scene.background = null;
const sky = new Sky(); sky.scale.setScalar(4000); scene.add(sky);
const envScene = new THREE.Scene(); const envSky = new Sky(); envSky.scale.setScalar(100); envScene.add(envSky);
const pmrem = new THREE.PMREMGenerator(renderer);
let envRT = null;
const sunDir = V3(0.4, 0.8, 0.3).normalize();
const G = { time: 'day', quality: 'high', uTime: { value: 0 }, uNight: { value: 0 } };
let waterMat = null, lampPools = null, lampHeadMat = null;
const TIMES = {
  day:    { label: 'Day',         elev: 50,  azim: 140, env: 0.3, sun: '#fff1de', sunI: 2.9, hemiI: 0.35, hemiSky: '#dfeaf5', hemiGround: '#cfc6b6', exposure: 0.62, fog: '#d6e2ec', fogNear: 140, fogFar: 520, turb: 3.5, ray: 1.1, night: 0,   bloom: 0.18, water: '#3f8fc4' },
  golden: { label: 'Golden hour', elev: 13,  azim: 250, env: 0.22, sun: '#ffb56b', sunI: 3.6, hemiI: 0.28, hemiSky: '#f6d2a8', hemiGround: '#9c7c62', exposure: 0.72, fog: '#e9c9a6', fogNear: 110, fogFar: 460, turb: 7,   ray: 2.6, night: 0.2, bloom: 0.35, water: '#5a86a8' },
  dusk:   { label: 'Dusk',        elev: 1.5, azim: 262, env: 0.35, sun: '#ff8a55', sunI: 1.2, hemiI: 0.3, hemiSky: '#6f7fb0', hemiGround: '#3c3a48', exposure: 0.9, fog: '#5d6283', fogNear: 80,  fogFar: 380, turb: 9,   ray: 3.2, night: 1,   bloom: 0.45, water: '#2f4a6e' },
};
const QUALITY = {
  low:   { label: 'Low',   dpr: 1,   shadow: 1024, ext: 40, post: false, ao: false },
  high:  { label: 'High',  dpr: 1.5, shadow: 2048, ext: 45, post: true,  ao: false },
  ultra: { label: 'Ultra', dpr: 2,   shadow: 4096, ext: 60, post: true,  ao: true },
};
function setTime(name) {
  const t = TIMES[name]; G.time = name;
  sunDir.setFromSphericalCoords(1, THREE.MathUtils.degToRad(90 - t.elev), THREE.MathUtils.degToRad(t.azim));
  for (const sk of [sky, envSky]) {
    const u = sk.material.uniforms;
    u.turbidity.value = t.turb; u.rayleigh.value = t.ray; u.mieCoefficient.value = 0.005; u.mieDirectionalG.value = 0.82; u.sunPosition.value.copy(sunDir);
  }
  if (envRT) envRT.dispose();
  envRT = pmrem.fromScene(envScene, 0.02); scene.environment = envRT.texture;
  sun.color.set(t.sun); sun.intensity = t.sunI;
  hemi.intensity = t.hemiI; hemi.color.set(t.hemiSky); hemi.groundColor.set(t.hemiGround);
  renderer.toneMappingExposure = t.exposure;
  scene.fog.color.set(t.fog); scene.fog.near = t.fogNear; scene.fog.far = t.fogFar;
  G.uNight.value = t.night; A.setNight(t.night);
  scene.traverse((o) => { const ms = o.material ? (Array.isArray(o.material) ? o.material : [o.material]) : []; for (const m of ms) if ('envMapIntensity' in m) m.envMapIntensity = t.env * (m.userData.envBoost || (m.clearcoat ? 2.2 : m.metalness > 0.5 ? 1.8 : 1)); });
  if (bloomPass) bloomPass.strength = t.bloom;
  if (waterMat) waterMat.color.set(t.water);
  if (lampPools) { lampPools.visible = t.night > 0.1; lampPools.material.opacity = 0.55 * t.night; }
  if (lampHeadMat) { lampHeadMat.emissive.set('#ffd49a'); lampHeadMat.emissiveIntensity = t.night * 5; }
  const b = document.getElementById('time-btn'); if (b) b.textContent = t.label;
}
function setQuality(q) {
  const Q = QUALITY[q]; G.quality = q;
  renderer.setPixelRatio(Math.min(devicePixelRatio, Q.dpr));
  sun.shadow.mapSize.set(Q.shadow, Q.shadow);
  if (sun.shadow.map) { sun.shadow.map.dispose(); sun.shadow.map = null; }
  Object.assign(sun.shadow.camera, { left: -Q.ext, right: Q.ext, top: Q.ext, bottom: -Q.ext }); sun.shadow.camera.updateProjectionMatrix();
  if (composer) { composer.passes.forEach((p) => p.dispose && p.dispose()); composer = null; bloomPass = null; }
  if (Q.post) {
    composer = new EffectComposer(renderer);
    composer.addPass(new RenderPass(scene, camera));
    if (Q.ao) {
      const ao = new GTAOPass(scene, camera, innerWidth, innerHeight);
      ao.updateGtaoMaterial({ radius: 0.9, distanceExponent: 1.5, thickness: 1.5, scale: 1.2, samples: 12 });
      ao.blendIntensity = 0.85; composer.addPass(ao);
    }
    bloomPass = new UnrealBloomPass(new THREE.Vector2(innerWidth, innerHeight), TIMES[G.time].bloom, 0.35, 0.95);
    composer.addPass(bloomPass);
    composer.addPass(new OutputPass());
    composer.addPass(new SMAAPass(innerWidth * renderer.getPixelRatio(), innerHeight * renderer.getPixelRatio()));
  }
  resize();
  const b = document.getElementById('gfx-btn'); if (b) b.textContent = Q.label;
}
function renderFrame() { if (composer) composer.render(); else renderer.render(scene, camera); }

/* --- shader detail: world-space procedural surfaces (no image files needed) --- */
const GLSL_NOISE = `
float h21(vec2 p){ p = fract(p * vec2(123.34, 456.21)); p += dot(p, p + 45.32); return fract(p.x * p.y); }
float vn(vec2 p){ vec2 i = floor(p), f = fract(p); f = f * f * (3.0 - 2.0 * f);
  return mix(mix(h21(i), h21(i + vec2(1.0, 0.0)), f.x), mix(h21(i + vec2(0.0, 1.0)), h21(i + vec2(1.0, 1.0)), f.x), f.y); }
float fbm(vec2 p){ float s = 0.0, a = 0.5; for (int i = 0; i < 4; i++) { s += a * vn(p); p *= 2.03; a *= 0.5; } return s; }
`;
function patch(material, key, { color = '', rough = '', metal = '', emis = '', vert = '' } = {}) {
  material.onBeforeCompile = (sh) => {
    sh.uniforms.uTime = G.uTime; sh.uniforms.uNight = G.uNight;
    sh.vertexShader = sh.vertexShader
      .replace('#include <common>', '#include <common>\nvarying vec3 vWP; varying vec3 vWN; uniform float uTime;')
      .replace('#include <begin_vertex>', '#include <begin_vertex>\n' + vert)
      .replace('#include <project_vertex>', `#include <project_vertex>
        { vec4 wp = vec4(transformed, 1.0);
          #ifdef USE_INSTANCING
          wp = instanceMatrix * wp;
          #endif
          wp = modelMatrix * wp; vWP = wp.xyz; vWN = normalize(mat3(modelMatrix) * objectNormal); }`);
    sh.fragmentShader = sh.fragmentShader
      .replace('#include <common>', '#include <common>\nvarying vec3 vWP; varying vec3 vWN; uniform float uTime; uniform float uNight;\n' + GLSL_NOISE)
      .replace('#include <color_fragment>', '#include <color_fragment>\n' + color)
      .replace('#include <roughnessmap_fragment>', '#include <roughnessmap_fragment>\n' + rough)
      .replace('#include <metalnessmap_fragment>', '#include <metalnessmap_fragment>\n' + metal)
      .replace('#include <emissivemap_fragment>', '#include <emissivemap_fragment>\n' + emis);
  };
  material.customProgramCacheKey = () => key;
  return material;
}
const ROADGRID = `
  float rdx = abs(mod(vWP.x + 168.0 + 28.0, 56.0) - 28.0);
  float rdz = abs(mod(vWP.z + 168.0 + 28.0, 56.0) - 28.0);
  float wear = (1.0 - smoothstep(0.15, 0.8, abs(rdx - 2.4))) * step(4.6, rdz) + (1.0 - smoothstep(0.15, 0.8, abs(rdz - 2.4))) * step(4.6, rdx);
`;
const SURF = {
  road: { color: ROADGRID + `
    float an = fbm(vWP.xz * 1.9); float big = fbm(vWP.xz * 0.06);
    float spk = step(0.92, h21(floor(vWP.xz * 30.0)));
    float patchy = smoothstep(0.55, 0.7, fbm(vWP.xz * 0.12 + 7.0));
    diffuseColor.rgb *= (0.84 + 0.2 * an + 0.07 * spk - 0.12 * big) * (1.0 - 0.1 * wear) * (1.0 - 0.07 * patchy);`,
    rough: `roughnessFactor = clamp(0.92 - 0.25 * wear - 0.1 * vn(vWP.xz * 3.0), 0.4, 1.0);` },
  sidewalk: { color: `
    vec2 tg = abs(fract(vWP.xz / 1.5) - 0.5); float joint = smoothstep(0.465, 0.49, max(tg.x, tg.y));
    float tv = h21(floor(vWP.xz / 1.5));
    diffuseColor.rgb *= (1.0 - 0.22 * joint) * (0.94 + 0.08 * tv) * (0.93 + 0.1 * fbm(vWP.xz * 2.5));`,
    rough: `roughnessFactor = 0.9;` },
  ground: { color: `
    float g1 = fbm(vWP.xz * 0.35), g2 = fbm(vWP.xz * 6.0);
    float isGrass = step(diffuseColor.r + 0.05, diffuseColor.g);
    diffuseColor.rgb *= mix(0.9 + 0.14 * g1 + 0.05 * g2, 0.75 + 0.35 * g1 + 0.15 * g2, isGrass);
    diffuseColor.rgb = mix(diffuseColor.rgb, diffuseColor.rgb * vec3(1.08, 1.02, 0.8), isGrass * smoothstep(0.55, 0.8, g1));`,
    rough: `roughnessFactor = 0.95;` },
  paint: { color: `diffuseColor.rgb *= 0.86 + 0.14 * fbm(vWP.xz * 5.0); diffuseColor.rgb = mix(diffuseColor.rgb, vec3(0.6), 0.25 * step(0.72, fbm(vWP.xz * 1.3)));`,
    rough: `roughnessFactor = 0.6;` },
  concrete: { color: `
    diffuseColor.rgb *= 0.88 + 0.18 * fbm(vWP.xz * 1.4 + vWP.y * 1.4);
    diffuseColor.rgb *= mix(0.68, 1.0, smoothstep(0.0, 0.45, vWP.y));
    float pier = step(178.9, vWP.x) * step(vWP.x, 189.1) * step(3.0, vWP.y) * step(vWP.y, 3.6) * step(0.9, normalize(vWN).y);
    float plank = smoothstep(0.42, 0.48, abs(fract(vWP.z / 0.28) - 0.5));
    diffuseColor.rgb *= mix(1.0, (1.0 - 0.4 * plank) * (0.82 + 0.3 * h21(vec2(floor(vWP.z / 0.28), 3.0))), pier);` },
  building: { color: `
    vec3 fN = normalize(vWN);
    float fWall = 1.0 - step(0.6, abs(fN.y));
    float fU = abs(fN.x) > 0.5 ? vWP.z : vWP.x;
    float fV = vWP.y;
    vec2 fCell = vec2(fU / 2.9, (fV - 0.4) / 3.5);
    vec2 fF = fract(fCell); vec2 fId = floor(fCell);
    float fSeed = h21(floor(vWP.xz / 9.0) + fN.xz * 3.1);
    float fH = h21(fId + fSeed * 31.0);
    float upper = step(3.9, fV);
    float fWin = step(0.17, fF.x) * step(fF.x, 0.83) * step(0.22, fF.y) * step(fF.y, 0.8) * upper;
    float fStore = step(0.45, fV) * step(fV, 3.25) * step(0.06, fract(fU / 5.2)) * step(fract(fU / 5.2), 0.94);
    fWin = max(fWin, fStore) * fWall;
    float fSill = fWall * upper * step(0.8, fF.y) * step(fF.y, 0.86) * step(0.14, fF.x) * step(fF.x, 0.86);
    float fBand = 1.0 - fWall * (1.0 - step(0.05, fract((fV - 0.4) / 3.5))) * 0.12;
    vec3 fGlass = mix(vec3(0.08, 0.11, 0.15), vec3(0.2, 0.26, 0.33), fH);
    diffuseColor.rgb *= fBand * (1.0 + 0.25 * fSill);
    diffuseColor.rgb *= 0.94 + 0.1 * vn(vec2(fU, fV) * 0.9);
    diffuseColor.rgb = mix(diffuseColor.rgb, fGlass, fWin);
    diffuseColor.rgb *= mix(0.66, 1.0, smoothstep(0.0, 1.6, fV));`,
    rough: `roughnessFactor = mix(roughnessFactor, 0.05, fWin);`,
    metal: `metalnessFactor = mix(metalnessFactor, 0.7, fWin);`,
    emis: `float fLit = step(0.6, h21(fId * 1.7 + 3.1 + fSeed)) * fWin * upper + fStore * fWall;
      totalEmissiveRadiance += vec3(1.0, 0.74, 0.45) * fLit * uNight * (0.35 + 0.7 * fH);` },
};


/* ============================== physics ============================== */
const world = new CANNON.World({ gravity: new CANNON.Vec3(0, -12, 0) });
world.broadphase = new CANNON.SAPBroadphase(world);
world.allowSleep = true;
world.defaultContactMaterial.friction = 0.35;
world.defaultContactMaterial.restitution = 0.05;
const M_GROUND = new CANNON.Material('ground');
const M_PLAYER = new CANNON.Material('player');
world.addContactMaterial(new CANNON.ContactMaterial(M_GROUND, M_PLAYER, { friction: 0, restitution: 0 }));
const G_WORLD = 1, G_PLAYER = 2, G_DEBRIS = 4;
const Y_AXIS = new CANNON.Vec3(0, 1, 0), X_AXIS = new CANNON.Vec3(1, 0, 0);

function staticBox(w, h, d, x, y, z, rotY = 0, rotX = 0) {
  const b = new CANNON.Body({ mass: 0, material: M_GROUND, collisionFilterGroup: G_WORLD });
  b.addShape(new CANNON.Box(new CANNON.Vec3(w / 2, h / 2, d / 2)));
  b.position.set(x, y, z);
  const qy = new CANNON.Quaternion().setFromAxisAngle(Y_AXIS, rotY);
  const qx = new CANNON.Quaternion().setFromAxisAngle(X_AXIS, rotX);
  b.quaternion.copy(qy.mult(qx));
  world.addBody(b);
  return b;
}

/* ============================== city layout ============================== */
const N = 6, CELL = 56, ROADW = 9, HALF = (N * CELL) / 2;
const roadAt = (i) => -HALF + i * CELL;              // road centre lines, i = 0..N
const blockAt = (i) => -HALF + (i + 0.5) * CELL;     // block centres, i = -1..N
const SIDE = (CELL - ROADW) / 2;                     // block half-size incl. sidewalk (23.5)
const LOT = SIDE - 3.2;                              // buildable half-size
const EAST_EDGE = HALF + 31;                         // seawall

// merged, vertex-coloured geometry buckets (keeps draw calls low)
const buckets = {};
const tmpColor = new THREE.Color();
function addGeo(bucket, geo, color, matrix) {
  const g = geo.index ? geo.toNonIndexed() : geo;
  if (matrix) g.applyMatrix4(matrix);
  tmpColor.set(color);
  const n = g.attributes.position.count, c = new Float32Array(n * 3);
  for (let i = 0; i < n; i++) { c[i * 3] = tmpColor.r; c[i * 3 + 1] = tmpColor.g; c[i * 3 + 2] = tmpColor.b; }
  g.setAttribute('color', new THREE.BufferAttribute(c, 3));
  for (const k of Object.keys(g.attributes)) if (!['position', 'normal', 'color'].includes(k)) g.deleteAttribute(k);
  (buckets[bucket] ||= []).push(g);
}
const M4 = new THREE.Matrix4(), Q4 = new THREE.Quaternion(), S4 = V3(1, 1, 1), E4 = new THREE.Euler();
function mtx(x, y, z, ry = 0, rx = 0) { E4.set(rx, ry, 0, 'YXZ'); Q4.setFromEuler(E4); return M4.clone().compose(V3(x, y, z), Q4, S4); }
function decal(w, d, x, z, y, color, ry = 0) { addGeo('decal' + Math.round(y * 100), new THREE.PlaneGeometry(w, d).rotateX(-Math.PI / 2), color, mtx(x, y, z, ry)); }
function solid(w, h, d, x, y, z, color, { ry = 0, physics = true, bucket = 'solid' } = {}) {
  addGeo(bucket, new THREE.BoxGeometry(w, h, d), color, mtx(x, y + h / 2, z, ry));
  if (physics) staticBox(w, h, d, x, y + h / 2, z, ry);
}

const footprints = [];   // for the minimap
const mapAreas = [];     // {x,z,w,d,color}
const grindSegs = [];    // {a:Vector3, b:Vector3, kind}
const spots = {};        // named places
const treeSpots = [], lightSpots = [];

// --- ground + water
staticBox(900, 2, 900, 0, -1, 0);
{
  const land = new THREE.Mesh(new THREE.PlaneGeometry(900, 900).rotateX(-Math.PI / 2), patch(new THREE.MeshStandardMaterial({ color: A.PALETTE.land, roughness: 1 }), 'land', SURF.ground));
  land.receiveShadow = true; scene.add(land);
  const wn = waterNormals(); wn.repeat.set(70, 160);
  const wn2 = wn.clone(); wn2.repeat.set(23, 51); wn2.needsUpdate = true;
  waterMat = new THREE.MeshPhysicalMaterial({ color: A.PALETTE.water, roughness: 0.12, metalness: 0.05, normalMap: wn, normalScale: new THREE.Vector2(0.55, 0.55), clearcoat: 1, clearcoatRoughness: 0.03, clearcoatNormalMap: wn2, clearcoatNormalScale: new THREE.Vector2(0.35, 0.35) }); waterMat.userData.envBoost = 3;
  const water = new THREE.Mesh(new THREE.PlaneGeometry(400, 900).rotateX(-Math.PI / 2), waterMat);
  water.position.set(EAST_EDGE + 200, 0.03, 0); water.receiveShadow = true; scene.add(water);
  mapAreas.push({ x: EAST_EDGE + 200, z: 0, w: 400, d: 900, color: A.PALETTE.water });
}

// --- roads, sidewalks, markings
const SPAN = HALF + CELL; // roads extend into the outer ring
for (let i = 0; i <= N; i++) {
  const r = roadAt(i);
  const lenZ = i === N ? SPAN * 2 : SPAN * 2;
  decal(ROADW, lenZ, r, 0, 0.03, A.PALETTE.road);
  decal(SPAN * 2, ROADW, 0, r, 0.03, A.PALETTE.road);
  // dashed centre lines + crosswalks
  for (let j = -1; j <= N; j++) {
    const b = blockAt(j);
    for (let k = -SIDE + 3; k < SIDE - 3; k += 5) {
      decal(0.18, 2.2, r, b + k, 0.05, A.PALETTE.roadLine);
      decal(2.2, 0.18, b + k, r, 0.05, A.PALETTE.roadLine);
    }
    for (const s of [-1, 1]) for (let w = -3.6; w <= 3.6; w += 1.2) {
      decal(0.6, 2.4, r + w, b + s * (SIDE - 1.6), 0.05, '#f7f7f7');
      decal(2.4, 0.6, b + s * (SIDE - 1.6), r + w, 0.05, '#f7f7f7');
    }
  }
  for (const s of [-1, 1]) { decal(0.4, SPAN * 2, r + s * (ROADW / 2 + 0.2), 0, 0.05, A.PALETTE.curb); decal(SPAN * 2, 0.4, 0, r + s * (ROADW / 2 + 0.2), 0.05, A.PALETTE.curb); }
  mapAreas.push({ x: r, z: 0, w: ROADW, d: SPAN * 2, color: '#ffffff', road: true });
  mapAreas.push({ x: 0, z: r, w: SPAN * 2, d: ROADW, color: '#ffffff', road: true });
}

// --- blocks
const special = {
  '2,2': 'plaza', '3,3': 'kickerpark', '1,4': 'park', '4,1': 'park', '4,4': 'park-small',
};
function buildingsIn(cx, cz, half, tall = false) {
  const n = srand() < 0.35 ? 1 : 2;
  const lot = (half * 2) / n;
  for (let a = 0; a < n; a++) for (let b = 0; b < n; b++) {
    if (n === 2 && srand() < 0.12) { treeSpots.push([cx - half + lot * (a + 0.5), cz - half + lot * (b + 0.5)]); continue; }
    const w = lot * srange(0.72, 0.95), d = lot * srange(0.72, 0.95);
    const x = cx - half + lot * (a + 0.5), z = cz - half + lot * (b + 0.5);
    const h = tall ? srange(18, 56) : (srand() < 0.2 ? srange(28, 48) : srange(8, 24));
    const col = A.PALETTE.building[Math.floor(srand() * A.PALETTE.building.length)];
    solid(w, h, d, x, 0, z, col, { bucket: 'building' });
    solid(w + 0.4, 0.4, d + 0.4, x, h, z, A.PALETTE.roof, { physics: false });
    if (h > 26) solid(w * 0.35, 2.4, d * 0.3, x + w * 0.15, h + 0.4, z - d * 0.1, A.PALETTE.roof, { physics: false });
    footprints.push({ x, z, w, d, h });
  }
}
for (let i = -1; i <= N; i++) for (let j = -1; j <= N; j++) {
  const cx = blockAt(i), cz = blockAt(j);
  const outer = i < 0 || j < 0 || i >= N || j >= N;
  if (i >= N) continue; // east side is the waterfront
  decal(SIDE * 2, SIDE * 2, cx, cz, 0.02, A.PALETTE.sidewalk);
  const kind = special[`${i},${j}`];
  if (outer) { buildingsIn(cx, cz, LOT, true); continue; }
  if (!kind) {
    buildingsIn(cx, cz, LOT);
    for (const s of [-1, 1]) for (let k = -SIDE + 6; k < SIDE - 4; k += 11) {
      if (srand() < 0.55) treeSpots.push([cx + k, cz + s * (SIDE - 0.9)]);
      if (srand() < 0.45) treeSpots.push([cx + s * (SIDE - 0.9), cz + k]);
    }
  } else if (kind.startsWith('park')) {
    decal(LOT * 2 + 3, LOT * 2 + 3, cx, cz, 0.04, A.PALETTE.park);
    mapAreas.push({ x: cx, z: cz, w: LOT * 2 + 3, d: LOT * 2 + 3, color: A.PALETTE.park });
    decal(3, LOT * 2 + 3, cx, cz, 0.05, '#ece6da'); decal(LOT * 2 + 3, 3, cx, cz, 0.05, '#ece6da');
    for (let t = 0; t < (kind === 'park' ? 26 : 12); t++) {
      const x = cx + srange(-LOT, LOT), z = cz + srange(-LOT, LOT);
      if (Math.abs(x - cx) > 3 && Math.abs(z - cz) > 3) treeSpots.push([x, z, srange(0.8, 1.3)]);
    }
    if (kind === 'park') {
      addProp(A.makeBench(), cx + 4, cz + 8, Math.PI / 2); addProp(A.makeBench(), cx - 4, cz - 8, -Math.PI / 2);
      grindSegs.push({ a: V3(cx + 4, 0.45, cz + 7.1), b: V3(cx + 4, 0.45, cz + 8.9), kind: 'ledge' });
      staticBox(0.45, 0.45, 1.8, cx + 4, 0.225, cz + 8); staticBox(0.45, 0.45, 1.8, cx - 4, 0.225, cz - 8);
    }
    spots[kind === 'park' ? `park${i}${j}` : 'minipark'] = V3(cx, 0, cz);
  }
}

function addProp(obj, x, z, ry = 0, y = 0) { obj.position.set(x, y, z); obj.rotation.y = ry; obj.traverse((m) => { if (m.isMesh) { m.castShadow = true; m.receiveShadow = true; } }); scene.add(obj); return obj; }

// rails: visual + thin physics bar + grind line
function rail(ax, ay, az, bx, by, bz, h = 0.45) {
  const a = V3(ax, ay + h, az), b = V3(bx, by + h, bz);
  const len = a.distanceTo(b), dir = b.clone().sub(a).normalize(), mid = a.clone().add(b).multiplyScalar(0.5);
  const bar = new THREE.Mesh(new THREE.CylinderGeometry(0.035, 0.035, len, 10), A.mat('#c3cad3', { metalness: 0.6, roughness: 0.35 }));
  bar.position.copy(mid); bar.quaternion.setFromUnitVectors(V3(0, 1, 0), dir); bar.castShadow = true; scene.add(bar);
  for (const t of [0.06, 0.94]) {
    const p = a.clone().lerp(b, t); const base = t < 0.5 ? ay : by;
    const post = new THREE.Mesh(new THREE.CylinderGeometry(0.03, 0.03, p.y - base, 8), A.mat('#8f98a3'));
    post.position.set(p.x, (p.y + base) / 2, p.z); post.castShadow = true; scene.add(post);
  }
  const ry = Math.atan2(dir.x, dir.z), rx = -Math.asin(dir.y);
  staticBox(0.07, 0.07, len, mid.x, mid.y, mid.z, ry, rx);
  grindSegs.push({ a, b, kind: 'rail' });
}
function ledge(x, z, len, ry = 0, h = 0.45, w = 0.7, y = 0) {
  solid(w, h, len, x, y, z, A.PALETTE.concrete, { ry });
  const d = V3(Math.sin(ry), 0, Math.cos(ry)).multiplyScalar(len / 2 - 0.1);
  const side = V3(Math.cos(ry), 0, -Math.sin(ry)).multiplyScalar(w / 2 - 0.05);
  for (const s of [-1, 1]) {
    const o = side.clone().multiplyScalar(s);
    grindSegs.push({ a: V3(x, y + h, z).add(o).sub(d), b: V3(x, y + h, z).add(o).add(d), kind: 'ledge' });
  }
  addGeo('solid', new THREE.BoxGeometry(0.06, 0.04, len), '#98a1ab', mtx(x + side.x, y + h + 0.01, z + side.z, ry));
}
// kicker: visual wedge rising toward local +Z and matching tilted physics box
function kicker(x, z, ry, w = 3, len = 3, h = 0.9, y = 0) {
  addGeo('solid', A.kickerGeometry(w, len, h), '#d9c6a8', mtx(x, y, z, ry));
  addGeo('solid', new THREE.BoxGeometry(w, 0.05, 0.1), '#98a1ab', mtx(x + Math.sin(ry) * (len / 2 - 0.05), y + h, z + Math.cos(ry) * (len / 2 - 0.05), ry));
  const a = Math.atan2(h, len), hyp = Math.hypot(h, len), t = 0.3;
  const lc = V3(0, h / 2 - Math.cos(a) * t / 2, Math.sin(a) * t / 2).applyAxisAngle(V3(0, 1, 0), ry);
  staticBox(w, t, hyp, x + lc.x, y + lc.y, z + lc.z, ry, -a);
}

/* --- Sesh Plaza (block 2,2) --- */
{
  const cx = blockAt(2), cz = blockAt(2);
  decal(LOT * 2 + 4, LOT * 2 + 4, cx, cz, 0.04, '#e6e1d9');
  for (let k = -LOT; k <= LOT; k += 4) { decal(0.12, LOT * 2 + 4, cx + k, cz, 0.05, '#d9d3c9'); decal(LOT * 2 + 4, 0.12, cx, cz + k, 0.05, '#d9d3c9'); }
  mapAreas.push({ x: cx, z: cz, w: LOT * 2 + 4, d: LOT * 2 + 4, color: '#efe6d8' });
  // raised platform + five-stair
  const top = 0.9;
  solid(20, top, 9, cx, 0, cz + 12.5, '#d4d0c9');
  const steps = 5, rise = top / steps, run = 0.4;
  for (let s = 0; s < steps; s++) solid(8, top - rise * (s + 1) + 0.001, run, cx - 4, 0, cz + 8 - run * (s + 0.5), '#cbc7c0');
  rail(cx + 0.4, top, cz + 8.3, cx + 0.4, 0, cz + 8 - steps * run - 0.3, 0.55);
  grindSegs.push({ a: V3(cx + 0.8, top, cz + 8), b: V3(cx + 10, top, cz + 8), kind: 'ledge' });
  kicker(cx - 11.5, cz + 12.5, Math.PI / 2, 4, 3, top);
  spots.stairs = { min: V3(cx - 9, 0, cz + 1.5), max: V3(cx + 1, 0, cz + 7.9) };
  // ledges, flat rail, manual pad, benches
  ledge(cx - 6, cz - 2, 7, Math.PI / 2);
  ledge(cx + 7, cz - 5, 8, 0);
  rail(cx - 11, 0, cz - 10, cx - 3, 0, cz - 10, 0.4);
  solid(5, 0.22, 2.6, cx + 10, 0, cz - 14, '#cfcac2');
  ledge(cx - 14, cz + 2, 5, 0, 0.5, 1.2);
  for (const [tx, tz] of [[-15, -15], [15, -15], [-15, 4], [15, 4]]) treeSpots.push([cx + tx, cz + tz, 0.9]);
  spots.plaza = V3(cx, 0, cz);
}

/* --- Kicker Park (block 3,3) --- */
{
  const cx = blockAt(3), cz = blockAt(3);
  decal(LOT * 2 + 4, LOT * 2 + 4, cx, cz, 0.04, '#dcd6cc');
  mapAreas.push({ x: cx, z: cz, w: LOT * 2 + 4, d: LOT * 2 + 4, color: '#e6ddcd' });
  kicker(cx - 8, cz - 11, 0, 3, 3, 0.9);
  kicker(cx - 8, cz + 11, Math.PI, 3, 3, 0.9);
  // funbox: up-kicker, deck, down-kicker, rail on top
  kicker(cx + 8, cz - 5.5, 0, 4, 3, 0.9);
  solid(4, 0.9, 5, cx + 8, 0, cz - 1.5, '#d9c6a8');
  kicker(cx + 8, cz + 2.5, Math.PI, 4, 3, 0.9);
  rail(cx + 8, 0.9, cz - 3.6, cx + 8, 0.9, cz + 0.6, 0.35);
  grindSegs.push({ a: V3(cx + 6, 0.9, cz - 4), b: V3(cx + 6, 0.9, cz + 1), kind: 'ledge' });
  grindSegs.push({ a: V3(cx + 10, 0.9, cz - 4), b: V3(cx + 10, 0.9, cz + 1), kind: 'ledge' });
  kicker(cx - 2, cz - 16, 0, 4, 4.5, 1.5);
  rail(cx + 16, 0, cz - 12, cx + 16, 0, cz + 10, 0.35);
  ledge(cx - 15, cz, 12, 0, 0.5, 0.9);
  spots.kickerpark = V3(cx, 0, cz);
}

/* --- Waterfront + The Pier (east) --- */
{
  const x0 = HALF + ROADW / 2, x1 = EAST_EDGE;
  decal(x1 - x0, SPAN * 2, (x0 + x1) / 2, 0, 0.02, '#ebe5db');
  mapAreas.push({ x: (x0 + x1) / 2, z: 0, w: x1 - x0, d: SPAN * 2, color: '#f3ede3' });
  solid(1.2, 0.9, SPAN * 2, x1 + 0.6, 0, 0, '#bfb8ad');
  staticBox(2, 12, SPAN * 2, x1 + 1.5, 6, 0);
  // pier: 40 m ramp up to 3.5 m, 60 m deck, open drop at the end
  const px = HALF + 16, pw = 10, ph = 3.5;
  const ra = Math.atan2(ph, 40), rl = Math.hypot(ph, 40);
  addGeo('solid', new THREE.BoxGeometry(pw, 0.3, rl), '#c9b9a0', mtx(px, ph / 2 - 0.15, -40, 0, -ra));
  staticBox(pw, 0.3, rl, px, ph / 2 - 0.15 * Math.cos(ra), -40 + 0.15 * Math.sin(ra), 0, -ra);
  solid(pw, 0.3, 60, px, ph - 0.3, 10, '#c9b9a0');
  for (let z = -15; z <= 38; z += 6) for (const s of [-1, 1]) solid(0.5, ph - 0.3, 0.5, px + s * (pw / 2 - 0.5), 0, z, '#a89a86');
  for (const s of [-1, 1]) rail(px + s * (pw / 2 - 0.2), ph, -19.5, px + s * (pw / 2 - 0.2), ph, 39.5, 0.7);
  for (let k = 0; k < 8; k++) treeSpots.push([x0 + 4, -140 + k * 36, 1]);
  spots.pier = V3(px, ph, 36);
  spots.pierBase = V3(px, 0, -62);
  mapAreas.push({ x: px, z: -10, w: pw, d: 100, color: '#dccbb0' });
}

// boundary walls (invisible)
staticBox(4, 20, SPAN * 2 + 60, -HALF - CELL - 4, 10, 0);
staticBox(SPAN * 2 + 120, 20, 4, 40, 10, HALF + CELL + 4);
staticBox(SPAN * 2 + 120, 20, 4, 40, 10, -HALF - CELL - 4);

// trees (instanced) + street lights
for (let i = 0; i < N; i++) for (let j = 1; j < N; j += 2) lightSpots.push([roadAt(i) + 5.6, blockAt(j) - 10], [blockAt(j) + 10, roadAt(i) + 5.6]);
{
  const trunk = new THREE.InstancedMesh(new THREE.CylinderGeometry(0.14, 0.2, 3.2, 7), A.mat('#a58a6a'), treeSpots.length);
  const WIND = `vec4 ip = instanceMatrix[3]; float sway = (position.y + 1.4) * 0.05;
    transformed.x += sin(uTime * 1.4 + ip.x * 0.31 + ip.z * 0.17) * sway; transformed.z += cos(uTime * 1.1 + ip.x * 0.2) * sway * 0.7;`;
  const leafMat = (c) => patch(new THREE.MeshStandardMaterial({ color: c, roughness: 0.8, flatShading: true }), 'leaf', { vert: WIND, color: `diffuseColor.rgb *= 0.8 + 0.35 * vn(vWP.xz * 1.7 + vWP.y * 2.0);` });
  const crownA = new THREE.InstancedMesh(new THREE.IcosahedronGeometry(1.35, 2), leafMat('#7fb86a'), treeSpots.length);
  const crownB = new THREE.InstancedMesh(new THREE.IcosahedronGeometry(0.95, 2), leafMat('#6aa95a'), treeSpots.length);
  const tc = new THREE.Color();
  const m = new THREE.Matrix4();
  treeSpots.forEach(([x, z, s = 1], i) => {
    m.compose(V3(x, 1.6, z), Q4.identity(), V3(s, 1, s)); trunk.setMatrixAt(i, m);
    m.compose(V3(x, 3.2 + 1.3 * s, z), Q4.identity(), V3(s, s, s)); crownA.setMatrixAt(i, m);
    m.compose(V3(x + 0.5 * s, 3.2 + 2.0 * s, z + 0.2 * s), Q4.identity(), V3(s, s, s)); crownB.setMatrixAt(i, m);
    tc.setHSL(0.25 + srange(-0.04, 0.04), srange(0.35, 0.55), srange(0.72, 1.0)); crownA.setColorAt(i, tc); crownB.setColorAt(i, tc);
    const b = new CANNON.Body({ mass: 0, collisionFilterGroup: G_WORLD, material: M_GROUND }); b.addShape(new CANNON.Cylinder(0.22 * s, 0.22 * s, 3.2, 6)); b.position.set(x, 1.6, z); world.addBody(b);
  });
  for (const im of [trunk, crownA, crownB]) { im.castShadow = true; im.receiveShadow = true; scene.add(im); }
  const pole = new THREE.InstancedMesh(new THREE.CylinderGeometry(0.06, 0.08, 5, 8), A.mat('#9aa3ad'), lightSpots.length);
  lampHeadMat = new THREE.MeshStandardMaterial({ color: '#e9edf2', roughness: 0.4 });
  const head = new THREE.InstancedMesh(new THREE.BoxGeometry(0.35, 0.12, 1.2), lampHeadMat, lightSpots.length);
  const pc = document.createElement('canvas'); pc.width = pc.height = 128; const px = pc.getContext('2d');
  const gr = px.createRadialGradient(64, 64, 0, 64, 64, 64); gr.addColorStop(0, 'rgba(255,214,160,1)'); gr.addColorStop(0.4, 'rgba(255,190,120,0.45)'); gr.addColorStop(1, 'rgba(255,170,100,0)');
  px.fillStyle = gr; px.fillRect(0, 0, 128, 128);
  const ptex = new THREE.CanvasTexture(pc); ptex.colorSpace = THREE.SRGBColorSpace;
  lampPools = new THREE.InstancedMesh(new THREE.PlaneGeometry(10, 10).rotateX(-Math.PI / 2), new THREE.MeshBasicMaterial({ map: ptex, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, opacity: 0, fog: true }), lightSpots.length);
  lampPools.renderOrder = 2; lampPools.visible = false;
  lightSpots.forEach(([x, z], i) => {
    m.compose(V3(x, 2.5, z), Q4.identity(), S4); pole.setMatrixAt(i, m);
    m.compose(V3(x, 4.95, z), Q4.identity(), S4); head.setMatrixAt(i, m);
    m.compose(V3(x, 0.08, z), Q4.identity(), S4); lampPools.setMatrixAt(i, m);
    const b = new CANNON.Body({ mass: 0, collisionFilterGroup: G_WORLD }); b.addShape(new CANNON.Cylinder(0.1, 0.1, 5, 6)); b.position.set(x, 2.5, z); world.addBody(b);
  });
  pole.castShadow = true; scene.add(pole, head, lampPools);
}

// flush buckets into meshes
for (const [name, list] of Object.entries(buckets)) {
  const geo = mergeGeometries(list, false);
  const isDecal = name.startsWith('decal');
  const surf = { decal2: 'sidewalk', decal3: 'road', decal4: 'ground', decal5: 'paint', building: 'building', solid: 'concrete' }[name] || 'concrete';
  const m = new THREE.Mesh(geo, patch(new THREE.MeshStandardMaterial({ vertexColors: true, roughness: isDecal ? 1 : 0.88 }), 'surf-' + name, SURF[surf]));
  m.receiveShadow = true; m.castShadow = !isDecal;
  if (isDecal) { m.material.polygonOffset = true; m.material.polygonOffsetFactor = -Number(name.slice(5)); m.renderOrder = 1; }
  scene.add(m);
}

function waterNormals() {
  const S = 256, c = document.createElement('canvas'); c.width = c.height = S; const x = c.getContext('2d'); const img = x.createImageData(S, S);
  const H = (u, v) => { let h = 0; const W = [[3, 1, 0.5], [1, 4, 0.35], [5, 2, 0.25], [2, 7, 0.18], [9, 3, 0.1], [7, 11, 0.07]]; for (const [a, b, amp] of W) h += Math.sin((u * a + v * b) * Math.PI * 2 + a * 1.3) * amp; return h; };
  for (let j = 0; j < S; j++) for (let i = 0; i < S; i++) {
    const u = i / S, v = j / S, e = 1 / S;
    const dx = (H(u + e, v) - H(u - e, v)) * 6, dy = (H(u, v + e) - H(u, v - e)) * 6;
    const n = V3(-dx, -dy, 1).normalize(), k = (j * S + i) * 4;
    img.data[k] = (n.x * 0.5 + 0.5) * 255; img.data[k + 1] = (n.y * 0.5 + 0.5) * 255; img.data[k + 2] = (n.z * 0.5 + 0.5) * 255; img.data[k + 3] = 255;
  }
  x.putImageData(img, 0, 0);
  const t = new THREE.CanvasTexture(c); t.wrapS = t.wrapT = THREE.RepeatWrapping; return t;
}

/* --- particles: grind sparks + landing dust --- */
const particles = (() => {
  const mkTex = (inner, outer) => { const c = document.createElement('canvas'); c.width = c.height = 64; const x = c.getContext('2d'); const g = x.createRadialGradient(32, 32, 0, 32, 32, 32); g.addColorStop(0, inner); g.addColorStop(1, outer); x.fillStyle = g; x.fillRect(0, 0, 64, 64); return new THREE.CanvasTexture(c); };
  const mk = (n, tex, blending, size) => {
    const geo = new THREE.BufferGeometry(); const pos = new Float32Array(n * 3).fill(-999); const col = new Float32Array(n * 3);
    geo.setAttribute('position', new THREE.BufferAttribute(pos, 3)); geo.setAttribute('color', new THREE.BufferAttribute(col, 3));
    const pts = new THREE.Points(geo, new THREE.PointsMaterial({ size, map: tex, vertexColors: true, transparent: true, depthWrite: false, blending, sizeAttenuation: true }));
    pts.frustumCulled = false; scene.add(pts);
    return { pts, pos, col, vel: new Float32Array(n * 3), life: new Float32Array(n), max: new Float32Array(n), n, i: 0 };
  };
  const sparks = mk(260, mkTex('rgba(255,255,255,1)', 'rgba(255,160,60,0)'), THREE.AdditiveBlending, 0.12);
  const dust = mk(160, mkTex('rgba(255,255,255,0.55)', 'rgba(255,255,255,0)'), THREE.NormalBlending, 0.9);
  const emit = (s, p, v, life, r, g, b) => { const k = s.i++ % s.n; s.pos.set([p.x, p.y, p.z], k * 3); s.vel.set([v.x, v.y, v.z], k * 3); s.life[k] = life; s.max[k] = life; s.col.set([r, g, b], k * 3); };
  const step = (s, dt, grav, drag, fade) => {
    for (let k = 0; k < s.n; k++) {
      if (s.life[k] <= 0) continue;
      s.life[k] -= dt;
      s.vel[k * 3 + 1] -= grav * dt;
      for (let a = 0; a < 3; a++) { s.vel[k * 3 + a] *= 1 - drag * dt; s.pos[k * 3 + a] += s.vel[k * 3 + a] * dt; }
      if (s.pos[k * 3 + 1] < 0.02) { s.pos[k * 3 + 1] = 0.02; s.vel[k * 3 + 1] *= -0.3; }
      const c = fade; s.col[k * 3] *= c; s.col[k * 3 + 1] *= c; s.col[k * 3 + 2] *= c;
      if (s.life[k] <= 0) s.pos[k * 3 + 1] = -999;
    }
    s.pts.geometry.attributes.position.needsUpdate = true; s.pts.geometry.attributes.color.needsUpdate = true;
  };
  return {
    spark(p, dir) { for (let i = 0; i < 3; i++) emit(sparks, p, V3(-dir.x * rand(1, 4) + rand(-1.5, 1.5), rand(0.5, 3), -dir.z * rand(1, 4) + rand(-1.5, 1.5)), rand(0.2, 0.5), 1, rand(0.55, 0.85), 0.3); },
    dust(p, n = 12, strength = 1) { for (let i = 0; i < n; i++) { const a = rand(0, Math.PI * 2); emit(dust, V3(p.x, p.y + 0.05, p.z), V3(Math.cos(a) * rand(0.5, 2) * strength, rand(0.2, 0.8), Math.sin(a) * rand(0.5, 2) * strength), rand(0.5, 0.9), 0.82, 0.79, 0.74); } },
    update(dt) { step(sparks, dt, 9, 1.5, 0.97); step(dust, dt, -0.2, 3, 0.975); },
  };
})();

/* ============================== input ============================== */
const keys = new Set(), pressed = new Set(), released = new Set();
const ARROWS = { ArrowLeft: 'L', ArrowRight: 'R', ArrowUp: 'U', ArrowDown: 'D' };
addEventListener('keydown', (e) => {
  if (e.target.tagName === 'INPUT') return;
  if (!keys.has(e.code)) pressed.add(e.code);
  keys.add(e.code);
  if (['Space', 'Tab', 'ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.code)) e.preventDefault();
});
addEventListener('keyup', (e) => { keys.delete(e.code); released.add(e.code); });
addEventListener('blur', () => keys.clear());
const stick = { x: 0, y: 0 };
function moveInput() {
  let x = stick.x, y = stick.y;
  if (keys.has('KeyA')) x -= 1; if (keys.has('KeyD')) x += 1;
  if (keys.has('KeyW')) y += 1; if (keys.has('KeyS')) y -= 1;
  return { x: clamp(x, -1, 1), y: clamp(y, -1, 1) };
}
const down = (c) => keys.has(c);
const hit = (c) => pressed.has(c);
const up = (c) => released.has(c);

// camera drag (mouse + touch on the right side)
const cam = { yaw: 0, pitch: 0.3, userYaw: 0, userPitch: 0, idle: 9, dist: 5.2, pos: V3(), look: V3() };
let drag = null;
canvas.addEventListener('pointerdown', (e) => { drag = { id: e.pointerId, x: e.clientX, y: e.clientY }; canvas.setPointerCapture(e.pointerId); });
canvas.addEventListener('pointermove', (e) => {
  if (!drag || drag.id !== e.pointerId) return;
  const dx = e.clientX - drag.x, dy = e.clientY - drag.y; drag.x = e.clientX; drag.y = e.clientY;
  cam.userYaw -= dx * 0.006; cam.userPitch = clamp(cam.userPitch + dy * 0.004, -0.25, 0.7); cam.idle = 0;
});
canvas.addEventListener('pointerup', () => { drag = null; });

/* ============================== audio ============================== */
const audio = {
  ctx: null, master: null, radioOn: true,
  start() {
    if (this.ctx) return;
    const C = window.AudioContext || window.webkitAudioContext; if (!C) return;
    const ctx = this.ctx = new C();
    this.master = ctx.createGain(); this.master.gain.value = 0.8; this.master.connect(ctx.destination);
    const len = ctx.sampleRate * 2, buf = ctx.createBuffer(1, len, ctx.sampleRate), d = buf.getChannelData(0);
    for (let i = 0; i < len; i++) d[i] = Math.random() * 2 - 1;
    this.noise = buf;
    const mkLoop = (freq, q) => {
      const s = ctx.createBufferSource(); s.buffer = buf; s.loop = true;
      const f = ctx.createBiquadFilter(); f.type = 'bandpass'; f.frequency.value = freq; f.Q.value = q;
      const g = ctx.createGain(); g.gain.value = 0; s.connect(f).connect(g).connect(this.master); s.start(); return { g, f };
    };
    this.roll = mkLoop(700, 0.8); this.grind = mkLoop(2600, 3);
    const eng = ctx.createOscillator(); eng.type = 'sawtooth'; const ef = ctx.createBiquadFilter(); ef.type = 'lowpass'; ef.frequency.value = 420;
    const eg = ctx.createGain(); eg.gain.value = 0; eng.connect(ef).connect(eg).connect(this.master); eng.start(); this.engine = { o: eng, g: eg };
    this.music = ctx.createGain(); this.music.gain.value = 0.32; this.music.connect(this.master);
    this.step = 0; this.next = ctx.currentTime + 0.1;
    setInterval(() => this.schedule(), 40);
  },
  hitNoise(dur, freq, gain, type = 'lowpass', t = this.ctx.currentTime, dest = this.master) {
    const s = this.ctx.createBufferSource(); s.buffer = this.noise;
    const f = this.ctx.createBiquadFilter(); f.type = type; f.frequency.value = freq;
    const g = this.ctx.createGain(); g.gain.setValueAtTime(gain, t); g.gain.exponentialRampToValueAtTime(0.001, t + dur);
    s.connect(f).connect(g).connect(dest); s.start(t, Math.random()); s.stop(t + dur + 0.05);
  },
  tone(freq, dur, gain, type = 'triangle', t = this.ctx.currentTime, dest = this.master, attack = 0.01) {
    const o = this.ctx.createOscillator(); o.type = type; o.frequency.value = freq;
    const g = this.ctx.createGain(); g.gain.setValueAtTime(0.0001, t); g.gain.linearRampToValueAtTime(gain, t + attack); g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
    o.connect(g).connect(dest); o.start(t); o.stop(t + dur + 0.05);
  },
  pop() { if (!this.ctx) return; this.hitNoise(0.08, 1800, 0.5, 'highpass'); this.tone(180, 0.08, 0.25, 'square'); },
  land(big) { if (!this.ctx) return; this.hitNoise(big ? 0.25 : 0.12, 500, big ? 0.9 : 0.5); },
  coin() { if (!this.ctx) return; const t = this.ctx.currentTime; this.tone(880, 0.12, 0.12, 'sine', t); this.tone(1320, 0.18, 0.12, 'sine', t + 0.08); },
  schedule() {
    // SeshFM — original procedural lo-fi loop, 84 bpm
    const ctx = this.ctx, spb = 60 / 84 / 4;
    const chords = [[53, 57, 60, 64], [52, 55, 59, 62], [50, 53, 57, 60], [48, 52, 55, 59]];
    const midi = (n) => 440 * Math.pow(2, (n - 69) / 12);
    while (this.next < ctx.currentTime + 0.2) {
      const s = this.step % 16, bar = Math.floor(this.step / 16) % 4, t = this.next;
      if (this.radioOn) {
        if (s === 0 || s === 10) { this.tone(58, 0.35, 0.9, 'sine', t, this.music, 0.002); this.tone(midi(chords[bar][0] - 24), 0.5, 0.35, 'sine', t, this.music); }
        if (s === 4 || s === 12) this.hitNoise(0.18, 1500, 0.45, 'bandpass', t, this.music);
        if (s % 2 === 0) this.hitNoise(0.04, 7000, s % 4 === 2 ? 0.18 : 0.1, 'highpass', t, this.music);
        if (s === 0) for (const n of chords[bar]) this.tone(midi(n), spb * 15, 0.06, 'triangle', t, this.music, 0.25);
        if (s === 6 || s === 14) if (Math.random() < 0.6) this.tone(midi(pick(chords[bar]) + 12), 0.3, 0.05, 'sine', t, this.music);
      }
      this.step++; this.next += spb;
    }
  },
  update(skateSpeed, grinding, engineSpeed, engineOn) {
    if (!this.ctx) return;
    if (!Number.isFinite(skateSpeed)) skateSpeed = 0; if (!Number.isFinite(engineSpeed)) engineSpeed = 0;
    const t = this.ctx.currentTime;
    this.roll.g.gain.setTargetAtTime(clamp(skateSpeed / 10, 0, 1) * 0.35, t, 0.05);
    this.roll.f.frequency.setTargetAtTime(400 + skateSpeed * 60, t, 0.1);
    this.grind.g.gain.setTargetAtTime(grinding ? 0.18 : 0, t, 0.03);
    this.engine.g.gain.setTargetAtTime(engineOn ? 0.05 : 0, t, 0.1);
    this.engine.o.frequency.setTargetAtTime(45 + engineSpeed * 5, t, 0.1);
  },
};

/* ============================== HUD helpers ============================== */
const hud = {
  toast(msg, kind = '') {
    const el = document.createElement('div'); el.className = 'toast ' + kind; el.textContent = msg;
    $('toasts').prepend(el); setTimeout(() => el.classList.add('out'), 2600); setTimeout(() => el.remove(), 3200);
    while ($('toasts').children.length > 4) $('toasts').lastChild.remove();
  },
  banner(text, kind = '') {
    const el = $('banner'); el.textContent = text; el.className = 'show ' + kind;
    clearTimeout(this._b); this._b = setTimeout(() => (el.className = ''), 1300);
  },
};

/* ============================== game state ============================== */
const state = { coins: 60, score: 0, heat: 0, username: 'rookie', started: false };
function addCoins(n, why) { state.coins += n; if (n > 0) { audio.coin(); hud.toast(`+${n} coins · ${why}`, 'good'); } }

/* ============================== player ============================== */
const R = 0.35;
const playerBody = new CANNON.Body({ mass: 70, material: M_PLAYER, fixedRotation: true, linearDamping: 0.01, collisionFilterGroup: G_PLAYER, collisionFilterMask: G_WORLD | G_DEBRIS });
playerBody.addShape(new CANNON.Sphere(R));
playerBody.allowSleep = false;
world.addBody(playerBody);

const rig = new THREE.Group(); scene.add(rig);
const avatar = A.makeAvatar(); rig.add(avatar.group);
const board = A.makeBoard();
const boardPivot = new THREE.Group(); boardPivot.position.y = 0.1; rig.add(boardPivot);
board.position.y = -0.1; boardPivot.add(board);
board.traverse((m) => { if (m.isMesh) m.castShadow = true; });

const P = {
  mode: 'walk', yaw: 0, speed: 0, grounded: true, groundN: V3(0, 1, 0), fakie: false,
  crouch: 0, pushT: 0, pushCd: 0, air: null, grind: null, manual: null, bail: null,
  vehicle: null, walkPhase: 0, visYaw: 0, pendingTrick: null, lastGroundY: 0, lean: 0, grabbing: false,
};
function playerPos() { if (P.mode === 'drive' && P.vehicle) { const p = P.vehicle.body.position; return V3(p.x, p.y, p.z); } if (P.mode === 'passenger' && hailr.car) return hailr.car.pos.clone(); return feet(); }
function feet() { return V3(playerBody.position.x, playerBody.position.y - R, playerBody.position.z); }
function placePlayer(v, yaw = 0) { playerBody.position.set(v.x, v.y + R + 0.05, v.z); playerBody.velocity.set(0, 0, 0); P.yaw = yaw; P.visYaw = yaw; }

function holdBoardInHand() {
  const hand = avatar.parts.armR.userData.hand; hand.add(board);
  board.position.set(-0.06, 0.05, 0.12); board.rotation.set(Math.PI / 2, 0, Math.PI / 2 + 0.1);
}
function boardUnderFeet() { boardPivot.add(board); board.position.set(0, -0.1, 0); board.rotation.set(0, 0, 0); boardPivot.rotation.set(0, 0, 0); }
function boardOnBack() { avatar.parts.torso.add(board); board.position.set(0, 0.05, -0.19); board.rotation.set(Math.PI / 2 - 0.15, 0, 0); }
holdBoardInHand();

/* --- ground probe --- */
const rayRes = new CANNON.RaycastResult();
function probeGround(extra = 0.28) {
  const from = playerBody.position, to = new CANNON.Vec3(from.x, from.y - R - extra, from.z);
  rayRes.reset();
  world.raycastClosest(from, to, { collisionFilterMask: G_WORLD, skipBackfaces: true }, rayRes);
  if (!rayRes.hasHit) return null;
  const n = rayRes.hitNormalWorld;
  return { dist: rayRes.distance, n: V3(n.x, n.y, n.z), y: rayRes.hitPointWorld.y };
}

/* ============================== tricks + combos ============================== */
const FLIPS = {
  L: { name: 'Kickflip', pts: 300, flip: -1, dur: 0.42 },
  R: { name: 'Heelflip', pts: 300, flip: 1, dur: 0.42 },
  D: { name: 'Pop Shove-it', pts: 250, shuv: 0.5, dur: 0.38 },
  U: { name: 'Impossible', pts: 420, wrap: 1, dur: 0.48 },
  LL: { name: 'Double Kickflip', pts: 650, flip: -2, dur: 0.6 },
  RR: { name: 'Double Heelflip', pts: 650, flip: 2, dur: 0.6 },
  DL: { name: 'Varial Kickflip', pts: 500, flip: -1, shuv: 0.5, dur: 0.5 },
  DR: { name: 'Varial Heelflip', pts: 500, flip: 1, shuv: -0.5, dur: 0.5 },
  DD: { name: '360 Shove-it', pts: 450, shuv: 1, dur: 0.5 },
  UD: { name: '360 Flip', pts: 800, flip: -1, shuv: 1, dur: 0.6 },
  UL: { name: 'Hardflip', pts: 600, flip: -1, wrap: 0.5, dur: 0.55 },
  UR: { name: 'Inward Heelflip', pts: 550, flip: 1, shuv: -0.5, dur: 0.5 },
};
const GRINDS = { none: '50-50', U: 'Nosegrind', D: '5-0', L: 'Boardslide', R: 'Crooked' };
const combo = { parts: [], base: 0, mult: 0, idle: 0 };
let trickBuf = [];
function comboActive() { return combo.parts.length > 0; }
function addTrick(name, pts, mult = 1) {
  if (combo.parts[combo.parts.length - 1] === name) pts = Math.round(pts * 0.5); // repeat penalty
  combo.parts.push(name); combo.base += pts; combo.mult += mult; combo.idle = 0;
}
function bankCombo() {
  if (!comboActive()) return;
  const total = Math.round(combo.base * Math.max(1, combo.mult));
  state.score += total;
  $('landed').textContent = `+${fmt(total)}`; $('landed').className = 'show';
  clearTimeout(bankCombo._t); bankCombo._t = setTimeout(() => ($('landed').className = ''), 1200);
  missions.event('combo', { total, parts: [...combo.parts] });
  if (total >= 1500) addCoins(Math.min(40, Math.floor(total / 500)), 'combo');
  combo.parts = []; combo.base = 0; combo.mult = 0;
}
function loseCombo() { combo.parts = []; combo.base = 0; combo.mult = 0; }

function startFlip(code) {
  const def = FLIPS[code] || FLIPS[code[0]]; if (!def) return;
  P.air.flip = { def, t: 0 };
  P.air.tricks.push(def.name);
  addTrick(def.name, def.pts);
}

/* ============================== bail ============================== */
let debrisBoard = null;
function bail(reason = 'Bailed') {
  if (P.mode === 'bail') return;
  const prev = P.mode;
  P.mode = 'bail'; P.bail = { t: 0, reason, from: prev };
  P.grind = null; P.manual = null; P.air = null;
  loseCombo(); hud.banner(reason.toUpperCase(), 'bad'); audio.land(true);
  if (prev === 'skate') {
    const wp = new THREE.Vector3(); board.getWorldPosition(wp);
    const b = new CANNON.Body({ mass: 2.5, collisionFilterGroup: G_DEBRIS, collisionFilterMask: G_WORLD | G_PLAYER, material: M_GROUND });
    b.addShape(new CANNON.Box(new CANNON.Vec3(0.105, 0.03, 0.4)));
    b.position.set(wp.x, wp.y + 0.15, wp.z);
    b.quaternion.setFromEuler(0, P.visYaw, 0);
    b.velocity.set(playerBody.velocity.x * 1.1 + rand(-1, 1), 2.5, playerBody.velocity.z * 1.1 + rand(-1, 1));
    b.angularVelocity.set(rand(-9, 9), rand(-6, 6), rand(-9, 9));
    world.addBody(b); debrisBoard = b; scene.add(board);
  }
  playerBody.velocity.x *= 0.5; playerBody.velocity.z *= 0.5;
}
function recover() {
  if (debrisBoard) { world.removeBody(debrisBoard); debrisBoard = null; }
  avatar.group.rotation.set(0, 0, 0); avatar.group.position.set(0, 0, 0);
  P.speed = 0; P.fakie = false; P.crouch = 0; P._intended = 0; P.grounded = true;
  if (P.bail.from === 'skate') { boardUnderFeet(); P.mode = 'skate'; } else { holdBoardInHand(); P.mode = 'walk'; }
  P.bail = null;
}
playerBody.addEventListener('collide', (e) => {
  const o = e.body;
  if (o.userData && o.userData.npc && o.velocity.length() > 3 && (P.mode === 'skate' || P.mode === 'walk')) bail('Clipped by traffic');
  if (o.userData && o.userData.vehicle && o.velocity.length() > 6 && (P.mode === 'skate' || P.mode === 'walk')) bail('Hit by a car');
});

/* ============================== skate controller ============================== */
const G_EXTRA = 8; // extra gravity for snappy skate arcs (world g = 12)
function skateFwd() { return V3(Math.sin(P.yaw), 0, Math.cos(P.yaw)); }

function skatePre(dt, inp) {
  if (P.grind) return grindPre(dt, inp);
  const v = playerBody.velocity;
  if (P.grounded) {
    const n = P.groundN, fw = skateFwd();
    const f = fw.clone().sub(n.clone().multiplyScalar(fw.dot(n))).normalize();
    const turn = lerp(2.5, 1.35, clamp(P.speed / 14, 0, 1)) * (P.manual ? 0.5 : 1);
    P.yaw += -inp.x * turn * dt;
    P.lean = damp(P.lean, -inp.x * clamp(P.speed / 6, 0, 1), 8, dt);
    // push / brake / roll resistance / slope
    P.pushCd -= dt; P.pushT = Math.max(0, P.pushT - dt);
    if (inp.y > 0.4 && P.pushCd <= 0 && !P.manual && P.crouch < 0.2 && P.speed < 10) { P.speed += lerp(2.4, 0.9, P.speed / 10); P.pushCd = 0.62; P.pushT = 0.55; }
    if (inp.y < -0.4 && !P.manual) P.speed -= 7 * dt;
    P.speed -= (0.1 + 0.0035 * P.speed * P.speed) * dt;
    P.speed -= 20 * f.y * dt;
    if (P.speed < -0.3) { P.speed = -P.speed; P.yaw += Math.PI; P.fakie = !P.fakie; }
    P.speed = Math.max(0, P.speed);
    const f2 = V3(Math.sin(P.yaw), 0, Math.cos(P.yaw)); const ff = f2.sub(n.clone().multiplyScalar(f2.dot(n))).normalize();
    v.set(ff.x * P.speed - n.x * 0.6, ff.y * P.speed - n.y * 0.6, ff.z * P.speed - n.z * 0.6);
    P._intended = P.speed; P.lastSlopeVy = ff.y * P.speed;
    // crouch → ollie
    if (down('Space')) P.crouch = Math.min(1, P.crouch + dt * 2.2);
    else if (P.crouch > 0) {
      const c = P.crouch; P.crouch = 0;
      v.y = Math.max(0, ff.y * P.speed) * 1.3 + 4.6 + c * 2.8; v.x = ff.x * P.speed; v.z = ff.z * P.speed;
      beginAir(true);
      addTrick(P.manual ? 'Ollie' : (P.fakie ? 'Fakie Ollie' : 'Ollie'), 60, 0);
      P.manual = null;
      audio.pop();
      if (P.pendingTrick) { startFlip(P.pendingTrick); P.pendingTrick = null; }
    }
    manualUpdate(dt, inp);
  } else {
    v.y -= G_EXTRA * dt;
    const a = P.air; a.t += dt;
    const target = -inp.x * 7.2;
    a.spinVel = damp(a.spinVel, target, 10, dt);
    a.spin += a.spinVel * dt;
    // slight air steering
    P.yaw += -inp.x * 0.25 * dt;
    if (a.flip) { a.flip.t += dt / a.flip.def.dur; if (a.flip.t >= 1) a.flip = { ...a.flip, t: 1, done: true }; }
    const grab = down('ShiftLeft') || down('ShiftRight') || down('KeyK');
    if (grab && (!a.flip || a.flip.done)) {
      if (!P.grabbing) { P.grabbing = true; a.grabName = pick(['Indy', 'Melon', 'Nosegrab', 'Tailgrab', 'Stalefish']); a.grabT = 0; }
      a.grabT += dt; combo.base += 180 * dt;
    } else if (P.grabbing) { P.grabbing = false; if (a.grabT > 0.12) { addTrick(a.grabName, 150 + Math.round(a.grabT * 200)); a.tricks.push(a.grabName); } }
    if (down('KeyE') && v.y < 3) tryGrind();
  }
}
function beginAir(popped) {
  P.air = { t: 0, spin: 0, spinVel: 0, tricks: [], flip: null, popped, startY: feet().y, maxVy: 0 };
  P.grounded = false; P.grabbing = false; P._intended = 0;
}
function land(n) {
  const a = P.air; P.air = null;
  const vy = playerBody.velocity.y;
  if (!a) return;
  const s = wrap(a.spin);
  const flipBad = a.flip && a.flip.t < 0.88;
  const spinOk = Math.abs(s) < 0.62 || Math.abs(s) > Math.PI - 0.62;
  if (flipBad || !spinOk || P.grabbing || vy < -17) { bail(flipBad ? 'Flip not finished' : !spinOk ? 'Landed sideways' : P.grabbing ? 'Still grabbing' : 'Too much drop'); return; }
  const deg = Math.round(Math.abs(a.spin) / Math.PI) * 180;
  if (Math.abs(s) > Math.PI / 2) P.fakie = !P.fakie;
  if (deg >= 180) { const nm = `${a.spin > 0 ? 'FS' : 'BS'} ${deg}`; a.tricks.push(nm); addTrick(nm, deg * 0.9, 1); }
  const hv = V3(playerBody.velocity.x, 0, playerBody.velocity.z);
  const fw = skateFwd();
  P.speed = Math.max(0, hv.dot(fw)) * 0.97;
  if (a.t > 0.35) { audio.land(a.t > 0.8); particles.dust(feet(), a.t > 0.8 ? 16 : 8, a.t > 0.8 ? 1.4 : 0.8); }
  if (a.t < 0.25 && !a.tricks.length) { if (!comboActive() || combo.parts.every((x) => x.includes('Ollie'))) loseCombo(); return; }
  missions.event('land', { tricks: a.tricks, pos: feet(), startY: a.startY, air: a.t });
}

/* --- manuals --- */
function manualUpdate(dt, inp) {
  if (!P.manual) return;
  const m = P.manual;
  m.t += dt;
  m.vel += (m.bal * 2.4 + rand(-1, 1) * (0.6 + m.t * 0.3)) * dt;
  m.vel += inp.y * 3.4 * dt;
  m.bal += m.vel * dt;
  combo.base += 90 * dt; combo.idle = 0;
  if (Math.abs(m.bal) > 1) bail('Lost the manual');
  else if (P.speed < 1.2) { P.manual = null; }
}
function startManual(nose) {
  if (P.manual || !P.grounded || P.speed < 2) return;
  P.manual = { nose, t: 0, bal: rand(-0.1, 0.1), vel: 0 };
  addTrick(nose ? 'Nose Manual' : 'Manual', 100);
}

/* --- grinds --- */
function tryGrind() {
  const fp = feet(); const hv = V3(playerBody.velocity.x, 0, playerBody.velocity.z);
  const sp = hv.length(); if (sp < 1.5) return;
  let best = null;
  for (const s of grindSegs) {
    const ab = s.b.clone().sub(s.a), L = ab.length(), dir = ab.clone().divideScalar(L);
    const hdir = V3(dir.x, 0, dir.z); const hl = hdir.length(); if (hl < 0.3) continue; hdir.divideScalar(hl);
    const rel = fp.clone().sub(s.a);
    let t = (rel.x * hdir.x + rel.z * hdir.z) / (hl * L);
    if (t < 0.02 || t > 0.98) continue;
    const p = s.a.clone().addScaledVector(ab, t);
    const d = Math.hypot(fp.x - p.x, fp.z - p.z), dy = fp.y - p.y;
    if (d > 0.75 || dy < -0.45 || dy > 1.1) continue;
    const align = hv.dot(hdir) / sp;
    if (Math.abs(align) < 0.45) continue;
    if (!best || d < best.d) best = { s, t, d, dir: Math.sign(align), L, p, align };
  }
  if (!best) return;
  const held = Object.entries(ARROWS).find(([k]) => down(k));
  const type = held ? held[1] : 'none';
  let name = GRINDS[type]; if (best.s.kind === 'ledge' && type === 'none') name = '50-50';
  if (best.s.kind === 'ledge' && type === 'L') name = 'Boardslide';
  P.grind = { seg: best.s, t: best.t, dir: best.dir, L: best.L, speed: Math.max(3, sp * Math.abs(best.align)), bal: rand(-0.15, 0.15), vel: 0, time: 0, name, type };
  if (P.air) { if (P.air.flip && P.air.flip.t < 0.88) { bail('Flip not finished'); return; } P.air = null; }
  P.grabbing = false; P.manual = null;
  addTrick(name, 120);
  audio.land(false);
}
function grindPre(dt, inp) {
  const g = P.grind, s = g.seg;
  const ab = s.b.clone().sub(s.a), dir = ab.clone().normalize().multiplyScalar(g.dir);
  g.time += dt;
  g.speed -= (0.6 + 20 * dir.y) * dt;
  g.t += (g.speed * dt / g.L) * g.dir;
  g.vel += (g.bal * 2.4 + rand(-0.9, 0.9) * (0.6 + g.time * 0.25)) * dt;
  g.vel += inp.x * 4.2 * dt;
  g.bal += g.vel * dt;
  combo.base += 140 * dt; combo.idle = 0;
  P.yaw = Math.atan2(dir.x, dir.z);
  if (s.kind === 'rail' || Math.random() < 0.25) particles.spark(feet(), dir);
  const p = s.a.clone().addScaledVector(ab, clamp(g.t, 0, 1));
  playerBody.position.set(p.x, p.y + R + 0.1, p.z);
  playerBody.velocity.set(dir.x * g.speed, dir.y * g.speed, dir.z * g.speed);
  if (Math.abs(g.bal) > 1) { endGrind(); bail('Lost balance'); return; }
  if (g.speed < 0.8) { endGrind(); bail('Stalled out'); return; }
  const exitPop = hit('Space');
  if (g.t <= 0 || g.t >= 1 || exitPop) {
    endGrind();
    playerBody.velocity.y = exitPop ? 5.2 : 1.5;
    beginAir(exitPop); if (exitPop) { audio.pop(); addTrick('Ollie Out', 50, 0); }
  }
}
function endGrind() {
  const g = P.grind; P.grind = null;
  if (g) missions.event('grind', { time: g.time, name: g.name });
}

/* ============================== walk controller ============================== */
function walkPre(dt, inp) {
  const v = playerBody.velocity;
  const f = V3(Math.sin(cam.yaw), 0, Math.cos(cam.yaw)), r = V3(-Math.cos(cam.yaw), 0, Math.sin(cam.yaw));
  const dir = f.multiplyScalar(inp.y).add(r.multiplyScalar(inp.x));
  const mag = Math.min(1, dir.length());
  const run = down('ShiftLeft') || down('ShiftRight') || mag > 0.95 && stick.x * stick.x + stick.y * stick.y > 0.9;
  const spd = mag * (run ? 5.4 : 2.5);
  if (mag > 0.05) { dir.normalize(); P.yaw = dampAngle(P.yaw, Math.atan2(dir.x, dir.z), 12, dt); }
  const tx = mag > 0.05 ? dir.x * spd : 0, tz = mag > 0.05 ? dir.z * spd : 0;
  v.x = damp(v.x, tx, 12, dt); v.z = damp(v.z, tz, 12, dt);
  if (P.grounded && hit('Space')) { v.y = 5.2; P.grounded = false; }
  if (!P.grounded) v.y -= 4 * dt;
  P.walkSpeed = Math.hypot(v.x, v.z);
}

/* ============================== vehicles ============================== */
const VT = {
  car: { label: 'Car', mass: 950, half: [0.9, 0.32, 2.05], wr: 0.36, rest: 0.3, stiff: 32, eng: 2100, brake: 40, steer: 0.55, vmax: 38, cam: 8.5, seat: [0.4, 0.42, -0.2], sit: true },
  moto: { label: 'Motorcycle', mass: 230, half: [0.22, 0.26, 0.8], wr: 0.33, rest: 0.26, stiff: 36, eng: 760, brake: 14, steer: 0.5, vmax: 44, cam: 6, seat: [0, 0.78, -0.28], sit: true, lean: true, track: 0.24, axleF: 0.76, axleR: -0.72 },
  ebike: { label: 'Zipp e-bike', mass: 75, half: [0.14, 0.2, 0.52], wr: 0.33, rest: 0.22, stiff: 38, eng: 85, brake: 5, steer: 0.55, vmax: 7.4, cam: 5, seat: [0, 0.9, -0.22], sit: true, lean: true, rental: true, track: 0.3, axleF: 0.55, axleR: -0.55 },
  scooter: { label: 'Zipp scooter', mass: 48, half: [0.12, 0.07, 0.4], wr: 0.11, rest: 0.12, stiff: 42, eng: 52, brake: 3.5, steer: 0.5, vmax: 6.9, cam: 4.8, seat: [0, 0.2, -0.1], sit: false, lean: true, rental: true, track: 0.16, axleF: 0.4, axleR: -0.4 },
};
const CAR_COLORS = ['#e85d5d', '#5b8def', '#f2c14e', '#3fb98a', '#f4f4f4', '#2b2f38', '#b28dff', '#ff9f5a'];
const vehicles = [];
function makeVehicleMesh(type, color) {
  if (type === 'car') return A.makeCar({ color, style: Math.random() < 0.4 ? 'hatch' : 'sedan' });
  if (type === 'moto') return A.makeMoto({ color });
  if (type === 'ebike') return A.makeEBike();
  return A.makeEScooter();
}
class Vehicle {
  constructor(type, x, z, yaw, color = pick(CAR_COLORS), meshData = null) {
    const t = this.t = VT[type]; this.type = type; this.color = color;
    const md = meshData || makeVehicleMesh(type, color);
    this.mesh = md.group; this.wheelMeshes = md.wheels; scene.add(this.mesh);
    this.mesh.traverse((m) => { if (m.isMesh) { m.castShadow = true; m.receiveShadow = true; } });
    const conY = -t.half[1] + 0.04;
    this.groundOff = conY - (t.rest - 12 / (4 * t.stiff)) - t.wr;
    const body = this.body = new CANNON.Body({ mass: t.mass, collisionFilterGroup: G_WORLD, collisionFilterMask: G_WORLD | G_PLAYER | G_DEBRIS, material: M_GROUND });
    body.addShape(new CANNON.Box(new CANNON.Vec3(...t.half)));
    body.position.set(x, -this.groundOff + 0.05, z);
    body.quaternion.setFromAxisAngle(Y_AXIS, yaw);
    body.angularDamping = 0.4; body.linearDamping = 0.02; body.userData = { vehicle: this };
    body.allowSleep = true; body.sleepSpeedLimit = 0.3;
    this.rv = new CANNON.RaycastVehicle({ chassisBody: body, indexRightAxis: 0, indexUpAxis: 1, indexForwardAxis: 2 });
    const tr = t.track ?? 0.8, af = t.axleF ?? (md.wheelPos ? md.wheelPos[0][1] : 1.3), ar = t.axleR ?? -af;
    for (const [wx, wz] of [[tr, af], [-tr, af], [tr, ar], [-tr, ar]]) {
      this.rv.addWheel({
        radius: t.wr, directionLocal: new CANNON.Vec3(0, -1, 0), suspensionStiffness: t.stiff, suspensionRestLength: t.rest,
        frictionSlip: type === 'car' ? 2.2 : 2.6, dampingRelaxation: 2.4, dampingCompression: 4.4, maxSuspensionForce: 1e6,
        rollInfluence: 0.02, axleLocal: new CANNON.Vec3(-1, 0, 0), chassisConnectionPointLocal: new CANNON.Vec3(wx, conY, wz),
        maxSuspensionTravel: t.rest * 0.8, customSlidingRotationalSpeed: -30, useCustomSlidingRotationalSpeed: true,
      });
    }
    this.rv.addToWorld(world);
    this.steer = 0; this.spin = 0; this.lean = 0; this.stolen = false; this.driver = false;
    vehicles.push(this);
  }
  get speed() { const v = this.body.velocity; const f = this.fwd(); return v.x * f.x + v.y * f.y + v.z * f.z; }
  fwd() { const q = this.body.quaternion; const f = q.vmult(new CANNON.Vec3(0, 0, 1)); return f; }
  yaw() { const f = this.fwd(); return Math.atan2(f.x, f.z); }
  drive(dt, inp, handbrake) {
    const t = this.t, sp = this.speed;
    let force = 0, brake = 0;
    if (inp.y > 0.1) force = sp < t.vmax ? -t.eng * inp.y : 0;
    else if (inp.y < -0.1) { if (sp > 1) brake = t.brake * -inp.y; else force = t.eng * 0.6 * -inp.y; }
    else brake = t.brake * 0.05;
    if (handbrake) brake = t.brake * 1.5;
    this.steer = damp(this.steer, -inp.x * t.steer * (1 - clamp(Math.abs(sp) / t.vmax, 0, 1) * 0.55), 8, dt);
    for (const i of [0, 1]) this.rv.setSteeringValue(this.steer, i);
    for (const i of [2, 3]) this.rv.applyEngineForce(force, i);
    for (let i = 0; i < 4; i++) this.rv.setBrake(i < 2 ? brake * 0.6 : brake, i);
    this.body.wakeUp();
  }
  idle() { for (let i = 0; i < 4; i++) { this.rv.setBrake(this.t.brake * 0.4, i); this.rv.applyEngineForce(0, i); } }
  stabilize() {
    const b = this.body, t = this.t;
    const upv = b.quaternion.vmult(new CANNON.Vec3(0, 1, 0));
    const ax = upv.cross(new CANNON.Vec3(0, 1, 0));
    const w = t.lean ? 9 : 4;
    // desired angular acceleration (world) → local frame → scale by local inertia → back to world
    const alpha = new CANNON.Vec3(ax.x * w * w - b.angularVelocity.x * 2 * w, 0, ax.z * w * w - b.angularVelocity.z * 2 * w);
    const inv = b.quaternion.conjugate(), la = inv.vmult(alpha);
    la.x *= b.inertia.x; la.y *= b.inertia.y; la.z *= b.inertia.z;
    const tw = b.quaternion.vmult(la);
    b.torque.vadd(tw, b.torque);
  }
  reset() { const y = this.yaw(); this.body.quaternion.setFromAxisAngle(Y_AXIS, y); this.body.position.y += 1.2; this.body.velocity.set(0, 0, 0); this.body.angularVelocity.set(0, 0, 0); }
  sync(dt) {
    const b = this.body;
    this.mesh.position.set(b.position.x, b.position.y, b.position.z);
    this.mesh.quaternion.set(b.quaternion.x, b.quaternion.y, b.quaternion.z, b.quaternion.w);
    const sp = this.speed;
    if (this.t.lean) { this.lean = damp(this.lean, this.steer * clamp(sp / 6, 0, 1) * 0.9, 6, dt); this.mesh.rotateZ(-this.lean); }
    this.mesh.translateY(this.groundOff);
    this.spin += (sp / this.t.wr) * dt;
    this.wheelMeshes.forEach((w, i) => { w.rotation.x = this.spin; if (i === 0 || (this.type === 'car' && i === 1)) w.rotation.y = this.steer; });
  }
  remove() { this.rv.removeFromWorld(world); world.removeBody(this.body); scene.remove(this.mesh); vehicles.splice(vehicles.indexOf(this), 1); }
}

/* --- parked + rental spawns --- */
const rx = (i) => roadAt(i);
[
  ['car', rx(2) - 3.1, -52, 0], ['moto', rx(2) - 3.1, -60, 0], ['car', rx(2) + 3.1, -10, Math.PI], ['car', rx(3) - 3.1, 60, 0],
  ['moto', rx(4) + 3.1, 20, Math.PI], ['car', -100, rx(3) + 3.1, Math.PI / 2], ['car', 40, rx(2) - 3.1, -Math.PI / 2],
  ['car', rx(6) - 3.1, -90, 0], ['car', rx(5) + 3.1, 70, Math.PI], ['moto', 90, rx(4) - 3.1, Math.PI / 2],
].forEach(([t, x, z, y]) => new Vehicle(t, x, z, y));
const docks = [];
function dock(x, z, ry, n = 3) {
  const along = V3(Math.sin(ry + Math.PI / 2), 0, Math.cos(ry + Math.PI / 2));
  solid(0.3, 0.12, n * 1.1 + 0.6, x, 0, z, A.PALETTE.zipp, { ry: ry + Math.PI / 2, physics: false });
  for (let k = 0; k < n; k++) {
    const o = along.clone().multiplyScalar((k - (n - 1) / 2) * 1.1);
    new Vehicle(k % 2 ? 'scooter' : 'ebike', x + o.x, z + o.z, ry);
  }
  docks.push(V3(x, 0, z));
}
dock(-62.8, -76, 0);
dock(blockAt(2) + 20, blockAt(2) - 21.5, Math.PI / 2, 4);
dock(HALF + 8, -72, 0);
dock(blockAt(3) - 21.8, blockAt(3) + 12, 0);

/* --- traffic (kinematic, follows block loops) --- */
const npcs = [];
function loopAround(i, j, lane = 2.4) {
  const x0 = roadAt(i) + lane, x1 = roadAt(i + 1) - lane, z0 = roadAt(j) + lane, z1 = roadAt(j + 1) - lane;
  return [V3(x0, 0, z0), V3(x0, 0, z1), V3(x1, 0, z1), V3(x1, 0, z0)];
}
function pathLen(path) { let L = 0; for (let k = 0; k < path.length; k++) L += path[k].distanceTo(path[(k + 1) % path.length]); return L; }
function pathAt(path, s) {
  s = ((s % pathLen(path)) + pathLen(path)) % pathLen(path);
  for (let k = 0; k < path.length; k++) {
    const a = path[k], b = path[(k + 1) % path.length], l = a.distanceTo(b);
    if (s <= l) return { p: a.clone().lerp(b, s / l), dir: b.clone().sub(a).normalize() };
    s -= l;
  }
  return { p: path[0].clone(), dir: V3(0, 0, 1) };
}
function spawnNpc(i, j, s0) {
  const md = A.makeCar({ color: pick(CAR_COLORS), style: Math.random() < 0.4 ? 'hatch' : 'sedan' });
  scene.add(md.group); md.group.traverse((m) => { if (m.isMesh) m.castShadow = true; });
  const body = new CANNON.Body({ mass: 0, type: CANNON.Body.KINEMATIC, collisionFilterGroup: G_WORLD, collisionFilterMask: G_PLAYER | G_WORLD | G_DEBRIS });
  body.addShape(new CANNON.Box(new CANNON.Vec3(0.9, 0.55, 2.1)), new CANNON.Vec3(0, 0.75, 0));
  body.userData = { npc: true }; world.addBody(body);
  const npc = { md, body, path: loopAround(i, j), s: s0, speed: 0, vmax: rand(8, 11), yaw: 0, color: md.group.children[0].material.color.getStyle() };
  const at = pathAt(npc.path, s0); npc.yaw = Math.atan2(at.dir.x, at.dir.z);
  body.position.set(at.p.x, 0, at.p.z);
  npcs.push(npc); return npc;
}
[[0, 1, 0], [2, 0, 40], [1, 3, 90], [4, 2, 20], [3, 4, 60], [5, 5, 10], [0, 4, 70], [4, 0, 5]].forEach(([i, j, s]) => spawnNpc(i, j, s));
function npcUpdate(dt) {
  const pp = P.vehicle ? P.vehicle.body.position : playerBody.position;
  for (const n of npcs) {
    const at = pathAt(n.path, n.s);
    const ahead = V3(pp.x - at.p.x, 0, pp.z - at.p.z);
    const fwdD = ahead.dot(at.dir), side = Math.abs(ahead.x * at.dir.z - ahead.z * at.dir.x);
    let blocked = fwdD > 0 && fwdD < 9 && side < 2.2;
    for (const o of npcs) if (o !== n) { const d = o.body.position.clone().vsub(n.body.position); const fd = d.x * at.dir.x + d.z * at.dir.z; if (fd > 0 && fd < 7 && Math.abs(d.x * at.dir.z - d.z * at.dir.x) < 1.5) blocked = true; }
    n.speed = damp(n.speed, blocked ? 0 : n.vmax, blocked ? 5 : 1.2, dt);
    n.s += n.speed * dt;
    const nx = pathAt(n.path, n.s);
    n.yaw = dampAngle(n.yaw, Math.atan2(nx.dir.x, nx.dir.z), 5, dt);
    n.body.velocity.set((nx.p.x - n.body.position.x) / dt, 0, (nx.p.z - n.body.position.z) / dt);
    n.body.quaternion.setFromAxisAngle(Y_AXIS, n.yaw);
  }
}
function npcSync() { for (const n of npcs) { n.md.group.position.set(n.body.position.x, 0, n.body.position.z); n.md.group.rotation.y = n.yaw; const k = n.speed * 0.016 / 0.36; n.md.wheels.forEach((w) => (w.rotation.x += k)); } }

// fleeing driver after a car-jack
const fleeing = [];
function spawnFleeing(pos, yaw) {
  const av = A.makeAvatar({ hoodie: pick(A.HOODIES), skin: pick(A.SKIN_TONES), hat: pick(['#2b2f38', '#e85d5d', '#5b8def']) });
  av.group.position.copy(pos); av.group.rotation.y = yaw; scene.add(av.group);
  fleeing.push({ av, t: 0, yaw });
}

/* --- Hailr rideshare (kinematic, drives the road grid) --- */
const hailr = { car: null, state: 'none', path: [], seg: 0, dest: null, destName: '', fare: 12, t: 0 };
function nearestRoadPoint(p) {
  const i = clamp(Math.round((p.x + HALF) / CELL), 0, N), j = clamp(Math.round((p.z + HALF) / CELL), 0, N);
  const dx = Math.abs(p.x - roadAt(i)), dz = Math.abs(p.z - roadAt(j));
  const cl = (v) => clamp(v, -HALF, HALF);
  return dx < dz ? { p: V3(roadAt(i), 0, cl(p.z)), axis: 'x', i, j } : { p: V3(cl(p.x), 0, roadAt(j)), axis: 'z', i, j };
}
function routeBetween(a, b) {
  const A0 = nearestRoadPoint(a), B0 = nearestRoadPoint(b);
  const ia = A0.axis === 'x' ? A0.i : clamp(Math.round((A0.p.x + HALF) / CELL), 0, N);
  const ja = A0.axis === 'z' ? A0.j : clamp(Math.round((A0.p.z + HALF) / CELL), 0, N);
  const ib = B0.axis === 'x' ? B0.i : clamp(Math.round((B0.p.x + HALF) / CELL), 0, N);
  const jb = B0.axis === 'z' ? B0.j : clamp(Math.round((B0.p.z + HALF) / CELL), 0, N);
  const pts = [A0.p, V3(roadAt(ia), 0, roadAt(ja)), V3(roadAt(ib), 0, roadAt(ja)), V3(roadAt(ib), 0, roadAt(jb)), B0.p];
  return pts.filter((p, k) => k === 0 || p.distanceTo(pts[k - 1]) > 0.5);
}
function callHailr() {
  if (hailr.state !== 'none') { hud.toast('Your Hailr is already on the way'); return; }
  if (state.coins < hailr.fare) { hud.toast(`A Hailr ride costs ${hailr.fare} coins — land some combos first`, 'bad'); return; }
  const fp = feet();
  const m = missions.current();
  const dest = m && m.dest ? m.dest() : spots.kickerpark;
  hailr.destName = m && m.destName ? m.destName : 'Kicker Park';
  hailr.dest = dest;
  const pickup = nearestRoadPoint(fp).p;
  const startP = nearestRoadPoint(fp.clone().add(V3(rand(-60, 60), 0, rand(-60, 60)))).p;
  const md = A.makeRideshare(); scene.add(md.group); md.group.traverse((o) => { if (o.isMesh) o.castShadow = true; });
  const body = new CANNON.Body({ mass: 0, type: CANNON.Body.KINEMATIC, collisionFilterGroup: G_WORLD, collisionFilterMask: G_WORLD | G_DEBRIS });
  body.addShape(new CANNON.Box(new CANNON.Vec3(0.9, 0.55, 2.1)), new CANNON.Vec3(0, 0.75, 0)); world.addBody(body);
  hailr.car = { md, body, pos: startP.clone(), yaw: 0, speed: 0 };
  body.position.set(startP.x, 0, startP.z);
  hailr.path = routeBetween(startP, pickup); hailr.seg = 1; hailr.state = 'coming'; hailr.pickup = pickup;
  hud.toast('Hailr requested — driver is on the way');
}
function hailrDrive(dt, vmax) {
  const c = hailr.car; const tgt = hailr.path[hailr.seg];
  if (!tgt) return true;
  const to = tgt.clone().sub(c.pos); const d = to.length();
  const last = hailr.seg === hailr.path.length - 1;
  c.speed = damp(c.speed, last ? Math.min(vmax, d * 0.9 + 1) : vmax, 2, dt);
  if (d < 0.6 || c.speed * dt >= d) { c.pos.copy(tgt); hailr.seg++; return hailr.seg >= hailr.path.length; }
  to.divideScalar(d); c.yaw = dampAngle(c.yaw, Math.atan2(to.x, to.z), 6, dt);
  const step = Math.min(d, c.speed * dt);
  c.pos.addScaledVector(V3(Math.sin(c.yaw), 0, Math.cos(c.yaw)), step * 0.35).addScaledVector(to, step * 0.65);
  return false;
}
function hailrUpdate(dt) {
  if (!hailr.car) return;
  const c = hailr.car;
  if (hailr.state === 'coming' && hailrDrive(dt, 13)) { hailr.state = 'waiting'; hud.toast('Your Hailr has arrived — press F to get in', 'good'); }
  if (hailr.state === 'riding' && hailrDrive(dt, 15)) {
    hailr.state = 'arrived'; exitHailr(true);
  }
  if (hailr.state === 'leaving') { hailr.t += dt; c.pos.addScaledVector(V3(Math.sin(c.yaw), 0, Math.cos(c.yaw)), 12 * dt); if (hailr.t > 5) { scene.remove(c.md.group); world.removeBody(c.body); hailr.car = null; hailr.state = 'none'; } }
  c.body.velocity.set((c.pos.x - c.body.position.x) / Math.max(dt, 1e-3), 0, (c.pos.z - c.body.position.z) / Math.max(dt, 1e-3));
  c.body.quaternion.setFromAxisAngle(Y_AXIS, c.yaw);
  c.md.group.position.copy(c.pos); c.md.group.rotation.y = c.yaw;
}
function enterHailr() {
  state.coins -= hailr.fare; hud.toast(`Riding to ${hailr.destName} · −${hailr.fare} coins`);
  hailr.path = routeBetween(hailr.car.pos, hailr.dest); hailr.seg = 1; hailr.state = 'riding';
  P.mode = 'passenger'; world.removeBody(playerBody); boardOnBack();
}
function exitHailr(arrived) {
  const c = hailr.car;
  const side = V3(-Math.cos(c.yaw), 0, Math.sin(c.yaw));
  const out = c.pos.clone().addScaledVector(side, 2.6);
  world.addBody(playerBody); placePlayer(out, c.yaw); P.mode = 'walk'; holdBoardInHand();
  avatar.group.position.set(0, 0, 0);
  hailr.state = 'leaving'; hailr.t = 0;
  if (arrived) { hud.toast(`Dropped off at ${hailr.destName}`, 'good'); missions.event('hailr', { pos: out }); }
}

/* --- enter / exit --- */
function nearestVehicle(maxD = 3.4) {
  const fp = feet(); let best = null, bd = maxD;
  for (const v of vehicles) { const d = Math.hypot(v.body.position.x - fp.x, v.body.position.z - fp.z); if (d < bd) { bd = d; best = { kind: 'veh', v }; } }
  for (const n of npcs) { const d = Math.hypot(n.body.position.x - fp.x, n.body.position.z - fp.z); if (d < bd + 0.6) { bd = d; best = { kind: 'npc', n }; } }
  if (hailr.car && hailr.state === 'waiting') { const d = hailr.car.pos.distanceTo(V3(fp.x, 0, fp.z)); if (d < 5) best = { kind: 'hailr' }; }
  return best;
}
function enterVehicle(v, how) {
  if (how === 'unlock') { if (state.coins < 5) { hud.toast('Unlocking a Zipp costs 5 coins', 'bad'); return; } state.coins -= 5; hud.toast(`${v.t.label} unlocked · −5 coins`); v.rented = true; }
  if (how === 'steal') { state.heat = Math.min(3, state.heat + 1); v.stolen = true; hud.toast(v.t.rental ? `Hot-wired a ${v.t.label} · heat +1` : `Took a ${v.t.label} · heat +1`, 'bad'); }
  P.air = null; P.grind = null; P.manual = null; P.grabbing = false;
  P.mode = 'drive'; P.vehicle = v; v.driver = true; world.removeBody(playerBody); boardOnBack(); v.body.wakeUp();
  P.rideStart = v.body.position.clone(); P.rideDist = 0;
  missions.event('enter', { v });
}
function jackNpc(n) {
  const pos = n.body.position.clone(), yaw = n.yaw;
  world.removeBody(n.body); scene.remove(n.md.group); npcs.splice(npcs.indexOf(n), 1);
  const v = new Vehicle('car', pos.x, pos.z, yaw, n.color);
  v.body.velocity.set(Math.sin(yaw) * n.speed * 0.6, 0, Math.cos(yaw) * n.speed * 0.6);
  spawnFleeing(V3(pos.x + Math.cos(yaw) * 1.6, 0, pos.z - Math.sin(yaw) * 1.6), yaw + Math.PI / 2);
  enterVehicle(v, 'steal');
  setTimeout(() => spawnNpc(Math.floor(rand(0, N)), Math.floor(rand(0, N)), rand(0, 100)), 8000);
}
function exitVehicle() {
  const v = P.vehicle; if (!v) return;
  if (Math.abs(v.speed) > 9) { hud.toast('Slow down to hop off'); return; }
  const y = v.yaw(); const side = V3(Math.cos(y), 0, -Math.sin(y));
  const out = V3(v.body.position.x, 0, v.body.position.z).addScaledVector(side, v.type === 'car' ? 1.8 : 0.9);
  world.addBody(playerBody); placePlayer(out, y);
  playerBody.velocity.set(v.body.velocity.x * 0.5, 0, v.body.velocity.z * 0.5);
  v.driver = false; v.idle(); P.vehicle = null; P.mode = 'walk'; holdBoardInHand();
  avatar.group.position.set(0, 0, 0); avatar.group.rotation.set(0, 0, 0);
  if (v.rented) { const cost = Math.floor((P.rideDist || 0) / 100); if (cost > 0) { state.coins -= cost; hud.toast(`Zipp ride ended · ${Math.round(P.rideDist)} m · −${cost} coins`); } v.rented = false; }
}

/* ============================== other skaters (simulated presence) ============================== */
const NAMES = ['kai.rolls', 'noa_sk8', 'dre.bombs', 'luz.lines', 'milo.manny', 'tavi_tre', 'june.grinds', 'sol.pushes', 'ari.flipz'];
const others = [];
function labelSprite(text, color = '#1d2433') {
  const c = document.createElement('canvas'); c.width = 256; c.height = 64; const x = c.getContext('2d');
  x.font = '600 26px Manrope, system-ui, sans-serif'; const w = Math.min(248, x.measureText(text).width + 36);
  x.fillStyle = 'rgba(255,255,255,0.92)'; x.beginPath(); x.roundRect((256 - w) / 2, 10, w, 42, 21); x.fill();
  x.fillStyle = color; x.textAlign = 'center'; x.textBaseline = 'middle'; x.fillText(text, 128, 32);
  const s = new THREE.Sprite(new THREE.SpriteMaterial({ map: new THREE.CanvasTexture(c), depthWrite: false, transparent: true }));
  s.scale.set(2.2, 0.55, 1); return s;
}
for (let k = 0; k < 7; k++) {
  const i = Math.floor(srand() * N), j = Math.floor(srand() * N);
  const g = new THREE.Group(); scene.add(g);
  const av = A.makeAvatar({ skin: A.SKIN_TONES[k % 5], hoodie: A.HOODIES[(k + 2) % 6], hat: pick(['#2b2f38', '#f2c14e', '#e85d5d', '#17b3a3']) });
  av.group.position.y = 0.11; av.group.rotation.y = -Math.PI / 2; g.add(av.group);
  const bp = new THREE.Group(); bp.position.y = 0.1; g.add(bp); const b = A.makeBoard({ deck: A.DECKS[k % 6] }); b.position.y = -0.1; bp.add(b);
  const lbl = labelSprite('@' + NAMES[k]); lbl.position.y = 2.25; g.add(lbl);
  const c = V3(blockAt(i), 0, blockAt(j)), o = SIDE - 1.2;
  const path = [V3(c.x - o, 0, c.z - o), V3(c.x - o, 0, c.z + o), V3(c.x + o, 0, c.z + o), V3(c.x + o, 0, c.z - o)];
  if (k % 2) path.reverse();
  others.push({ g, av, bp, path, s: srand() * 180, speed: rand(3.5, 6), hop: 0, hopT: rand(2, 6), flip: 0, name: NAMES[k], yaw: 0 });
  pose(av, { crouch: 0.2, skate: true });
}
function othersUpdate(dt) {
  for (const o of others) {
    o.s += o.speed * dt; const at = pathAt(o.path, o.s);
    o.yaw = dampAngle(o.yaw, Math.atan2(at.dir.x, at.dir.z), 6, dt);
    o.hopT -= dt;
    if (o.hopT < 0 && o.hop <= 0) { o.hop = 0.01; o.hopT = rand(3, 8); o.trick = pick(['Kickflip', 'Heelflip', 'Pop Shove-it', '360 Flip', 'Ollie']); }
    let y = 0;
    if (o.hop > 0) {
      o.hop += dt; const t = o.hop / 0.55; y = Math.sin(Math.PI * Math.min(1, t)) * 0.7;
      const fl = FLIPS[Object.keys(FLIPS).find((k) => FLIPS[k].name === o.trick)] || {};
      o.bp.rotation.set(0, (fl.shuv || 0) * Math.PI * 2 * Math.min(1, t), (fl.flip || 0) * Math.PI * 2 * Math.min(1, t), 'YXZ');
      if (t >= 1) { o.hop = 0; o.bp.rotation.set(0, 0, 0); if (Math.random() < 0.35) feed(`@${o.name} landed a ${o.trick}`); }
    }
    o.g.position.set(at.p.x, y, at.p.z); o.g.rotation.y = o.yaw;
  }
}
function feed(msg) { const el = document.createElement('div'); el.className = 'feed-item'; el.textContent = msg; $('feed').prepend(el); while ($('feed').children.length > 3) $('feed').lastChild.remove(); setTimeout(() => el.classList.add('fade'), 7000); }

/* ============================== avatar posing ============================== */
function pose(av, o) {
  const p = av.parts, c = o.crouch || 0;
  const setLeg = (leg, thigh, knee, spreadZ = 0) => { leg.rotation.set(thigh, 0, spreadZ); leg.userData.knee.rotation.x = knee; };
  const setArm = (arm, x, z, elbow = 0) => { arm.rotation.set(x, 0, z); arm.userData.elbow.rotation.x = elbow; };
  p.torso.rotation.set(0, 0, 0); p.head.rotation.set(0, 0, 0);
  if (o.skate) {
    p.hips.position.set(0, 0.92 - c * 0.26, 0);
    p.legL.position.x = 0.2; p.legR.position.x = -0.2;
    setLeg(p.legL, -c * 0.75, c * 1.45, 0.05); setLeg(p.legR, -c * 0.75, c * 1.45, -0.05);
    p.torso.rotation.x = 0.1 + c * 0.35 + (o.leanX || 0); p.torso.rotation.z = o.leanZ || 0;
    p.head.rotation.y = -1.1 - (o.leanZ || 0) * 0.5; p.head.rotation.x = -0.1;
    const arm = o.armOut ?? 0.55, bal = o.bal || 0;
    setArm(p.armL, -0.1, arm + bal * 0.8, -0.3); setArm(p.armR, 0.1, -arm + bal * 0.8, -0.3);
    if (o.push > 0) { const s = Math.sin(o.push / 0.55 * Math.PI); p.legR.position.x = -0.2 - s * 0.05; setLeg(p.legR, -0.2 - s * 0.6, 0.3 + s * 0.2, -0.25 - s * 0.35); p.hips.position.y -= s * 0.08; }
    if (o.grab) { setArm(p.armR, 0.9, -0.2, -1.2); p.torso.rotation.x += 0.35; }
  } else if (o.sit) {
    p.hips.position.set(0, 0.92, 0); p.legL.position.x = 0.12; p.legR.position.x = -0.12;
    setLeg(p.legL, -1.45, 1.35, 0.08); setLeg(p.legR, -1.45, 1.35, -0.08);
    setArm(p.armL, -1.1, 0.15, -0.3); setArm(p.armR, -1.1, -0.15, -0.3); p.torso.rotation.x = o.leanFwd || 0.05;
  } else if (o.stand) {
    p.hips.position.set(0, 0.92, 0); p.legL.position.x = 0.1; p.legR.position.x = -0.1;
    setLeg(p.legL, -0.15, 0.2); setLeg(p.legR, 0.25, 0.1);
    setArm(p.armL, -1.0, 0.2, -0.4); setArm(p.armR, -1.0, -0.2, -0.4); p.torso.rotation.x = 0.12;
  } else {
    const ph = o.phase || 0, amp = o.amp || 0;
    p.hips.position.set(0, 0.92 - Math.abs(Math.sin(ph)) * 0.03 * amp, 0);
    p.legL.position.x = 0.1; p.legR.position.x = -0.1;
    setLeg(p.legL, Math.sin(ph) * 0.6 * amp, Math.max(0, -Math.sin(ph)) * 0.9 * amp + 0.05);
    setLeg(p.legR, -Math.sin(ph) * 0.6 * amp, Math.max(0, Math.sin(ph)) * 0.9 * amp + 0.05);
    setArm(p.armL, -Math.sin(ph) * 0.5 * amp, 0.12, -0.2 - 0.3 * amp);
    setArm(p.armR, o.carry ? -0.25 : Math.sin(ph) * 0.5 * amp, o.carry ? -0.32 : -0.12, o.carry ? -0.35 : -0.2);
    p.torso.rotation.x = 0.06 * amp;
    if (o.jump) { setLeg(p.legL, -0.5, 0.8); setLeg(p.legR, -0.2, 0.6); }
  }
}

/* ============================== missions ============================== */
const MISSIONS = [
  { id: 'push', title: 'First Push', desc: 'Drop your board (Q) and skate to Sesh Plaza.', reward: 15, dest: () => spots.plaza, destName: 'Sesh Plaza',
    tick() { return P.mode === 'skate' && feet().distanceTo(spots.plaza) < 14; } },
  { id: 'kickflip', title: 'Flip the Five', desc: 'Pop off the plaza platform and land a Kickflip down the five-stair.', reward: 30, dest: () => V3(spots.plaza.x - 4, 0.9, spots.plaza.z + 14), destName: 'the five-stair',
    on: { land(d) { const s = spots.stairs; return d.tricks.some((t) => t.includes('Kickflip') || t.includes('360 Flip')) && d.startY > 0.5 && d.pos.x > s.min.x - 2 && d.pos.x < s.max.x + 3 && d.pos.z > s.min.z - 6 && d.pos.z < s.max.z; } } },
  { id: 'grind', title: 'Ledge Life', desc: 'Hold E near a ledge or rail and grind for 2.5 seconds straight.', reward: 25, dest: () => spots.plaza, destName: 'Sesh Plaza',
    on: { grind(d) { return d.time >= 2.5; } }, progress: () => `best ${(missions.best.grind || 0).toFixed(1)}s` },
  { id: 'combo', title: 'Line Up', desc: 'Bank a 2,000-point combo — chain flips, grinds and manuals.', reward: 30, dest: () => spots.kickerpark, destName: 'Kicker Park',
    on: { combo(d) { return d.total >= 2000; } }, progress: () => `best ${fmt(missions.best.combo || 0)}` },
  { id: 'hailr', title: 'Late for the Sesh', desc: 'Call a Hailr (H) and ride to Kicker Park.', reward: 20, dest: () => spots.kickerpark, destName: 'Kicker Park',
    on: { hailr(d) { return d.pos.distanceTo(spots.kickerpark) < 45; } } },
  { id: 'zipp', title: 'Zipp Around', desc: 'Unlock (F) or hot-wire (G) a Zipp e-bike or scooter and ride 250 m.', reward: 20, dest: () => docks[3], destName: 'the Zipp dock',
    tick() { return P.vehicle && P.vehicle.t.rental && P.rideDist >= 250; }, progress: () => (P.vehicle && P.vehicle.t.rental ? `${Math.round(P.rideDist)} / 250 m` : 'find a teal dock') },
  { id: 'joyride', title: 'Joyride', desc: 'Get in any car and reach the end of The Pier within 75 seconds.', reward: 40, dest: () => spots.pier, destName: 'The Pier',
    tick() { if (P.vehicle && P.vehicle.type === 'car' && missions.timer == null) missions.timer = 75; return P.vehicle && P.vehicle.type === 'car' && P.vehicle.body.position.distanceTo(new CANNON.Vec3(spots.pier.x, spots.pier.y + 1, spots.pier.z)) < 9; },
    progress: () => (missions.timer != null ? `${Math.max(0, missions.timer).toFixed(0)} s left` : 'find a car') },
  { id: 'free', title: 'Free Skate', desc: 'Every mission done. Set a high score, explore the city, hit The Pier drop.', reward: 0, dest: () => spots.pier, destName: 'The Pier', tick() { return false; } },
];
const missions = {
  idx: 0, best: {}, timer: null,
  current() { return MISSIONS[this.idx]; },
  complete() {
    const m = this.current(); if (m.id === 'free') return;
    addCoins(m.reward, m.title); hud.banner('MISSION COMPLETE', 'good');
    this.idx = Math.min(MISSIONS.length - 1, this.idx + 1); this.timer = null; this.render();
  },
  skip() { if (this.current().id !== 'free') { this.idx++; this.timer = null; this.render(); } },
  event(type, d) {
    if (type === 'grind') this.best.grind = Math.max(this.best.grind || 0, d.time);
    if (type === 'combo') this.best.combo = Math.max(this.best.combo || 0, d.total);
    const m = this.current();
    if (m.on && m.on[type] && m.on[type](d)) this.complete();
  },
  tick(dt) {
    const m = this.current();
    if (this.timer != null) { this.timer -= dt; if (this.timer <= 0) { this.timer = null; hud.toast('Out of time — try the joyride again', 'bad'); } }
    if (m.tick && m.tick()) this.complete();
  },
  render() {
    const m = this.current();
    $('m-title').textContent = m.title; $('m-desc').textContent = m.desc;
    $('m-reward').textContent = m.reward ? `+${m.reward} coins` : '';
    $('m-step').textContent = `${Math.min(this.idx + 1, MISSIONS.length - 1)} / ${MISSIONS.length - 1}`;
    const pin = pins.mission; const d = m.dest && m.dest(); if (d) { pin.visible = true; pin.position.set(d.x, d.y || 0, d.z); } else pin.visible = false;
  },
};
const pins = { mission: A.makePin('#ff4f6d') };
scene.add(pins.mission);
$('m-skip').addEventListener('click', () => missions.skip());

/* ============================== minimap ============================== */
const MAPR = 260;
const mapBase = document.createElement('canvas'); mapBase.width = mapBase.height = MAPR * 2;
{
  const x = mapBase.getContext('2d');
  x.fillStyle = A.PALETTE.land; x.fillRect(0, 0, MAPR * 2, MAPR * 2);
  const rect = (a, c) => { x.fillStyle = c; x.fillRect(a.x - a.w / 2 + MAPR, a.z - a.d / 2 + MAPR, a.w, a.d); };
  mapAreas.filter((a) => !a.road).forEach((a) => rect(a, a.color));
  mapAreas.filter((a) => a.road).forEach((a) => rect({ ...a, w: a.w + 2, d: a.d + 2 }, '#e3e0da'));
  mapAreas.filter((a) => a.road).forEach((a) => rect(a, '#ffffff'));
  footprints.forEach((f) => { x.fillStyle = '#dcd7cf'; x.fillRect(f.x - f.w / 2 + MAPR, f.z - f.d / 2 + MAPR, f.w, f.d); x.strokeStyle = '#cfc9c0'; x.strokeRect(f.x - f.w / 2 + MAPR, f.z - f.d / 2 + MAPR, f.w, f.d); });
}
const mm = $('minimap'), mctx = mm.getContext('2d');
function drawMinimap() {
  const W = mm.width, cx = W / 2, s = W / 150;
  const fp = playerPos(), y = cam.yaw;
  mctx.setTransform(1, 0, 0, 1, 0, 0); mctx.clearRect(0, 0, W, W);
  mctx.save(); mctx.beginPath(); mctx.arc(cx, cx, cx - 2, 0, Math.PI * 2); mctx.clip();
  mctx.setTransform(-s * Math.cos(y), -s * Math.sin(y), s * Math.sin(y), -s * Math.cos(y), cx, cx);
  mctx.drawImage(mapBase, -MAPR - fp.x, -MAPR - fp.z);
  mctx.setTransform(1, 0, 0, 1, 0, 0);
  const toS = (wx, wz) => { const dx = wx - fp.x, dz = wz - fp.z; return [cx + s * (-Math.cos(y) * dx + Math.sin(y) * dz), cx + s * (-Math.sin(y) * dx - Math.cos(y) * dz)]; };
  const dot = (wx, wz, r, c, edge = false) => {
    let [sx, sy] = toS(wx, wz); const dx = sx - cx, dy = sy - cx, d = Math.hypot(dx, dy);
    if (d > cx - 10) { if (!edge) return; sx = cx + dx / d * (cx - 10); sy = cx + dy / d * (cx - 10); }
    mctx.fillStyle = c; mctx.beginPath(); mctx.arc(sx, sy, r, 0, Math.PI * 2); mctx.fill(); mctx.strokeStyle = '#fff'; mctx.lineWidth = 2; mctx.stroke();
  };
  for (const d of docks) dot(d.x, d.z, 4, A.PALETTE.zipp);
  for (const o of others) dot(o.g.position.x, o.g.position.z, 3.5, '#5b6cff');
  for (const n of npcs) dot(n.body.position.x, n.body.position.z, 3, '#9aa3ad');
  if (hailr.car) dot(hailr.car.pos.x, hailr.car.pos.z, 5, A.PALETTE.hailrSign, true);
  if (pins.mission.visible) dot(pins.mission.position.x, pins.mission.position.z, 6, '#ff4f6d', true);
  mctx.restore();
  // player arrow
  mctx.save(); mctx.translate(cx, cx); mctx.rotate(P.visYaw - y);
  mctx.fillStyle = '#2f7bff'; mctx.strokeStyle = '#fff'; mctx.lineWidth = 2.5;
  mctx.beginPath(); mctx.moveTo(0, -9); mctx.lineTo(7, 7); mctx.lineTo(0, 3); mctx.lineTo(-7, 7); mctx.closePath(); mctx.fill(); mctx.stroke();
  mctx.restore();
  $('compass').style.transform = `rotate(${(y) * 180 / Math.PI + 180}deg)`;
}

/* ============================== context prompt ============================== */
let prompt = null;
function computePrompt() {
  if (P.mode === 'drive') return [['F', P.vehicle.t.rental && P.vehicle.rented ? 'End ride' : 'Get out'], ['R', 'Flip upright']];
  if (P.mode === 'passenger') return [['F', 'Hop out early']];
  if (P.mode !== 'walk' && P.mode !== 'skate') return null;
  const nv = nearestVehicle();
  if (!nv) return null;
  if (nv.kind === 'hailr') return [['F', 'Get in your Hailr']];
  if (nv.kind === 'npc') return [['F', 'Pull the driver out · heat +1']];
  const v = nv.v;
  if (v.t.rental) return [['F', `Unlock ${v.t.label} · 5 coins`], ['G', 'Hot-wire · heat +1']];
  return [['F', `Take ${v.t.label.toLowerCase()} · heat +1`]];
}
function renderPrompt(p) {
  const key = JSON.stringify(p); if (key === prompt) return; prompt = key;
  $('prompt').innerHTML = p ? p.map(([k, t]) => `<div class="pill"><kbd>${k}</kbd><span>${t}</span></div>`).join('') : '';
}

/* ============================== main update ============================== */
function handleActions() {
  if (hit('KeyM')) { audio.radioOn = !audio.radioOn; hud.toast(audio.radioOn ? 'SeshFM on' : 'SeshFM off'); }
  if (hit('KeyH') && (P.mode === 'walk' || P.mode === 'skate')) callHailr();
  if (P.mode === 'walk' || P.mode === 'skate') {
    const nv = nearestVehicle();
    if (hit('KeyF') && nv) {
      if (nv.kind === 'hailr') enterHailr();
      else if (nv.kind === 'npc') jackNpc(nv.n);
      else enterVehicle(nv.v, nv.v.t.rental ? 'unlock' : 'steal');
      return;
    }
    if (hit('KeyG') && nv && nv.kind === 'veh' && nv.v.t.rental) { enterVehicle(nv.v, 'steal'); return; }
  }
  if (P.mode === 'drive') { if (hit('KeyF')) exitVehicle(); else if (hit('KeyR')) P.vehicle.reset(); }
  else if (P.mode === 'passenger' && hit('KeyF')) { hailr.state = 'leaving'; exitHailr(false); }
  if (hit('KeyQ')) {
    if (P.mode === 'walk' && P.grounded) { P.mode = 'skate'; boardUnderFeet(); P.speed = Math.max(P.walkSpeed || 0, 1.5); P.fakie = false; }
    else if (P.mode === 'skate' && P.grounded && !P.grind) { bankCombo(); P.mode = 'walk'; P.manual = null; holdBoardInHand(); avatar.group.rotation.set(0, 0, 0); }
  }
  // arrows → trick buffer / manuals
  for (const [code, d] of Object.entries(ARROWS)) {
    if (!hit(code) || P.mode !== 'skate') continue;
    if (P.grind) continue;
    if (P.grounded && P.crouch < 0.05) { if (d === 'D') startManual(false); else if (d === 'U') startManual(true); continue; }
    trickBuf.push({ d, t: gameTime });
  }
  if (trickBuf.length && gameTime - trickBuf[0].t > 0.13) {
    const code = trickBuf.slice(0, 2).map((b) => b.d).join(''); trickBuf = [];
    if (P.mode === 'skate') {
      if (!P.grounded && P.air && (!P.air.flip || P.air.flip.done) && !P.grabbing) startFlip(code);
      else if (P.grounded && P.crouch > 0.05) P.pendingTrick = code;
    }
  }
}

let hudT = 0, gameTime = 0;
function update(dt) {
  gameTime += dt;
  const inp = moveInput();
  if (state.started) handleActions();

  // ---- pre-physics
  if (P.mode === 'skate') skatePre(dt, inp);
  else if (P.mode === 'walk') walkPre(dt, inp);
  else if (P.mode === 'bail') { P.bail.t += dt; if (!P.grounded) playerBody.velocity.y -= 4 * dt; else { playerBody.velocity.x *= 0.92; playerBody.velocity.z *= 0.92; } if (P.bail.t > 2.1) recover(); }
  for (const v of vehicles) { if (v === P.vehicle) v.drive(dt, inp, down('Space')); else if (!v.body.sleepState) v.idle(); v.stabilize(); }
  npcUpdate(dt);
  hailrUpdate(dt);

  world.step(1 / 60, dt, 4);

  // ---- post-physics
  if (P.mode === 'skate' || P.mode === 'walk' || P.mode === 'bail') {
    const g = P.grind ? null : probeGround();
    const wasGrounded = P.grounded;
    const minAir = P.air && P.air.t < 0.12 && P.air.popped;
    const groundedNow = !!g && g.dist < R + (wasGrounded ? 0.22 : 0.09) && g.n.y > 0.6 && !minAir && playerBody.velocity.y < 6;
    if (P.grind) P.grounded = false;
    else if (groundedNow) {
      P.groundN.copy(g.n); P.grounded = true;
      if (!wasGrounded && P.mode === 'skate') land(g.n);
      else if (!wasGrounded && P.mode === 'walk' && P.airT > 0.4) audio.land(false);
      P.airT = 0;
    } else {
      if (wasGrounded && P.mode === 'skate' && !P.air) { beginAir(false); if (P.lastSlopeVy > 0.3) playerBody.velocity.y = P.lastSlopeVy * 1.7; }
      P.grounded = false; P.airT = (P.airT || 0) + dt;
    }
    if (P.mode === 'skate' && P.grounded) {
      const hv = V3(playerBody.velocity.x, playerBody.velocity.y, playerBody.velocity.z);
      const along = hv.dot(skateFwd());
      if (P._intended > 7.5 && along < P._intended * 0.35) bail('Slammed');
      else if (P._intended > 0.5) P.speed = Math.max(0, Math.min(P.speed, along + 0.4));
      combo.idle += P.manual ? 0 : dt;
      if (comboActive() && combo.idle > 0.7) bankCombo();
    }
    if (P.mode === 'walk' && comboActive()) bankCombo();
  }
  if (P.mode === 'drive') {
    const v = P.vehicle; const p = v.body.position;
    const step = Math.hypot(p.x - P.rideStart.x, p.z - P.rideStart.z); P.rideDist += step; P.rideStart.copy(p);
    if (!v.stolen && state.heat > 0) state.heat = Math.max(0, state.heat - dt * 0.03);
  } else state.heat = Math.max(0, state.heat - dt * 0.05);

  // ---- visuals
  syncPlayer(dt);
  for (const v of vehicles) v.sync(dt);
  npcSync();
  othersUpdate(dt);
  for (const f of fleeing) {
    f.t += dt; f.av.group.position.addScaledVector(V3(Math.sin(f.yaw), 0, Math.cos(f.yaw)), 5 * dt); f.av.group.rotation.y = f.yaw;
    pose(f.av, { phase: f.t * 12, amp: 1 });
    if (f.t > 4) { scene.remove(f.av.group); f.dead = true; }
  }
  for (let k = fleeing.length - 1; k >= 0; k--) if (fleeing[k].dead) fleeing.splice(k, 1);
  if (debrisBoard) { board.position.copy(debrisBoard.position); board.quaternion.copy(debrisBoard.quaternion); board.translateY(-0.1); }
  pins.mission.userData.head.position.y = 4.2 + Math.sin(performance.now() / 400) * 0.25;
  pins.mission.rotation.y += dt * 0.8;
  if (state.started) missions.tick(dt);
  updateCamera(dt);
  const fp = playerPos();
  sun.position.copy(fp).addScaledVector(sunDir, 120); sun.target.position.copy(fp);
  G.uTime.value += dt;
  if (waterMat) { waterMat.normalMap.offset.x += dt * 0.004; waterMat.normalMap.offset.y += dt * 0.0025; waterMat.clearcoatNormalMap.offset.x -= dt * 0.003; }
  particles.update(dt);

  const skating = P.mode === 'skate' && P.grounded && !P.grind;
  audio.update(skating ? P.speed : 0, !!P.grind, P.vehicle ? Math.abs(P.vehicle.speed) : 0, P.vehicle && !P.vehicle.t.rental);

  hudT -= dt;
  if (hudT <= 0) { hudT = 0.1; renderHud(); drawMinimap(); }
  renderPrompt(state.started ? computePrompt() : null);
  pressed.clear(); released.clear();
}

function syncPlayer(dt) {
  const fp = feet();
  if (P.mode === 'drive') {
    const v = P.vehicle, t = v.t;
    rig.position.copy(v.mesh.position); rig.quaternion.copy(v.mesh.quaternion);
    rig.translateX(t.seat[0]); rig.translateZ(t.seat[2]);
    avatar.group.position.set(0, t.sit ? t.seat[1] - 0.92 + 0.08 : t.seat[1], 0); avatar.group.rotation.set(0, 0, 0);
    pose(avatar, t.sit ? { sit: true, leanFwd: v.type === 'moto' ? 0.45 : 0.05 } : { stand: true });
    P.visYaw = v.yaw();
    return;
  }
  if (P.mode === 'passenger' && hailr.car) {
    const c = hailr.car; rig.position.copy(c.pos); rig.rotation.set(0, c.yaw, 0); rig.translateX(-0.4); rig.translateZ(-0.9);
    avatar.group.position.set(0, 0.42 - 0.84, 0); pose(avatar, { sit: true }); P.visYaw = c.yaw; return;
  }
  rig.quaternion.identity();
  rig.position.copy(fp);
  if (P.mode === 'walk') {
    P.visYaw = P.yaw; rig.rotation.y = P.visYaw;
    avatar.group.position.y = 0; avatar.group.rotation.y = 0;
    P.walkPhase += (P.walkSpeed || 0) * dt * 3.2;
    pose(avatar, { phase: P.walkPhase, amp: clamp((P.walkSpeed || 0) / 3, 0, 1.2), carry: true, jump: !P.grounded });
  } else if (P.mode === 'skate') {
    const a = P.air, g = P.grind;
    const baseYaw = P.yaw + (P.fakie ? Math.PI : 0);
    P.visYaw = baseYaw + (a ? a.spin : 0);
    rig.rotation.set(0, P.visYaw, 0);
    if (P.grounded) rig.rotateZ(P.lean * 0.12);
    avatar.group.position.y = 0.11; avatar.group.rotation.y = -Math.PI / 2;
    let crouch = P.crouch * 0.9 + 0.12, leanX = 0, leanZ = P.lean * 0.3, bal = 0, grab = false;
    boardPivot.rotation.set(0, 0, 0); boardPivot.position.set(0, 0.1, 0);
    if (a) {
      const fl = a.flip && !a.flip.done ? a.flip : null;
      crouch = fl ? 0.75 : P.grabbing ? 1 : 0.35;
      if (fl) {
        const e = 1 - Math.pow(1 - fl.t, 2), d = fl.def, T = Math.PI * 2 * e;
        boardPivot.rotation.set((d.wrap || 0) * T, (d.shuv || 0) * T, (d.flip || 0) * T, 'YXZ');
        boardPivot.position.y = 0.1 + Math.sin(fl.t * Math.PI) * 0.18;
        avatar.group.position.y = 0.11 + Math.sin(fl.t * Math.PI) * 0.28;
      }
      grab = P.grabbing;
    }
    if (g) { crouch = 0.35; bal = g.bal; leanZ = g.bal * 0.5; if (g.type === 'L' || g.type === 'R') boardPivot.rotation.y = Math.PI / 2 * 0.85; if (g.type === 'U') boardPivot.rotation.x = 0.18; if (g.type === 'D') boardPivot.rotation.x = -0.18; }
    if (P.manual) { const m = P.manual; boardPivot.rotation.x = m.nose ? 0.22 : -0.22; boardPivot.position.y = 0.1 + 0.07; leanX = (m.nose ? 0.25 : -0.3); bal = m.bal; leanZ = 0; }
    pose(avatar, { skate: true, crouch, leanX, leanZ, bal, grab, push: P.grounded && !P.manual ? P.pushT : 0 });
  } else if (P.mode === 'bail') {
    rig.rotation.set(0, P.visYaw, 0);
    const t = clamp(P.bail.t / 0.5, 0, 1);
    avatar.group.rotation.set(-t * Math.PI / 2 * 0.95, P.bail.from === 'skate' ? -Math.PI / 2 : 0, Math.sin(P.bail.t * 3) * 0.1 * (1 - t));
    avatar.group.position.y = 0.15 * t;
    pose(avatar, { phase: 0, amp: 0 });
  }
}

const camRay = new CANNON.RaycastResult();
function updateCamera(dt) {
  const fp = feet();
  let target, yawTarget = null, dist = 5.2, height = 1.45;
  if (!state.started) {
    cam.yaw += dt * 0.25; target = fp.clone().add(V3(0, 1.1, 0)); dist = 4.2;
  } else if (P.mode === 'drive') {
    const v = P.vehicle; target = V3(v.mesh.position.x, v.mesh.position.y + 1.3, v.mesh.position.z); yawTarget = v.yaw(); dist = v.t.cam;
    if (v.speed < -1) yawTarget += Math.PI;
  } else if (P.mode === 'passenger' && hailr.car) {
    target = hailr.car.pos.clone().add(V3(0, 1.5, 0)); yawTarget = hailr.car.yaw; dist = 8;
  } else {
    target = fp.clone().add(V3(0, height, 0));
    if (P.mode === 'skate' && !P.grind) yawTarget = P.speed > 0.8 ? P.yaw : null;
    if (P.grind) yawTarget = P.yaw;
    dist = P.mode === 'skate' ? 5.4 + clamp(P.speed / 12, 0, 1) * 1.2 : 4.6;
  }
  cam.idle += dt;
  if (yawTarget != null) {
    cam.yaw = dampAngle(cam.yaw, yawTarget, P.air ? 1.2 : 3.2, dt);
    if (cam.idle > 1.4) { cam.userYaw = damp(cam.userYaw, 0, 2, dt); cam.userPitch = damp(cam.userPitch, 0, 2, dt); }
  } else if (state.started) { cam.yaw += cam.userYaw; cam.userYaw = 0; }
  const yaw = cam.yaw + cam.userYaw, pitch = cam.pitch + cam.userPitch;
  cam.dist = damp(cam.dist, dist, 3, dt);
  const want = target.clone().add(V3(-Math.sin(yaw) * Math.cos(pitch), Math.sin(pitch), -Math.cos(yaw) * Math.cos(pitch)).multiplyScalar(cam.dist));
  want.y = Math.max(want.y, target.y - 0.6, 0.4);
  camRay.reset();
  world.raycastClosest(new CANNON.Vec3(target.x, target.y, target.z), new CANNON.Vec3(want.x, want.y, want.z), { collisionFilterMask: G_WORLD, skipBackfaces: true }, camRay);
  if (camRay.hasHit && !(camRay.body.userData && (camRay.body.userData.vehicle === P.vehicle && P.vehicle))) {
    const hp = camRay.hitPointWorld; const back = V3(hp.x, hp.y, hp.z).sub(target); const l = back.length();
    want.copy(target).addScaledVector(back.normalize(), Math.max(0.8, l - 0.35));
  }
  cam.pos.lerp(want, 1 - Math.exp(-10 * dt)); cam.look.lerp(target, 1 - Math.exp(-14 * dt));
  camera.position.copy(cam.pos); camera.lookAt(cam.look);
  const spd = P.mode === 'drive' ? Math.abs(P.vehicle.speed) : P.mode === 'skate' ? P.speed : 0;
  const fov = 62 + clamp(spd / (P.mode === 'drive' ? 35 : 12), 0, 1) * 10;
  if (Math.abs(camera.fov - fov) > 0.05) { camera.fov = damp(camera.fov, fov, 3, dt); camera.updateProjectionMatrix(); }
}

/* ============================== HUD render ============================== */
function renderHud() {
  $('coins').textContent = fmt(state.coins);
  $('score').textContent = fmt(state.score);
  document.querySelectorAll('#heat i').forEach((el, k) => el.classList.toggle('on', state.heat > k + 0.05));
  const modeNames = { walk: 'On foot', skate: P.fakie ? 'Skating · fakie' : 'Skating', drive: P.vehicle ? P.vehicle.t.label : '', passenger: 'Hailr ride', bail: 'Bailed' };
  $('mode').textContent = modeNames[P.mode] || '';
  let kmh = 0;
  if (P.mode === 'skate') kmh = (P.grind ? P.grind.speed : Math.hypot(playerBody.velocity.x, playerBody.velocity.z)) * 3.6;
  else if (P.mode === 'walk') kmh = (P.walkSpeed || 0) * 3.6;
  else if (P.mode === 'drive') kmh = Math.abs(P.vehicle.speed) * 3.6;
  else if (P.mode === 'passenger' && hailr.car) kmh = hailr.car.speed * 3.6;
  $('speed').textContent = Math.round(kmh);
  // combo text
  const ct = $('combo');
  if (comboActive()) {
    const live = P.grind ? P.grind.name : P.manual ? (P.manual.nose ? 'Nose Manual' : 'Manual') : P.grabbing && P.air ? P.air.grabName : '';
    const parts = combo.parts.slice(-5).join(' + ') + (live && combo.parts[combo.parts.length - 1] !== live ? ` + ${live}` : '');
    ct.innerHTML = `<div class="parts">${parts}</div><div class="total">${fmt(combo.base)} <span>× ${Math.max(1, combo.mult)}</span></div>`;
    ct.className = 'show';
  } else ct.className = '';
  // balance meter
  const bal = P.grind ? P.grind.bal : P.manual ? P.manual.bal : null;
  $('balance').className = bal == null ? '' : 'show';
  if (bal != null) { $('needle').style.left = `${50 + clamp(bal, -1, 1) * 48}%`; $('needle').classList.toggle('warn', Math.abs(bal) > 0.65); }
  // crouch meter
  $('pop').style.transform = `scaleX(${P.mode === 'skate' ? P.crouch : 0})`;
  const m = missions.current();
  $('m-prog').textContent = m.progress ? m.progress() : (m.dest ? `${Math.round(playerPos().distanceTo(m.dest()))} m away` : '');
  $('rideinfo').hidden = !(P.mode === 'passenger');
  if (P.mode === 'passenger') $('rideinfo').textContent = `Hailr · heading to ${hailr.destName}`;
}

/* ============================== touch controls ============================== */
const isTouch = matchMedia('(pointer: coarse)').matches;
if (isTouch) {
  document.body.classList.add('touch');
  const base = $('stick'), knob = $('knob'); let sid = null, c0 = null;
  base.addEventListener('pointerdown', (e) => { sid = e.pointerId; base.setPointerCapture(sid); const r = base.getBoundingClientRect(); c0 = { x: r.left + r.width / 2, y: r.top + r.height / 2, r: r.width / 2 }; move(e); });
  const move = (e) => { if (e.pointerId !== sid) return; let dx = (e.clientX - c0.x) / c0.r, dy = (e.clientY - c0.y) / c0.r; const l = Math.hypot(dx, dy); if (l > 1) { dx /= l; dy /= l; } stick.x = dx; stick.y = -dy; knob.style.transform = `translate(${dx * 36}px, ${dy * 36}px)`; };
  base.addEventListener('pointermove', move);
  const end = (e) => { if (e.pointerId !== sid) return; sid = null; stick.x = stick.y = 0; knob.style.transform = ''; };
  base.addEventListener('pointerup', end); base.addEventListener('pointercancel', end);
}
document.querySelectorAll('[data-key]').forEach((b) => {
  const code = b.dataset.key;
  b.addEventListener('pointerdown', (e) => { e.preventDefault(); if (!keys.has(code)) pressed.add(code); keys.add(code); b.classList.add('down'); });
  const off = () => { if (keys.has(code)) { keys.delete(code); released.add(code); } b.classList.remove('down'); };
  b.addEventListener('pointerup', off); b.addEventListener('pointerleave', off); b.addEventListener('pointercancel', off);
});

/* ============================== onboarding ============================== */
const saved = (() => { try { return JSON.parse(localStorage.getItem('skatecity.profile') || 'null'); } catch { return null; } })();
const profile = saved || { username: 'rookie_' + Math.floor(rand(100, 999)), skin: 3, hoodie: 0, deck: 0 };

// iOS app passes avatar as direct hex colors via query params — skip the in-game onboarding card
const _q = new URLSearchParams(location.search);
const _appSkin    = _q.get('skin');
const _appHoodie  = _q.get('hoodie');
const _appDeck    = _q.get('deck');
const _appUser    = _q.get('username');
const _fromApp    = !!(_appSkin || _appHoodie || _appDeck || _appUser);

function swatches(id, list, keyName) {
  const el = $(id); el.innerHTML = '';
  list.forEach((c, k) => {
    const b = document.createElement('button'); b.type = 'button'; b.style.background = c; b.setAttribute('aria-label', `${keyName} ${k + 1}`);
    b.className = profile[keyName] === k ? 'sel' : '';
    b.addEventListener('click', () => { profile[keyName] = k; applyProfile(); swatches(id, list, keyName); });
    el.appendChild(b);
  });
}
function applyProfile() {
  // Honor iOS hex colors when launched from the StreetSesh app; fall back to palette indices
  avatar.setColors({
    skin:   _appSkin   || A.SKIN_TONES[profile.skin],
    hoodie: _appHoodie || A.HOODIES[profile.hoodie],
  });
  if (_appDeck) board.userData.setDeck(_appDeck);
  else board.userData.setDeck(A.DECKS[profile.deck]);
}
swatches('sw-skin', A.SKIN_TONES, 'skin'); swatches('sw-hoodie', A.HOODIES, 'hoodie'); swatches('sw-deck', A.DECKS, 'deck');
$('username').value = _appUser || profile.username; applyProfile();
$('onboard').addEventListener('submit', (e) => {
  e.preventDefault();
  const name = ($('username').value || '').trim().replace(/[^a-zA-Z0-9._-]/g, '').slice(0, 18) || profile.username;
  profile.username = name; state.username = name;
  try { localStorage.setItem('skatecity.profile', JSON.stringify(profile)); } catch {}
  const chipColor = _appHoodie || A.HOODIES[profile.hoodie];
  $('uname').textContent = '@' + name; $('avatar-chip').textContent = name[0].toUpperCase(); $('avatar-chip').style.background = chipColor;
  $('intro').hidden = true; $('hud').hidden = false;
  state.started = true; audio.start(); missions.render();
  cam.yaw = P.yaw; cam.userYaw = 0;
  hud.toast('Press Q to drop your board');
  setTimeout(() => feed('@kai.rolls is skating Sesh Plaza'), 2500);
});
$('help-btn').addEventListener('click', () => { $('help').hidden = !$('help').hidden; });
$('help-close').addEventListener('click', () => { $('help').hidden = true; });
addEventListener('keydown', (e) => { if (e.code === 'Slash' || e.code === 'Tab') $('help').hidden = !$('help').hidden; });
$('radio-btn').addEventListener('click', () => { audio.start(); audio.radioOn = !audio.radioOn; $('radio-btn').classList.toggle('off', !audio.radioOn); });

/* ============================== boot ============================== */
const gfx = (() => { try { return JSON.parse(localStorage.getItem('skatecity.gfx') || 'null'); } catch { return null; } })() || { time: 'golden', quality: isTouch ? 'low' : 'high' };
setQuality(gfx.quality); setTime(gfx.time);
const saveGfx = () => { try { localStorage.setItem('skatecity.gfx', JSON.stringify({ time: G.time, quality: G.quality })); } catch {} };
$('time-btn').addEventListener('click', () => { const k = Object.keys(TIMES); setTime(k[(k.indexOf(G.time) + 1) % k.length]); saveGfx(); });
$('gfx-btn').addEventListener('click', () => { const k = Object.keys(QUALITY); setQuality(k[(k.indexOf(G.quality) + 1) % k.length]); saveGfx(); });
placePlayer(V3(-62.8, 0, -66), 0);
missions.render();
$('loading').hidden = true; $('golabel').hidden = false; $('go').disabled = false;

// When launched from the StreetSesh iOS app, skip the onboarding card entirely
if (_fromApp) {
  const name = (_appUser || '').replace(/[^a-zA-Z0-9._-]/g, '').slice(0, 18) || profile.username;
  state.username = name;
  $('uname').textContent = '@' + name;
  $('avatar-chip').textContent = name[0].toUpperCase();
  $('avatar-chip').style.background = _appHoodie || A.HOODIES[profile.hoodie];
  $('intro').hidden = true; $('hud').hidden = false;
  state.started = true; audio.start(); missions.render();
  cam.yaw = P.yaw; cam.userYaw = 0;
  hud.toast('Press Q to drop your board 🛹');
  setTimeout(() => feed('@' + name + ' just dropped into SkateCity'), 2200);
}
let last = performance.now();
function frame(now) {
  requestAnimationFrame(frame);
  if (window.__pause) { last = now; return; }
  const dt = clamp((now - last) / 1000, 0, 0.05); last = now;
  update(dt);
  renderFrame();
}
requestAnimationFrame(frame);
window.__sc = { Vehicle, update, pose, render: renderFrame, setTime, setQuality, cam, P, playerBody, vehicles, npcs, missions, state, world, keys, pressed, spots, combo, hailr };
