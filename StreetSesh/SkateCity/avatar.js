// StreetSesh — avatar.js
// Original character + skateboard system. No franchise references.
// Exports classes for AvatarModel, SkateboardModel, and support classes,
// plus backwards-compat factory functions consumed by assets.js.
import * as THREE from 'three';

/* ─── Canvas texture generators ───────────────────────────────────────────── */

function makeSkinTex(hex) {
  if (typeof document === 'undefined') return null;
  const cv = document.createElement('canvas'); cv.width = cv.height = 128;
  const x = cv.getContext('2d');
  x.fillStyle = hex; x.fillRect(0, 0, 128, 128);
  const g = x.createRadialGradient(64, 45, 8, 64, 45, 72);
  g.addColorStop(0, 'rgba(255,200,150,0.10)'); g.addColorStop(1, 'rgba(60,10,0,0.10)');
  x.fillStyle = g; x.fillRect(0, 0, 128, 128);
  for (let i = 0; i < 180; i++) {
    x.fillStyle = `rgba(0,0,0,${Math.random() * 0.055 + 0.01})`;
    x.fillRect(Math.random() * 128, Math.random() * 128, 1, 1);
  }
  const t = new THREE.CanvasTexture(cv); t.colorSpace = THREE.SRGBColorSpace; return t;
}

function makeHoodieTex(hex) {
  if (typeof document === 'undefined') return null;
  const cv = document.createElement('canvas'); cv.width = cv.height = 256;
  const x = cv.getContext('2d');
  x.fillStyle = hex; x.fillRect(0, 0, 256, 256);
  x.globalAlpha = 0.038;
  for (let i = 0; i < 256; i += 3) {
    x.strokeStyle = i % 6 === 0 ? '#000' : '#fff';
    x.lineWidth = 0.5;
    x.beginPath(); x.moveTo(0, i); x.lineTo(256, i); x.stroke();
    x.beginPath(); x.moveTo(i, 0); x.lineTo(i, 256); x.stroke();
  }
  x.globalAlpha = 0.05;
  for (let i = 0; i < 6; i++) {
    const gw = x.createRadialGradient(Math.random() * 256, Math.random() * 256, 4, Math.random() * 256, Math.random() * 256, 28);
    gw.addColorStop(0, 'rgba(255,255,255,0.45)'); gw.addColorStop(1, 'rgba(0,0,0,0)');
    x.fillStyle = gw; x.fillRect(0, 0, 256, 256);
  }
  x.globalAlpha = 1;
  const t = new THREE.CanvasTexture(cv); t.colorSpace = THREE.SRGBColorSpace;
  t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(2, 4); return t;
}

function makeDenimTex(hex) {
  if (typeof document === 'undefined') return null;
  const cv = document.createElement('canvas'); cv.width = 256; cv.height = 512;
  const x = cv.getContext('2d');
  x.fillStyle = hex; x.fillRect(0, 0, 256, 512);
  x.globalAlpha = 0.05;
  for (let i = -256; i < 768; i += 4) {
    x.strokeStyle = i % 8 < 4 ? '#000' : '#fff'; x.lineWidth = 1.2;
    x.beginPath(); x.moveTo(i, 0); x.lineTo(i + 256, 256); x.stroke();
  }
  x.globalAlpha = 0.11;
  const kf = x.createRadialGradient(128, 200, 8, 128, 200, 52);
  kf.addColorStop(0, 'rgba(255,255,255,0.6)'); kf.addColorStop(1, 'rgba(0,0,0,0)');
  x.fillStyle = kf; x.fillRect(0, 0, 256, 512);
  x.globalAlpha = 0.16; x.strokeStyle = '#f0d890'; x.lineWidth = 1; x.setLineDash([4, 3]);
  x.beginPath(); x.moveTo(18, 0); x.lineTo(18, 512); x.stroke();
  x.beginPath(); x.moveTo(238, 0); x.lineTo(238, 512); x.stroke();
  x.setLineDash([]); x.globalAlpha = 1;
  const t = new THREE.CanvasTexture(cv); t.colorSpace = THREE.SRGBColorSpace; return t;
}

function makeShoeTex(hex) {
  if (typeof document === 'undefined') return null;
  const cv = document.createElement('canvas'); cv.width = cv.height = 128;
  const x = cv.getContext('2d');
  x.fillStyle = hex; x.fillRect(0, 0, 128, 128);
  x.globalAlpha = 0.045;
  for (let i = 0; i < 128; i += 2) {
    x.strokeStyle = '#000'; x.lineWidth = 0.5;
    x.beginPath(); x.moveTo(0, i); x.lineTo(128, i); x.stroke();
  }
  x.globalAlpha = 0.10;
  for (let i = 0; i < 4; i++) {
    x.strokeStyle = '#000'; x.lineWidth = 0.7;
    x.beginPath(); x.moveTo(15 + Math.random() * 18, 78 + Math.random() * 18); x.lineTo(55 + Math.random() * 18, 88 + Math.random() * 18); x.stroke();
  }
  x.globalAlpha = 1;
  const t = new THREE.CanvasTexture(cv); t.colorSpace = THREE.SRGBColorSpace; return t;
}

export function makeGripTex() {
  if (typeof document === 'undefined') return null;
  const cv = document.createElement('canvas'); cv.width = cv.height = 256;
  const x = cv.getContext('2d');
  x.fillStyle = '#1a1b1e'; x.fillRect(0, 0, 256, 256);
  for (let i = 0; i < 2400; i++) {
    const v = 36 + Math.random() * 44;
    x.fillStyle = `rgb(${v},${v},${v})`;
    const s = Math.random() * 1.8 + 0.4;
    x.fillRect(Math.random() * 256, Math.random() * 256, s, s);
  }
  const t = new THREE.CanvasTexture(cv); t.colorSpace = THREE.SRGBColorSpace;
  t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(3, 8); return t;
}

/* ─── Geometry helpers ────────────────────────────────────────────────────── */

const _mk = (geo, mat) => { const m = new THREE.Mesh(geo, mat); m.castShadow = true; m.receiveShadow = true; return m; };
const _box = (w, h, d) => new THREE.BoxGeometry(w, h, d);
const _cyl = (rt, rb, h, s = 12) => new THREE.CylinderGeometry(rt, rb, h, s);
const _sph = (r, ws = 14, hs = 10) => new THREE.SphereGeometry(r, ws, hs);

/* ─── AvatarModel ─────────────────────────────────────────────────────────── */

export class AvatarModel {
  constructor(opts = {}) {
    this._opts = {
      skin: '#8a5a3c', hoodie: '#ff7a59', pants: '#3a4150', shoes: '#f4f4f4',
      hat: '#2b2f38', hatStyle: 'beanie', hairColor: '#1a1a1a', eyeColor: '#4a7c3f',
      sockColor: '#f4f1ea', hoodieLabel: null, shoeBrand: null,
      ...opts,
    };
    this.group = new THREE.Group(); this.group.name = 'Avatar';
    this.parts = {};
    this.mats = {};
    this._contactShadow = null;
    this._buildMaterials();
    this._buildBody();
  }

  _buildMaterials() {
    const o = this._opts;
    this.mats = {
      skin: new THREE.MeshPhysicalMaterial({
        color: o.skin, roughness: 0.55, sheen: 0.35,
        sheenColor: new THREE.Color('#ffd9c2'), sheenRoughness: 0.65,
        map: makeSkinTex(o.skin),
      }),
      hoodie: new THREE.MeshPhysicalMaterial({
        color: o.hoodie, roughness: 0.88, sheen: 0.65,
        sheenColor: new THREE.Color('#ffffff'), sheenRoughness: 0.70,
        map: makeHoodieTex(o.hoodie),
      }),
      pants: new THREE.MeshPhysicalMaterial({
        color: o.pants, roughness: 0.82, sheen: 0.45,
        sheenColor: new THREE.Color('#ffffff'), sheenRoughness: 0.75,
        map: makeDenimTex(o.pants),
      }),
      shoes: new THREE.MeshStandardMaterial({ color: o.shoes, roughness: 0.65, map: makeShoeTex(o.shoes) }),
      shoeSole: new THREE.MeshStandardMaterial({ color: '#f0ede8', roughness: 0.92 }),
      hat: new THREE.MeshPhysicalMaterial({ color: o.hat, roughness: 0.90, sheen: 0.5, sheenColor: new THREE.Color('#ffffff') }),
      hair: new THREE.MeshStandardMaterial({ color: o.hairColor, roughness: 0.90 }),
      eye_white: new THREE.MeshStandardMaterial({ color: '#f6f6f6', roughness: 0.28 }),
      iris: new THREE.MeshStandardMaterial({ color: o.eyeColor, roughness: 0.38 }),
      pupil: new THREE.MeshStandardMaterial({ color: '#111111', roughness: 0.08, metalness: 0.1 }),
      brow: new THREE.MeshStandardMaterial({ color: o.hairColor, roughness: 0.90 }),
      sock: new THREE.MeshStandardMaterial({ color: o.sockColor, roughness: 0.85 }),
      metal: new THREE.MeshStandardMaterial({ color: '#aab2bc', metalness: 0.80, roughness: 0.28 }),
      rubber: new THREE.MeshStandardMaterial({ color: '#1a1b1e', roughness: 0.96 }),
      lace: new THREE.MeshStandardMaterial({ color: '#f0f0f0', roughness: 0.85 }),
    };
  }

  _buildBody() {
    const root = this.group;
    // hips is the root pivot for everything — sits at waist height
    const hips = new THREE.Group(); hips.position.y = 0.92; root.add(hips);
    this.parts.hips = hips;

    this.parts.legL = this._buildLeg(1, hips);
    this.parts.legR = this._buildLeg(-1, hips);

    const torso = new THREE.Group(); hips.add(torso);
    this.parts.torso = torso;
    this._buildTorso(torso);

    this.parts.armL = this._buildArm(1, torso);
    this.parts.armR = this._buildArm(-1, torso);

    const head = new THREE.Group(); head.position.y = 0.72; torso.add(head);
    this.parts.head = head;
    this._buildHead(head);

    this._buildContactShadow(root);
  }

  _buildLeg(side, parent) {
    const m = this.mats;
    const leg = new THREE.Group(); leg.position.set(0.1 * side, 0, 0); parent.add(leg);

    // thigh — slight taper, wider at hip
    const thigh = _mk(_cyl(0.077, 0.084, 0.37, 10), m.pants); thigh.position.y = -0.215; leg.add(thigh);
    // inner seam strip
    const seam = _mk(_box(0.007, 0.37, 0.005), m.pants); seam.position.set(-0.04 * side, -0.215, 0.02); leg.add(seam);

    // knee group — pivot for lower leg
    const knee = new THREE.Group(); knee.position.y = -0.46; leg.add(knee);
    leg.userData.knee = knee;

    // knee cap sphere
    knee.add(_mk(_sph(0.072, 8, 7), m.pants));
    // shin — slight taper toward ankle
    const shin = _mk(_cyl(0.068, 0.073, 0.31, 10), m.pants); shin.position.y = -0.185; knee.add(shin);
    // pant cuff rib
    const cuff = _mk(_cyl(0.073, 0.073, 0.038, 10), m.pants); cuff.position.y = -0.35; knee.add(cuff);
    // sock peek above shoe
    const sock = _mk(_cyl(0.072, 0.072, 0.035, 10), m.sock); sock.position.y = -0.385; knee.add(sock);
    // shoe
    this._buildShoe(knee, side);

    return leg;
  }

  _buildShoe(parent, side) {
    const m = this.mats;
    const sg = new THREE.Group(); sg.position.set(0, -0.43, 0.04); parent.add(sg);

    // rubber sole
    const sole = _mk(_box(0.128, 0.022, 0.295), m.shoeSole); sole.position.y = -0.044; sg.add(sole);
    // grip ribs on sole bottom
    for (let zi = -0.1; zi <= 0.1; zi += 0.026) {
      const rib = _mk(_box(0.12, 0.006, 0.009), m.rubber); rib.position.set(0, -0.058, zi); sg.add(rib);
    }
    // canvas upper
    const upper = _mk(_box(0.118, 0.076, 0.268), m.shoes); upper.position.set(0, 0.004, -0.002); sg.add(upper);
    // toe cap
    const toeCap = _mk(_sph(0.058, 10, 8), m.shoes);
    toeCap.scale.set(1.05, 0.68, 0.88); toeCap.position.set(0, 0.002, 0.133); sg.add(toeCap);
    // heel counter
    const heel = _mk(_box(0.116, 0.072, 0.048), m.shoes); heel.position.set(0, 0.004, -0.138); sg.add(heel);
    const heelCap = _mk(_sph(0.044, 8, 6), m.shoes);
    heelCap.scale.set(1.28, 0.78, 0.58); heelCap.position.set(0, 0.028, -0.138); sg.add(heelCap);
    // tongue
    const tongue = _mk(_box(0.072, 0.066, 0.018), m.shoes); tongue.position.set(0, 0.026, 0.124); sg.add(tongue);
    // 3 lace pairs with eyelets
    for (let i = 0; i < 3; i++) {
      const lz = 0.08 - i * 0.042;
      const lace = _mk(_box(0.076, 0.007, 0.005), m.lace); lace.position.set(0, 0.048, lz); sg.add(lace);
      for (const xs of [-1, 1]) {
        const eyelet = _mk(_cyl(0.006, 0.006, 0.008, 6), m.metal);
        eyelet.rotation.z = Math.PI / 2; eyelet.position.set(xs * 0.042, 0.048, lz); sg.add(eyelet);
      }
    }
    // brand stripe on outer side
    const o = this._opts;
    if (o.shoeBrand) {
      const BRAND_COLORS = { vans: '#1a1a1a', nike_sb: '#ff4400', dc: '#2233aa', emerica: '#cc2200', lakai: '#333333', etnies: '#cc0000', nb_num: '#cc0000', cons: '#1a1a1a' };
      const col = BRAND_COLORS[o.shoeBrand] || '#1a1a1a';
      const sm = new THREE.MeshStandardMaterial({ color: col, roughness: 0.55 });
      const stripe = _mk(_box(0.005, 0.038, 0.22), sm);
      stripe.position.set(0.063 * side, 0, 0); sg.add(stripe);
    }
  }

  _buildTorso(torso) {
    const m = this.mats;
    // chest cylinder — flared at shoulders
    const chest = _mk(_cyl(0.175, 0.14, 0.52, 12), m.hoodie); chest.position.y = 0.28; torso.add(chest);
    // shoulder caps
    for (const s of [-1, 1]) {
      const cap = _mk(_sph(0.086, 10, 8), m.hoodie); cap.position.set(0.195 * s, 0.5, 0); torso.add(cap);
    }
    // hem rib
    const hem = _mk(new THREE.TorusGeometry(0.155, 0.016, 6, 18), m.hoodie);
    hem.rotation.x = Math.PI / 2; hem.scale.set(1.06, 0.84, 1); hem.position.y = 0.065; torso.add(hem);
    // center front seam
    const seam = _mk(_box(0.007, 0.48, 0.004), m.hoodie); seam.position.set(0, 0.28, 0.156); torso.add(seam);
    // kangaroo pocket
    const pocket = _mk(_box(0.2, 0.1, 0.007), m.hoodie); pocket.position.set(0, 0.21, 0.159); torso.add(pocket);
    const pockRib = _mk(_box(0.2, 0.007, 0.005), m.hoodie); pockRib.position.set(0, 0.16, 0.161); torso.add(pockRib);
    // drawstrings + metal tips
    for (const s of [-1, 1]) {
      const ds = _mk(_cyl(0.0058, 0.0058, 0.155, 5), m.lace); ds.position.set(0.031 * s, 0.5, 0.142); torso.add(ds);
      const tip = _mk(_cyl(0.009, 0.005, 0.024, 5), m.metal); tip.position.set(0.031 * s, 0.414, 0.146); torso.add(tip);
    }
    // hood folded back
    const hood = _mk(new THREE.TorusGeometry(0.1, 0.044, 8, 14), m.hoodie);
    hood.position.set(0, 0.605, -0.062); hood.rotation.x = 1.1; torso.add(hood);
    const hoodFill = _mk(_sph(0.09, 10, 8), m.hoodie);
    hoodFill.position.set(0, 0.605, -0.082); hoodFill.scale.z = 0.52; torso.add(hoodFill);

    this._addApparelPatch(torso);
  }

  _addApparelPatch(torso) {
    const o = this._opts;
    if (!o.hoodieLabel || typeof document === 'undefined') return;
    const BRANDS = {
      thrasher: { label: 'THRASHER', bg: '#cc1400', fg: '#ffffff' },
      huf: { label: 'HUF', bg: '#1a1a1a', fg: '#ffffff' },
      dgk: { label: 'DGK', bg: '#1a1a1a', fg: '#f5c518' },
      palace: { label: 'PALACE', bg: '#0e0e22', fg: '#ffffff' },
      element: { label: 'ELEMENT', bg: '#1e2e14', fg: '#7dcc4a' },
      antihero: { label: 'ANTI HERO', bg: '#c22014', fg: '#ffffff' },
      spitfire: { label: 'SPITFIRE', bg: '#1a1a1a', fg: '#ff5500' },
      indy: { label: 'INDY', bg: '#1a1a1a', fg: '#cc0000' },
      baker: { label: 'BAKER', bg: '#1a1a1a', fg: '#d4a420' },
      polar: { label: 'POLAR', bg: '#152038', fg: '#e8e8e8' },
    };
    const brand = BRANDS[o.hoodieLabel] || { label: o.hoodieLabel.toUpperCase(), bg: '#1a1a1a', fg: '#ffffff' };
    const cv = document.createElement('canvas'); cv.width = 128; cv.height = 56;
    const x = cv.getContext('2d');
    x.fillStyle = brand.bg; x.beginPath(); if (x.roundRect) x.roundRect(3, 3, 122, 50, 7); else x.rect(3, 3, 122, 50); x.fill();
    const lbl = brand.label;
    x.fillStyle = brand.fg; x.textAlign = 'center'; x.textBaseline = 'middle';
    x.font = `900 ${lbl.length > 8 ? 13 : lbl.length > 5 ? 16 : 20}px system-ui, sans-serif`;
    x.fillText(lbl, 64, 28);
    const pt = new THREE.CanvasTexture(cv); pt.colorSpace = THREE.SRGBColorSpace;
    const patch = _mk(_box(0.135, 0.057, 0.005), new THREE.MeshStandardMaterial({ map: pt, roughness: 0.7, transparent: true }));
    patch.position.set(0, 0.27, 0.166); torso.add(patch);
  }

  _buildHead(head) {
    const m = this.mats;
    // neck
    const neck = _mk(_cyl(0.052, 0.056, 0.1, 10), m.skin); neck.position.y = -0.08; head.add(neck);
    // skull — slightly elongated vertically
    const skull = _mk(_sph(0.128, 18, 14), m.skin);
    skull.scale.set(0.96, 1.06, 1.0); head.add(skull);

    // eyes
    for (const s of [-1, 1]) {
      const eg = new THREE.Group(); eg.position.set(0.048 * s, 0.032, 0.106); head.add(eg);
      const white = _mk(_sph(0.026, 10, 8), m.eye_white); eg.add(white);
      const iris = _mk(_sph(0.018, 8, 7), m.iris); iris.position.z = 0.012; eg.add(iris);
      const pupil = _mk(_sph(0.012, 7, 6), m.pupil); pupil.position.z = 0.021; eg.add(pupil);
      // upper lid
      const lid = _mk(_box(0.052, 0.013, 0.014), m.skin); lid.position.set(0, 0.02, 0.012); eg.add(lid);
    }
    // eyebrows
    for (const s of [-1, 1]) {
      const brow = _mk(_box(0.042, 0.01, 0.009), m.brow);
      brow.position.set(0.048 * s, 0.068, 0.1); brow.rotation.z = -0.14 * s; head.add(brow);
    }
    // nose bridge + tip + nostrils
    const bridge = _mk(_box(0.015, 0.038, 0.005), m.skin); bridge.position.set(0, 0.002, 0.126); head.add(bridge);
    const tip = _mk(_sph(0.018, 8, 6), m.skin); tip.scale.set(1.18, 0.82, 1.0); tip.position.set(0, -0.02, 0.131); head.add(tip);
    for (const s of [-1, 1]) {
      const nostril = _mk(_sph(0.011, 7, 6), m.skin); nostril.position.set(0.018 * s, -0.027, 0.123); head.add(nostril);
    }
    // mouth / lip
    const lip = _mk(_box(0.048, 0.01, 0.005), m.skin); lip.position.set(0, -0.05, 0.121); head.add(lip);
    // ears
    for (const s of [-1, 1]) {
      const ear = _mk(_sph(0.022, 8, 7), m.skin);
      ear.scale.set(0.52, 1.02, 0.55); ear.position.set(0.127 * s, 0.01, 0); head.add(ear);
    }
    // hat + hair
    this._buildHat(head);
    this._buildHair(head);
  }

  _buildHat(head) {
    const m = this.mats;
    const style = this._opts.hatStyle;
    if (style === 'snapback') {
      // structured crown
      const crown = _mk(new THREE.SphereGeometry(0.138, 14, 10, 0, Math.PI * 2, 0, Math.PI * 0.5), m.hat);
      crown.position.y = 0.01; head.add(crown);
      // flat brim — half-cylinder geometry
      const brim = _mk(new THREE.CylinderGeometry(0.255, 0.255, 0.014, 30, 1, false, Math.PI * 0.87, Math.PI * 1.26), m.hat);
      brim.position.set(0, -0.016, 0.065); head.add(brim);
      // adjustable strap at back
      const strap = _mk(_box(0.08, 0.018, 0.006), m.hat); strap.position.set(0, -0.024, -0.138); head.add(strap);
      // strap slider (metal buckle)
      const buckle = _mk(_box(0.025, 0.018, 0.004), m.metal); buckle.position.set(0, -0.024, -0.146); head.add(buckle);
    } else {
      // beanie crown
      const crown = _mk(new THREE.SphereGeometry(0.135, 16, 10, 0, Math.PI * 2, 0, Math.PI * 0.54), m.hat);
      crown.position.y = 0.022; head.add(crown);
      // knit cuff
      const cuff = _mk(_cyl(0.137, 0.136, 0.042, 16), m.hat); cuff.position.y = 0.028; head.add(cuff);
      // rib details on cuff
      for (let i = 0; i < 12; i++) {
        const a = (i / 12) * Math.PI * 2;
        const rib = _mk(_box(0.007, 0.04, 0.005), m.hat);
        rib.position.set(Math.sin(a) * 0.138, 0.028, Math.cos(a) * 0.138);
        rib.rotation.y = a; head.add(rib);
      }
      // pom-pom
      const pom = _mk(_sph(0.028, 8, 7), m.hat); pom.position.y = 0.152; head.add(pom);
      // pom highlight
      const pomH = _mk(_sph(0.014, 7, 6), new THREE.MeshStandardMaterial({ color: '#ffffff', roughness: 0.9 }));
      pomH.position.set(0.008, 0.162, 0.012); head.add(pomH);
    }
  }

  _buildHair(head) {
    const m = this.mats;
    // buzz cut visible at hairline below hat
    const hair = _mk(new THREE.SphereGeometry(0.133, 14, 8, 0, Math.PI * 2, Math.PI * 0.46, Math.PI * 0.14), m.hair);
    hair.position.y = 0.025; head.add(hair);
    // sideburn hints
    for (const s of [-1, 1]) {
      const burn = _mk(_box(0.014, 0.048, 0.009), m.hair); burn.position.set(0.116 * s, -0.038, 0.072); head.add(burn);
    }
  }

  _buildArm(side, torso) {
    const m = this.mats;
    const arm = new THREE.Group(); arm.position.set(0.24 * side, 0.5, 0); torso.add(arm);

    // upper arm
    const upper = _mk(_cyl(0.058, 0.062, 0.24, 10), m.hoodie); upper.position.y = -0.14; arm.add(upper);
    // elbow sphere
    const elbSphere = _mk(_sph(0.058, 9, 7), m.hoodie); elbSphere.position.y = -0.288; arm.add(elbSphere);

    // elbow group — pivot for forearm
    const elbow = new THREE.Group(); elbow.position.y = -0.3; arm.add(elbow);
    arm.userData.elbow = elbow;

    // forearm
    const fore = _mk(_cyl(0.05, 0.055, 0.22, 10), m.hoodie); fore.position.y = -0.13; elbow.add(fore);
    // wrist cuff rib
    const wrist = _mk(_cyl(0.052, 0.052, 0.026, 10), m.hoodie); wrist.position.y = -0.258; elbow.add(wrist);

    // hand
    this._buildHand(elbow, side);

    // board anchor — used by game.js to hold the board in hand
    const handAnchor = new THREE.Object3D(); handAnchor.position.y = -0.31; elbow.add(handAnchor);
    arm.userData.hand = handAnchor;

    arm.rotation.z = 0.1 * side;
    return arm;
  }

  _buildHand(elbow, side) {
    const m = this.mats;
    const hg = new THREE.Group(); hg.position.y = -0.29; elbow.add(hg);

    // palm box
    const palm = _mk(_box(0.066, 0.04, 0.068), m.skin); hg.add(palm);

    // 4 fingers
    const fingers = [
      { x: -0.024, len: 0.063 }, { x: -0.008, len: 0.070 },
      { x: 0.008,  len: 0.068 }, { x: 0.024,  len: 0.060 },
    ];
    for (const { x, len } of fingers) {
      const fg = new THREE.Group(); fg.position.set(x, 0, 0.038); hg.add(fg);
      const knuckle = _mk(_sph(0.012, 6, 5), m.skin); fg.add(knuckle);
      const digit = _mk(_cyl(0.01, 0.011, len * 0.55, 6), m.skin); digit.position.y = len * 0.28; fg.add(digit);
      const ftip = _mk(_sph(0.011, 6, 5), m.skin); ftip.position.y = len * 0.55; fg.add(ftip);
    }
    // thumb
    const thumb = new THREE.Group(); thumb.position.set(-0.041 * side, 0, 0.008); thumb.rotation.z = 0.58 * side; hg.add(thumb);
    const tDigit = _mk(_cyl(0.012, 0.013, 0.044, 6), m.skin); tDigit.position.y = 0.022; thumb.add(tDigit);
    const tTip = _mk(_sph(0.013, 6, 5), m.skin); tTip.position.y = 0.047; thumb.add(tTip);
  }

  _buildContactShadow(parent) {
    if (typeof document === 'undefined') return;
    const cv = document.createElement('canvas'); cv.width = cv.height = 128;
    const x = cv.getContext('2d');
    const g = x.createRadialGradient(64, 64, 0, 64, 64, 58);
    g.addColorStop(0, 'rgba(0,0,0,0.52)'); g.addColorStop(0.58, 'rgba(0,0,0,0.16)'); g.addColorStop(1, 'rgba(0,0,0,0)');
    x.fillStyle = g; x.fillRect(0, 0, 128, 128);
    const tex = new THREE.CanvasTexture(cv);
    const shadow = new THREE.Mesh(
      new THREE.PlaneGeometry(0.9, 1.1),
      new THREE.MeshBasicMaterial({ map: tex, transparent: true, depthWrite: false, side: THREE.DoubleSide })
    );
    shadow.rotation.x = -Math.PI / 2; shadow.position.y = 0.005; shadow.renderOrder = -1;
    this._contactShadow = shadow; parent.add(shadow);
  }

  setColors(colorMap) {
    for (const k in colorMap) {
      if (!this.mats[k]) continue;
      this.mats[k].color.set(colorMap[k]);
      if (k === 'skin' && this.mats.skin.map) { const t = makeSkinTex(colorMap[k]); if (t) { this.mats.skin.map = t; this.mats.skin.needsUpdate = true; } }
      else if (k === 'hoodie' && this.mats.hoodie.map) { const t = makeHoodieTex(colorMap[k]); if (t) { this.mats.hoodie.map = t; this.mats.hoodie.needsUpdate = true; } }
      else if (k === 'pants' && this.mats.pants.map) { const t = makeDenimTex(colorMap[k]); if (t) { this.mats.pants.map = t; this.mats.pants.needsUpdate = true; } }
      else if (k === 'shoes' && this.mats.shoes.map) { const t = makeShoeTex(colorMap[k]); if (t) { this.mats.shoes.map = t; this.mats.shoes.needsUpdate = true; } }
    }
  }

  updateLOD(distSq) {
    if (!this._contactShadow) return;
    const alpha = distSq < 100 ? 0.52 : distSq < 400 ? 0.28 : 0;
    this._contactShadow.material.opacity = alpha;
    this._contactShadow.visible = alpha > 0;
  }
}

/* ─── SkateboardModel ─────────────────────────────────────────────────────── */

export class SkateboardModel {
  constructor(opts = {}) {
    this._opts = {
      deck: '#ff4f6d', grip: '#1a1b1e', wheels: '#f6efe0',
      trucks: '#aab2bc', brand: null,
      ...opts,
    };
    this.group = new THREE.Group(); this.group.name = 'Skateboard';
    this._wheelGroups = [];
    this._truckGroups = [];
    this._deckCanvas = null;
    this._deckMat = null;
    this._deckGfxMat = null;
    this._build();
    // backwards-compat and game.js integration
    this.group.userData.setDeck = (color) => this._setDeck(color);
    this.group.userData.spinWheels = (speed, dt) => this.spinWheels(speed, dt);
    this.group.userData.tiltTrucks = (angle) => this.tiltTrucks(angle);
  }

  _build() {
    const o = this._opts;
    this._deckMat = new THREE.MeshStandardMaterial({ color: o.deck, roughness: 0.55 });
    const woodMat = new THREE.MeshStandardMaterial({ color: '#c8a87a', roughness: 0.72 });
    const gripTex = makeGripTex();
    const gripMat = new THREE.MeshStandardMaterial({ color: o.grip, roughness: 0.98, map: gripTex });
    const truckMat = new THREE.MeshStandardMaterial({ color: o.trucks, metalness: 0.82, roughness: 0.26 });

    // Deck graphic canvas
    let gfxMat = this._deckMat;
    if (typeof document !== 'undefined') {
      this._deckCanvas = document.createElement('canvas');
      this._deckCanvas.width = 128; this._deckCanvas.height = 512;
      this._drawDeckGraphic(o.deck, o.brand);
      const tex = new THREE.CanvasTexture(this._deckCanvas); tex.colorSpace = THREE.SRGBColorSpace;
      this._deckGfxMat = new THREE.MeshStandardMaterial({ map: tex, roughness: 0.48 });
      gfxMat = this._deckGfxMat;
    }

    // Deck body with concave cross-section
    const deckGeo = new THREE.BoxGeometry(0.21, 0.018, 0.58, 4, 1, 1);
    _applyConcave(deckGeo);
    const deck = new THREE.Mesh(deckGeo, [woodMat, woodMat, gripMat, gfxMat, woodMat, woodMat]);
    deck.castShadow = true; deck.receiveShadow = true;
    deck.position.y = 0.095; this.group.add(deck);

    // Grip tape surface layer
    const grip = new THREE.Mesh(new THREE.BoxGeometry(0.205, 0.003, 0.578), gripMat);
    grip.position.set(0, 0.107, 0); this.group.add(grip);

    // Kick panels (nose + tail)
    for (const s of [1, -1]) {
      const kick = new THREE.Mesh(
        new THREE.BoxGeometry(0.21, 0.018, 0.11),
        [woodMat, woodMat, gripMat, gfxMat, woodMat, woodMat]
      );
      kick.castShadow = true;
      kick.position.set(0, 0.114, 0.35 * s); kick.rotation.x = -0.3 * s; this.group.add(kick);
      // rounded end cap
      const cap = new THREE.Mesh(
        new THREE.CylinderGeometry(0.105, 0.105, 0.018, 18, 1, false, 0, Math.PI),
        woodMat
      );
      cap.castShadow = true;
      cap.rotation.y = s > 0 ? -Math.PI / 2 : Math.PI / 2;
      cap.position.set(0, 0.122, 0.415 * s); cap.scale.z = 0.5; this.group.add(cap);
    }

    // 8 mounting screws (4 per truck hole set)
    const screwMat = new THREE.MeshStandardMaterial({ color: '#c8cdd2', metalness: 0.92, roughness: 0.18 });
    for (const [px, pz] of [[-0.07, 0.21], [-0.07, 0.24], [0.07, 0.21], [0.07, 0.24], [-0.07, -0.21], [-0.07, -0.24], [0.07, -0.21], [0.07, -0.24]]) {
      const screw = new THREE.Mesh(new THREE.CylinderGeometry(0.005, 0.005, 0.022, 6), screwMat);
      screw.position.set(px, 0.107, pz); this.group.add(screw);
    }

    // Deck wear decals at nose + tail
    this._addDeckWear();

    // Trucks
    for (const s of [1, -1]) {
      const tg = this._buildTruck(truckMat, o.wheels);
      tg.position.set(0, 0.042, 0.22 * s);
      this.group.add(tg);
      this._truckGroups.push(tg);
    }
  }

  _buildTruck(truckMat, wheelColor) {
    const tg = new THREE.Group();
    // baseplate
    const base = _mk(_box(0.172, 0.013, 0.05), truckMat); tg.add(base);
    // hanger group for tilting
    const hanger = new THREE.Group(); tg.add(hanger);
    // hanger bar
    const bar = _mk(_box(0.192, 0.022, 0.038), truckMat); hanger.add(bar);
    // hanger wing plates
    for (const xs of [-1, 1]) {
      const wing = _mk(_box(0.016, 0.028, 0.034), truckMat); wing.position.set(0.077 * xs, 0.014, 0); hanger.add(wing);
    }
    // kingpin
    const kp = _mk(_cyl(0.005, 0.005, 0.038, 6), new THREE.MeshStandardMaterial({ color: '#8090a0', metalness: 0.72, roughness: 0.38 }));
    kp.position.y = -0.009; tg.add(kp);
    // bushings — polyurethane red rings
    const bushMat = new THREE.MeshStandardMaterial({ color: '#ee3300', roughness: 0.78 });
    for (const ys of [0.009, -0.009]) {
      const bush = _mk(new THREE.TorusGeometry(0.016, 0.006, 6, 10), bushMat);
      bush.rotation.x = Math.PI / 2; bush.position.set(0, ys, 0); tg.add(bush);
    }
    // axle shaft
    const axle = _mk(_cyl(0.006, 0.006, 0.224, 8), new THREE.MeshStandardMaterial({ color: '#c8cdd2', metalness: 0.88, roughness: 0.18 }));
    axle.rotation.z = Math.PI / 2; hanger.add(axle);
    // wheels
    for (const xs of [-1, 1]) {
      const wg = this._buildWheel(wheelColor);
      wg.position.set(0.102 * xs, 0, 0);
      hanger.add(wg);
      this._wheelGroups.push(wg);
    }
    return tg;
  }

  _buildWheel(color) {
    const wg = new THREE.Group();
    const ureMat = new THREE.MeshStandardMaterial({ color, roughness: 0.62 });
    const wheel = _mk(new THREE.CylinderGeometry(0.028, 0.028, 0.028, 18), ureMat);
    wheel.rotation.z = Math.PI / 2; wg.add(wheel);
    // side label circle
    const labelMat = new THREE.MeshStandardMaterial({ color: '#e8e0d0', roughness: 0.48 });
    const label = _mk(new THREE.CircleGeometry(0.018, 14), labelMat);
    label.rotation.y = Math.PI / 2; label.position.x = 0.015; wg.add(label);
    // bearing shell torus
    const hubMat = new THREE.MeshStandardMaterial({ color: '#888f98', metalness: 0.78, roughness: 0.28 });
    const hub = _mk(new THREE.TorusGeometry(0.014, 0.007, 6, 14), hubMat);
    hub.rotation.y = Math.PI / 2; wg.add(hub);
    // center axle nub
    const bearMat = new THREE.MeshStandardMaterial({ color: '#c8cdd2', metalness: 0.90, roughness: 0.18 });
    const bear = _mk(_cyl(0.006, 0.006, 0.03, 8), bearMat);
    bear.rotation.z = Math.PI / 2; wg.add(bear);
    return wg;
  }

  _addDeckWear() {
    if (typeof document === 'undefined') return;
    const cv = document.createElement('canvas'); cv.width = cv.height = 64;
    const x = cv.getContext('2d');
    x.clearRect(0, 0, 64, 64); x.globalAlpha = 0.2;
    for (let i = 0; i < 9; i++) {
      x.strokeStyle = 'rgba(70,50,30,1)'; x.lineWidth = 0.7;
      x.beginPath(); x.moveTo(10 + Math.random() * 44, Math.random() * 64); x.lineTo(12 + Math.random() * 42, Math.random() * 64); x.stroke();
    }
    const tex = new THREE.CanvasTexture(cv);
    const wearMat = new THREE.MeshBasicMaterial({ map: tex, transparent: true, depthWrite: false });
    for (const s of [1, -1]) {
      const w = new THREE.Mesh(new THREE.PlaneGeometry(0.2, 0.12), wearMat);
      w.rotation.x = -Math.PI / 2; w.position.set(0, 0.11, 0.42 * s); this.group.add(w);
    }
  }

  _drawDeckGraphic(color, brandId) {
    if (!this._deckCanvas) return;
    const cv = this._deckCanvas, x = cv.getContext('2d');
    const cw = cv.width, ch = cv.height;
    if (brandId) {
      const BRANDS = {
        anti_hero: { bg: '#e63522', fg: '#ffffff', label: 'Anti Hero' }, baker: { bg: '#1a1a1a', fg: '#d4a420', label: 'Baker' },
        birdhouse: { bg: '#f0ede6', fg: '#222222', label: 'Birdhouse' }, creature: { bg: '#180808', fg: '#cc2200', label: 'Creature' },
        dgk: { bg: '#1a1a1a', fg: '#f5c518', label: 'DGK' }, element: { bg: '#1e2e14', fg: '#7dcc4a', label: 'Element' },
        girl: { bg: '#f5f5f0', fg: '#333333', label: 'Girl' }, palace: { bg: '#0e0e22', fg: '#ffffff', label: 'Palace' },
        plan_b: { bg: '#1a1a1a', fg: '#e8e8e8', label: 'Plan B' }, polar: { bg: '#152038', fg: '#e8e8e8', label: 'Polar' },
        powell: { bg: '#c8a800', fg: '#1a1a1a', label: 'Powell Peralta' }, real: { bg: '#1a1a1a', fg: '#f0f0f0', label: 'Real' },
        santa_cruz: { bg: '#c22014', fg: '#ffffff', label: 'Santa Cruz' }, toy_machine: { bg: '#ff5500', fg: '#ffffff', label: 'Toy Machine' },
        zero: { bg: '#0a0a0a', fg: '#e0e0e0', label: 'Zero' }, spitfire: { bg: '#1a1a1a', fg: '#ff5500', label: 'Spitfire' },
      };
      const b = BRANDS[brandId];
      if (b) {
        x.fillStyle = b.bg; x.fillRect(0, 0, cw, ch);
        x.globalAlpha = 0.035;
        for (let i = 0; i < 60; i++) { x.fillStyle = Math.random() > 0.5 ? '#fff' : '#000'; x.fillRect(Math.random() * cw, Math.random() * ch, 2, 2); }
        x.globalAlpha = 1;
        x.fillStyle = b.fg; x.globalAlpha = 0.11;
        x.fillRect(0, 0, cw, 50); x.fillRect(0, ch - 50, cw, 50);
        x.globalAlpha = 1; x.textAlign = 'center'; x.textBaseline = 'middle';
        const cy = ch / 2, parts = b.label.split(' ');
        if (parts.length === 1) {
          const fs = Math.round(cw / Math.max(b.label.length * 0.58, 1.2));
          x.fillStyle = b.fg; x.shadowColor = b.fg; x.shadowBlur = 10;
          x.font = `900 ${fs}px system-ui, sans-serif`; x.fillText(b.label.toUpperCase(), cw / 2, cy);
        } else {
          const fs0 = Math.round(cw / Math.max(parts[0].length * 0.55, 1.2));
          const fs1 = Math.round(cw / Math.max(parts[1].length * 0.55, 1.2));
          x.fillStyle = b.fg; x.shadowColor = b.fg; x.shadowBlur = 8;
          x.font = `900 ${fs0}px system-ui, sans-serif`; x.fillText(parts[0].toUpperCase(), cw / 2, cy - 22);
          x.font = `900 ${fs1}px system-ui, sans-serif`; x.fillText(parts[1].toUpperCase(), cw / 2, cy + 22);
        }
        x.shadowBlur = 0;
        x.strokeStyle = b.fg; x.lineWidth = 1.5; x.globalAlpha = 0.3;
        const lo = parts.length > 1 ? 52 : 38;
        x.beginPath(); x.moveTo(12, cy - lo); x.lineTo(cw - 12, cy - lo); x.stroke();
        x.beginPath(); x.moveTo(12, cy + lo); x.lineTo(cw - 12, cy + lo); x.stroke();
        x.globalAlpha = 1; return;
      }
    }
    // Original SC design
    x.fillStyle = color; x.fillRect(0, 0, cw, ch);
    x.fillStyle = 'rgba(255,255,255,0.9)';
    for (let i = 0; i < 5; i++) x.fillRect(0, 150 + i * 22, cw, 9);
    x.fillStyle = 'rgba(0,0,0,0.25)'; x.beginPath(); x.arc(cw / 2, 360, 34, 0, Math.PI * 2); x.fill();
    x.save(); x.translate(cw / 2, 360); x.rotate(-Math.PI / 2);
    x.fillStyle = '#fff'; x.font = '900 34px system-ui, sans-serif';
    x.textAlign = 'center'; x.textBaseline = 'middle'; x.fillText('SC', 0, 2); x.restore();
  }

  _setDeck(color) {
    this._deckMat.color.set(color);
    if (this._deckGfxMat && this._deckCanvas) {
      this._drawDeckGraphic(color, this._opts.brand);
      if (this._deckGfxMat.map) this._deckGfxMat.map.needsUpdate = true;
    }
  }

  spinWheels(speed, dt) {
    const rot = speed * dt * 3.6;
    for (const wg of this._wheelGroups) wg.rotation.x += rot;
  }

  tiltTrucks(angle) {
    for (const tg of this._truckGroups) tg.rotation.z = angle * 0.1;
  }
}

/* ─── Deck concave helper ─────────────────────────────────────────────────── */

function _applyConcave(geo) {
  const pos = geo.attributes.position;
  for (let i = 0; i < pos.count; i++) {
    if (pos.getY(i) > 0) {
      const xn = Math.abs(pos.getX(i)) / 0.105;
      pos.setY(i, pos.getY(i) + xn * xn * 0.005);
    }
  }
  pos.needsUpdate = true; geo.computeVertexNormals();
}

/* ─── AnimationController ─────────────────────────────────────────────────── */

export class AnimationController {
  constructor(avatar) {
    this._avatar = avatar;
    this._breathPhase = 0;
  }

  updateSecondary(speed, dt) {
    this._breathPhase += dt * 0.75;
    if (this._avatar && this._avatar.parts.torso) {
      this._avatar.parts.torso.scale.y = 1 + Math.sin(this._breathPhase) * 0.004;
    }
  }

  applyTrickMotion(/* board, def, progress */) {}
}

/* ─── TrickController ─────────────────────────────────────────────────────── */

export class TrickController {
  static TRICK_POSES = {
    ollie:    { legL: { thigh: -0.55, knee: 1.20, z: 0.08 }, legR: { thigh: -0.35, knee: 0.90, z: -0.12 } },
    kickflip: { legL: { thigh: -0.60, knee: 1.40, z: 0.16 }, legR: { thigh: -0.40, knee: 0.78, z: -0.10 } },
    grind50:  { legL: { thigh: -0.40, knee: 0.70, z: 0.05 }, legR: { thigh: -0.40, knee: 0.70, z: -0.05 } },
  };

  static apply(name, parts, t) {
    const p = TrickController.TRICK_POSES[name]; if (!p || !parts) return;
    const e = Math.sin(t * Math.PI), _l = (a, b, f) => a + (b - a) * f;
    parts.legL.rotation.x = _l(parts.legL.rotation.x, p.legL.thigh, e * 0.7);
    if (parts.legL.userData.knee) parts.legL.userData.knee.rotation.x = _l(parts.legL.userData.knee.rotation.x, p.legL.knee, e * 0.8);
    parts.legR.rotation.x = _l(parts.legR.rotation.x, p.legR.thigh, e * 0.7);
    if (parts.legR.userData.knee) parts.legR.userData.knee.rotation.x = _l(parts.legR.userData.knee.rotation.x, p.legR.knee, e * 0.8);
  }
}

/* ─── SkateController ─────────────────────────────────────────────────────── */

export class SkateController {
  constructor(avatar, board) {
    this._avatar = avatar;
    this._board = board;
  }

  sync(playerState, dt) {
    const { speed = 0, grounded = true, lean = 0 } = playerState;
    if (this._board) {
      this._board.userData.spinWheels?.(grounded ? speed : Math.min(speed, 3), dt);
      this._board.userData.tiltTrucks?.(lean);
    }
    if (this._avatar && this._avatar.parts.torso) {
      const tgt = 0.1 + Math.min(speed / 18, 1) * 0.08;
      this._avatar.parts.torso.rotation.x += (tgt - this._avatar.parts.torso.rotation.x) * (1 - Math.exp(-5 * dt));
    }
  }
}

/* ─── CharacterLODManager ─────────────────────────────────────────────────── */

export class CharacterLODManager {
  constructor(avatarModel, camera) {
    this._model = avatarModel;
    this._camera = camera;
    this._v = new THREE.Vector3();
  }

  update() {
    if (!this._model || !this._camera) return;
    this._model.group.getWorldPosition(this._v);
    const distSq = this._v.distanceToSquared(this._camera.position);
    this._model.updateLOD(distSq);
  }
}

/* ─── Backwards-compat factory functions ─────────────────────────────────── */

export function makeAvatarModel(opts = {}) {
  const model = new AvatarModel(opts);
  return {
    group: model.group,
    parts: model.parts,
    mats: model.mats,
    setColors: (map) => model.setColors(map),
    _model: model,
  };
}

export function makeSkateboardModel(opts = {}) {
  const model = new SkateboardModel(opts);
  return model.group;
}
