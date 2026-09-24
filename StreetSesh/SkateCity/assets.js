// SkateCity — procedural low-poly asset library (original designs).
// Convention: every model faces +Z, origin sits on the ground (y = 0).
// Used by the game at runtime and by export-glb.mjs to write .glb files.
import * as THREE from 'three';

export const PALETTE = {
  land: '#e6e1d6', park: '#9fcb83', parkDark: '#8dbd72', water: '#4f9fd1',
  road: '#9ea4ad', roadLine: '#f4f4f0', sidewalk: '#d9d3ca', curb: '#bdb8b0',
  building: ['#ece8e1', '#e2dbd0', '#d9c3a0', '#c98f76', '#b9c4cf', '#e8e3da', '#d4cfc6', '#bfa58a', '#a9b3ad', '#efe9df'],
  roof: '#d5d0c8', glass: '#9fb6c9', concrete: '#c9c6c0', metal: '#8f98a3',
  zipp: '#17b3a3', zippAccent: '#ff7a59', hailr: '#1d2433', hailrSign: '#ffd166',
};

const matCache = new Map();
export function mat(color, opts = {}) {
  const key = color + JSON.stringify(opts);
  if (!matCache.has(key)) {
    const { physical, ...rest } = opts;
    const m = physical ? new THREE.MeshPhysicalMaterial({ color, roughness: 0.85, metalness: 0, ...rest })
      : new THREE.MeshStandardMaterial({ color, roughness: 0.85, metalness: 0, ...rest });
    if (rest.emissive) m.userData.baseEI = rest.emissiveIntensity ?? 1;
    matCache.set(key, m);
  }
  return matCache.get(key);
}
// brighten every emissive (headlights, lamps, pins) as night falls
export function setNight(n) { for (const m of matCache.values()) if (m.userData.baseEI != null) m.emissiveIntensity = m.userData.baseEI * (1 + n * 3.5); }
const paint = (color) => mat(color, { physical: true, clearcoat: 1, clearcoatRoughness: 0.05, metalness: 0.45, roughness: 0.32 });
const GLASS = () => mat('#1c2530', { roughness: 0.04, metalness: 0.9 });
const CHROME = () => mat('#d4d8de', { metalness: 1, roughness: 0.22 });
const fabric = (color) => new THREE.MeshPhysicalMaterial({ color, roughness: 0.92, sheen: 0.6, sheenRoughness: 0.6, sheenColor: new THREE.Color('#ffffff') });

function mesh(geo, color, opts) {
  const m = new THREE.Mesh(geo, typeof color === 'string' ? mat(color, opts) : color);
  m.castShadow = true; m.receiveShadow = true;
  return m;
}
function box(w, h, d, color, x = 0, y = 0, z = 0, opts) {
  const m = mesh(new THREE.BoxGeometry(w, h, d), color, opts); m.position.set(x, y, z); return m;
}
function cyl(rt, rb, h, color, seg = 12, opts) { return mesh(new THREE.CylinderGeometry(rt, rb, h, seg), color, opts); }
function sphere(r, color, ws = 14, hs = 10, opts) { return mesh(new THREE.SphereGeometry(r, ws, hs), color, opts); }
function capsule(r, len, color) { return mesh(new THREE.CapsuleGeometry(r, len, 4, 10), color); }

// tube between two points (for bike frames, rails)
function tube(a, b, r, color, seg = 8) {
  const A = new THREE.Vector3(...a), B = new THREE.Vector3(...b);
  const len = A.distanceTo(B);
  const m = cyl(r, r, len, color, seg);
  m.position.copy(A).add(B).multiplyScalar(0.5);
  m.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), B.clone().sub(A).normalize());
  return m;
}

function wheel(r, w, tire = '#1e2024', hub = null) {
  const g = new THREE.Group();
  const t = mesh(new THREE.CylinderGeometry(r, r, w, 24), mat(tire, { roughness: 0.95 })); t.rotation.z = Math.PI / 2; g.add(t);
  const side = mesh(new THREE.TorusGeometry(r * 0.82, r * 0.16, 8, 24), mat('#16181b', { roughness: 0.9 })); side.rotation.y = Math.PI / 2; side.scale.z = 0.6; g.add(side);
  const h = mesh(new THREE.CylinderGeometry(r * 0.55, r * 0.55, w * 1.04, 14), hub ? mat(hub, { roughness: 0.5 }) : CHROME()); h.rotation.z = Math.PI / 2; g.add(h);
  return g;
}

/* ---------------- Avatar ---------------- */
export const SKIN_TONES = ['#f3d2b3', '#dcae86', '#b98059', '#8a5a3c', '#5e3b26'];
export const HOODIES = ['#ff7a59', '#17b3a3', '#5b6cff', '#f2c14e', '#2b2f38', '#e8e6e1'];
export const DECKS = ['#ff4f6d', '#2fb8ff', '#ffd23f', '#8b5cf6', '#1e1e1e', '#3ddc84'];

/* ========== BRAND SYSTEM ========== */

// Skate deck brands — selectable in board builder
export const DECK_BRANDS = [
  { id: 'anti_hero',   label: 'Anti Hero',     bg: '#e63522', fg: '#ffffff' },
  { id: 'baker',       label: 'Baker',          bg: '#1a1a1a', fg: '#d4a420' },
  { id: 'birdhouse',   label: 'Birdhouse',      bg: '#f0ede6', fg: '#222222' },
  { id: 'creature',    label: 'Creature',       bg: '#180808', fg: '#cc2200' },
  { id: 'dgk',         label: 'DGK',            bg: '#1a1a1a', fg: '#f5c518' },
  { id: 'element',     label: 'Element',        bg: '#1e2e14', fg: '#7dcc4a' },
  { id: 'girl',        label: 'Girl',           bg: '#f5f5f0', fg: '#333333' },
  { id: 'palace',      label: 'Palace',         bg: '#0e0e22', fg: '#ffffff' },
  { id: 'plan_b',      label: 'Plan B',         bg: '#1a1a1a', fg: '#e8e8e8' },
  { id: 'polar',       label: 'Polar',          bg: '#152038', fg: '#e8e8e8' },
  { id: 'powell',      label: 'Powell Peralta', bg: '#c8a800', fg: '#1a1a1a' },
  { id: 'real',        label: 'Real',           bg: '#1a1a1a', fg: '#f0f0f0' },
  { id: 'santa_cruz',  label: 'Santa Cruz',     bg: '#c22014', fg: '#ffffff' },
  { id: 'toy_machine', label: 'Toy Machine',    bg: '#ff5500', fg: '#ffffff' },
  { id: 'zero',        label: 'Zero',           bg: '#0a0a0a', fg: '#e0e0e0' },
  { id: 'spitfire',    label: 'Spitfire',       bg: '#1a1a1a', fg: '#ff5500' },
];

// Hoodie / apparel brands — shown as chest patch on avatar
export const APPAREL_BRANDS = [
  { id: 'thrasher', label: 'Thrasher',     bg: '#cc1400', fg: '#ffffff' },
  { id: 'huf',      label: 'HUF',          bg: '#1a1a1a', fg: '#ffffff' },
  { id: 'dgk',      label: 'DGK',          bg: '#1a1a1a', fg: '#f5c518' },
  { id: 'palace',   label: 'Palace',       bg: '#0e0e22', fg: '#ffffff' },
  { id: 'element',  label: 'Element',      bg: '#1e2e14', fg: '#7dcc4a' },
  { id: 'antihero', label: 'Anti Hero',    bg: '#c22014', fg: '#ffffff' },
  { id: 'spitfire', label: 'Spitfire',     bg: '#1a1a1a', fg: '#ff5500' },
  { id: 'indy',     label: 'Independent',  bg: '#1a1a1a', fg: '#cc0000' },
  { id: 'baker',    label: 'Baker',        bg: '#1a1a1a', fg: '#d4a420' },
  { id: 'polar',    label: 'Polar',        bg: '#152038', fg: '#e8e8e8' },
];

// Shoe brands — appear as side stripe accent on avatar shoes
export const SHOE_BRANDS = [
  { id: 'vans',    label: 'Vans',          accent: '#1a1a1a' },
  { id: 'nike_sb', label: 'Nike SB',       accent: '#ff4400' },
  { id: 'dc',      label: 'DC',            accent: '#2233aa' },
  { id: 'emerica', label: 'Emerica',       accent: '#cc2200' },
  { id: 'lakai',   label: 'Lakai',         accent: '#333333' },
  { id: 'etnies',  label: 'Etnies',        accent: '#cc0000' },
  { id: 'nb_num',  label: 'NB Numeric',    accent: '#cc0000' },
  { id: 'cons',    label: 'CONS',          accent: '#1a1a1a' },
];

// Paints brand-specific deck graphic onto an existing 2D canvas context.
function paintDeckBrand(ctx, brand) {
  const { bg, fg, label } = brand;
  const cw = 128, ch = 512;
  ctx.fillStyle = bg; ctx.fillRect(0, 0, cw, ch);
  ctx.globalAlpha = 0.035;
  for (let i = 0; i < 60; i++) {
    ctx.fillStyle = Math.random() > 0.5 ? '#ffffff' : '#000000';
    ctx.fillRect(Math.random() * cw, Math.random() * ch, 2, 2);
  }
  ctx.globalAlpha = 1;
  ctx.fillStyle = fg; ctx.globalAlpha = 0.11;
  ctx.fillRect(0, 0, cw, 50); ctx.fillRect(0, ch - 50, cw, 50);
  ctx.globalAlpha = 1;
  ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
  const cy = ch / 2, parts = label.split(' ');
  if (parts.length === 1) {
    const fs = Math.round(cw / Math.max(label.length * 0.58, 1.2));
    ctx.fillStyle = fg; ctx.shadowColor = fg; ctx.shadowBlur = 10;
    ctx.font = `900 ${fs}px system-ui, sans-serif`;
    ctx.fillText(label.toUpperCase(), cw / 2, cy);
    ctx.shadowBlur = 0;
  } else {
    const fs0 = Math.round(cw / Math.max(parts[0].length * 0.55, 1.2));
    const fs1 = Math.round(cw / Math.max(parts[1].length * 0.55, 1.2));
    ctx.fillStyle = fg; ctx.shadowColor = fg; ctx.shadowBlur = 8;
    ctx.font = `900 ${fs0}px system-ui, sans-serif`; ctx.fillText(parts[0].toUpperCase(), cw / 2, cy - 22);
    ctx.font = `900 ${fs1}px system-ui, sans-serif`; ctx.fillText(parts[1].toUpperCase(), cw / 2, cy + 22);
    ctx.shadowBlur = 0;
  }
  ctx.strokeStyle = fg; ctx.lineWidth = 1.5; ctx.globalAlpha = 0.3;
  const lineOff = parts.length > 1 ? 52 : 38;
  ctx.beginPath(); ctx.moveTo(12, cy - lineOff); ctx.lineTo(cw - 12, cy - lineOff); ctx.stroke();
  ctx.beginPath(); ctx.moveTo(12, cy + lineOff); ctx.lineTo(cw - 12, cy + lineOff); ctx.stroke();
  ctx.globalAlpha = 1;
}

// Color palette for graffiti tags — one recognizable color per brand
const GRAFF_COLORS = {
  THRASHER: '#e01206', 'ANTI HERO': '#ff5500', SPITFIRE: '#ff4400',
  DGK: '#f5c518', BAKER: '#d4a420', HUF: '#eeeeee',
  PALACE: '#9090ff', GIRL: '#ff66aa', REAL: '#c8c8c8',
  POLAR: '#88aaff', ZERO: '#d0d0d0', CREATURE: '#cc2200',
  'TOY MACHINE': '#ff6600', POWELL: '#c8a800', ELEMENT: '#7dcc4a',
  'SANTA CRUZ': '#e01206', BIRDHOUSE: '#aaaaaa', 'PLAN B': '#d8d8d8',
  INDEPENDENT: '#cc0000', EMERICA: '#eeeeee', 'NB NUMERIC': '#cc0000',
  VANS: '#dddddd', 'NIKE SB': '#ff4400', 'DC SHOES': '#2233aa',
  LAKAI: '#888888', ETNIES: '#cc2200', THUNDER: '#3388ff',
};

/**
 * Creates a graffiti wall panel mesh with canvas-drawn brand logos.
 * @param {string[]|{label,color}[]} brands  Brand names or {label,color} objects
 * @param {number} panelW  Width in world units
 * @param {number} panelH  Height in world units
 */
export function makeGraffitiWall(brands = [], panelW = 9, panelH = 5) {
  if (typeof document === 'undefined') return new THREE.Group();
  const cv = document.createElement('canvas'); cv.width = 512; cv.height = 256;
  const x = cv.getContext('2d');
  // concrete base with subtle texture
  x.fillStyle = '#ccc8c0'; x.fillRect(0, 0, 512, 256);
  x.globalAlpha = 0.05;
  for (let i = 0; i < 500; i++) {
    const v = 150 + Math.random() * 60;
    x.fillStyle = `rgb(${v},${v - 3},${v - 8})`;
    x.fillRect(Math.random() * 512, Math.random() * 256, Math.random() * 4 + 1, Math.random() * 3 + 1);
  }
  x.globalAlpha = 1;
  // deterministic per-wall seeded random
  let _s = 91;
  const sr = () => { _s = (_s * 16807) % 2147483647; return (_s - 1) / 2147483646; };
  const tags = brands.length ? brands : Object.keys(GRAFF_COLORS).slice(0, 8);
  const display = tags.slice(0, 8);
  const cols = 4, cellW = 512 / cols, cellH = 256 / 2;
  display.forEach((b, idx) => {
    const label = typeof b === 'string' ? b : b.label;
    const color = (typeof b === 'object' && b.color) ? b.color : (GRAFF_COLORS[label.toUpperCase()] || '#ffffff');
    const col = idx % cols, row = Math.floor(idx / cols);
    const cx = col * cellW + cellW * (0.18 + sr() * 0.64);
    const cy = row * cellH + cellH * (0.22 + sr() * 0.56);
    const fs = Math.round(26 + sr() * 22);
    const rot = (sr() - 0.5) * 0.28;
    x.save();
    x.translate(Math.min(cx, 492), Math.min(cy, 238)); x.rotate(rot);
    x.shadowColor = color; x.shadowBlur = 12;
    x.font = `900 ${fs}px system-ui, sans-serif`;
    x.textAlign = 'center'; x.textBaseline = 'middle';
    x.strokeStyle = 'rgba(255,255,255,0.78)'; x.lineWidth = fs * 0.22; x.lineJoin = 'round';
    x.strokeText(label.toUpperCase(), 0, 0);
    x.fillStyle = color; x.fillText(label.toUpperCase(), 0, 0);
    if (sr() > 0.48) {
      x.shadowBlur = 0; x.fillStyle = color; x.globalAlpha = 0.65;
      x.beginPath(); x.ellipse((sr() - 0.5) * fs * 0.5, fs * 0.65, 2.2, sr() * 12 + 5, 0, 0, Math.PI * 2); x.fill();
      x.globalAlpha = 1;
    }
    x.restore();
  });
  x.globalAlpha = 0.32; x.font = 'italic 700 14px system-ui, sans-serif';
  x.textAlign = 'right'; x.textBaseline = 'bottom'; x.fillStyle = '#666';
  x.fillText('StreetSesh', 508, 252); x.globalAlpha = 1;
  const tex = new THREE.CanvasTexture(cv); tex.colorSpace = THREE.SRGBColorSpace;
  const panel = new THREE.Mesh(
    new THREE.BoxGeometry(panelW, panelH, 0.06),
    new THREE.MeshStandardMaterial({ map: tex, roughness: 0.92, metalness: 0 })
  );
  panel.castShadow = false; panel.receiveShadow = true; panel.position.y = panelH / 2;
  const g = new THREE.Group(); g.add(panel); return g;
}

export function makeAvatar(o = {}) {
  const c = { skin: SKIN_TONES[3], hoodie: HOODIES[0], pants: '#3a4150', shoes: '#f4f4f4', hat: '#2b2f38', hoodieLabel: null, shoeBrand: null, ...o };
  const mats = {
    skin: new THREE.MeshPhysicalMaterial({ color: c.skin, roughness: 0.55, sheen: 0.25, sheenColor: new THREE.Color('#ffd9c2') }),
    hoodie: fabric(c.hoodie), pants: fabric(c.pants), hat: fabric(c.hat),
    shoes: new THREE.MeshStandardMaterial({ color: c.shoes, roughness: 0.6 }),
  };
  const root = new THREE.Group(); root.name = 'Avatar';
  const hips = new THREE.Group(); hips.position.y = 0.92; root.add(hips);

  const mkLeg = (side) => {
    const leg = new THREE.Group(); leg.position.set(0.1 * side, 0, 0);
    const thigh = capsule(0.078, 0.34, mats.pants); thigh.position.y = -0.22; leg.add(thigh);
    const knee = new THREE.Group(); knee.position.y = -0.44; leg.add(knee);
    const shin = capsule(0.07, 0.3, mats.pants); shin.position.y = -0.2; knee.add(shin);
    const shoe = mesh(new THREE.CapsuleGeometry(0.055, 0.17, 4, 10), mats.shoes); shoe.rotation.x = Math.PI / 2; shoe.scale.set(1.1, 1, 0.8); shoe.position.set(0, -0.42, 0.05); knee.add(shoe);
    const sole = box(0.12, 0.03, 0.29, '#f2efe8', 0, -0.465, 0.05, { roughness: 0.8 }); knee.add(sole);
    const cuff = mesh(new THREE.CylinderGeometry(0.078, 0.078, 0.05, 12), mats.pants); cuff.position.y = -0.34; knee.add(cuff);
    leg.userData.knee = knee;
    hips.add(leg); return leg;
  };
  const legL = mkLeg(1), legR = mkLeg(-1);

  const torso = new THREE.Group(); hips.add(torso);
  const chest = mesh(new THREE.CapsuleGeometry(0.17, 0.26, 4, 12), mats.hoodie);
  chest.scale.set(1.12, 1, 0.72); chest.position.y = 0.3; torso.add(chest);
  const pocket = box(0.2, 0.08, 0.02, mats.hoodie, 0, 0.18, 0.13); torso.add(pocket);
  for (const s of [-1, 1]) { const str = cyl(0.007, 0.007, 0.14, '#f4f1ea', 5); str.position.set(0.035 * s, 0.47, 0.13); torso.add(str); }
  const hem = mesh(new THREE.TorusGeometry(0.18, 0.025, 6, 18), mats.hoodie); hem.rotation.x = Math.PI / 2; hem.scale.set(1.1, 0.72, 1); hem.position.y = 0.06; torso.add(hem);
  const hood = mesh(new THREE.TorusGeometry(0.09, 0.045, 8, 14), mats.hoodie); hood.position.set(0, 0.58, -0.07); hood.rotation.x = 1.1; torso.add(hood);

  const head = new THREE.Group(); head.position.y = 0.72; torso.add(head);
  const neck = cyl(0.05, 0.055, 0.1, mats.skin); neck.position.y = -0.1; head.add(neck);
  const skull = mesh(new THREE.SphereGeometry(0.125, 16, 12), mats.skin); skull.scale.set(0.95, 1.08, 1); head.add(skull);
  const beanie = mesh(new THREE.SphereGeometry(0.132, 16, 8, 0, Math.PI * 2, 0, Math.PI / 2), mats.hat); beanie.position.y = 0.02; head.add(beanie);
  const cuff = mesh(new THREE.CylinderGeometry(0.134, 0.134, 0.045, 16), mats.hat); cuff.position.y = 0.03; head.add(cuff);
  for (const s of [-1, 1]) { const e = box(0.022, 0.03, 0.01, '#1b1b1f', 0.045 * s, -0.005, 0.118); head.add(e); }

  const mkArm = (side) => {
    const arm = new THREE.Group(); arm.position.set(0.23 * side, 0.5, 0);
    const up = capsule(0.058, 0.22, mats.hoodie); up.position.y = -0.15; arm.add(up);
    const elbow = new THREE.Group(); elbow.position.y = -0.3; arm.add(elbow);
    const fore = capsule(0.052, 0.2, mats.hoodie); fore.position.y = -0.13; elbow.add(fore);
    const hand = sphere(0.05, mats.skin, 10, 8); hand.position.y = -0.28; elbow.add(hand);
    const anchor = new THREE.Object3D(); anchor.position.y = -0.3; elbow.add(anchor);
    arm.userData.elbow = elbow; arm.userData.hand = anchor;
    arm.rotation.z = 0.12 * side;
    torso.add(arm); return arm;
  };
  const armL = mkArm(1), armR = mkArm(-1);

  // Hoodie brand patch — small chest label showing the apparel brand
  if (c.hoodieLabel) {
    const brand = APPAREL_BRANDS.find(b => b.id === c.hoodieLabel);
    const pc = typeof document !== 'undefined' ? document.createElement('canvas') : null;
    if (pc) {
      pc.width = 128; pc.height = 56;
      const px = pc.getContext('2d');
      const bg = brand ? brand.bg : '#1a1a1a';
      const fg = brand ? brand.fg : '#ffffff';
      const lbl = (brand ? brand.label : c.hoodieLabel).toUpperCase();
      px.fillStyle = bg; px.beginPath(); px.roundRect(3, 3, 122, 50, 7); px.fill();
      px.fillStyle = fg;
      px.font = `900 ${lbl.length > 8 ? 14 : lbl.length > 5 ? 17 : 21}px system-ui, sans-serif`;
      px.textAlign = 'center'; px.textBaseline = 'middle';
      px.fillText(lbl, 64, 28);
      const pt = new THREE.CanvasTexture(pc); pt.colorSpace = THREE.SRGBColorSpace;
      const patch = new THREE.Mesh(
        new THREE.BoxGeometry(0.135, 0.057, 0.006),
        new THREE.MeshStandardMaterial({ map: pt, roughness: 0.7, transparent: true })
      );
      patch.position.set(0, 0.22, 0.148);
      torso.add(patch);
    }
  }

  // Shoe brand side stripe — colored accent stripe on outer shoe face
  if (c.shoeBrand) {
    const sb = SHOE_BRANDS.find(b => b.id === c.shoeBrand);
    const col = sb ? sb.accent : '#1a1a1a';
    const stripeMat = new THREE.MeshStandardMaterial({ color: col, roughness: 0.55 });
    for (const [leg, side] of [[legL, 1], [legR, -1]]) {
      const stripe = new THREE.Mesh(new THREE.BoxGeometry(0.005, 0.036, 0.15), stripeMat);
      stripe.position.set(0.057 * side, -0.425, 0.06);
      leg.userData.knee.add(stripe);
    }
  }

  root.traverse((m) => { if (m.isMesh) { m.castShadow = true; } });
  const setColors = (n) => { for (const k in n) if (mats[k]) mats[k].color.set(n[k]); };
  return { group: root, parts: { hips, torso, head, legL, legR, armL, armR }, setColors, mats };
}

/* ---------------- Skateboard ---------------- */
export function makeBoard(o = {}) {
  const c = { deck: DECKS[0], grip: '#1a1b1e', wheels: '#f6efe0', trucks: '#aab2bc', brand: null, ...o };
  const g = new THREE.Group(); g.name = 'Skateboard';
  const deckMat = new THREE.MeshStandardMaterial({ color: c.deck, roughness: 0.55 });
  const wood = new THREE.MeshStandardMaterial({ color: '#d8b98a', roughness: 0.7 });
  const gripMat = new THREE.MeshStandardMaterial({ color: c.grip, roughness: 1 });
  // bottom graphic (original design), redrawn when the deck colour changes
  const cv = typeof document !== 'undefined' ? document.createElement('canvas') : null;
  let gfxMat = deckMat;
  const drawDeck = (color) => {
    if (!cv) return; cv.width = 128; cv.height = 512; const x = cv.getContext('2d');
    const brand = c.brand ? DECK_BRANDS.find(b => b.id === c.brand) : null;
    if (brand) {
      paintDeckBrand(x, brand);
    } else {
      x.fillStyle = color; x.fillRect(0, 0, 128, 512);
      x.fillStyle = 'rgba(255,255,255,0.9)'; for (let i = 0; i < 5; i++) x.fillRect(0, 150 + i * 22, 128, 9);
      x.fillStyle = 'rgba(0,0,0,0.25)'; x.beginPath(); x.arc(64, 360, 34, 0, Math.PI * 2); x.fill();
      x.save(); x.translate(64, 360); x.rotate(-Math.PI / 2); x.fillStyle = '#fff'; x.font = '900 34px system-ui, sans-serif'; x.textAlign = 'center'; x.textBaseline = 'middle'; x.fillText('SC', 0, 2); x.restore();
    }
    if (gfxMat.map) gfxMat.map.needsUpdate = true;
  };
  if (cv) { drawDeck(c.deck); const tex = new THREE.CanvasTexture(cv); tex.colorSpace = THREE.SRGBColorSpace; gfxMat = new THREE.MeshStandardMaterial({ map: tex, roughness: 0.5 }); }
  const flat = mesh(new THREE.BoxGeometry(0.21, 0.018, 0.58), [wood, wood, gripMat, gfxMat, wood, wood]); flat.position.y = 0.095; g.add(flat);
  const grip = box(0.205, 0.004, 0.58, gripMat, 0, 0.106, 0); g.add(grip);
  for (const s of [1, -1]) {
    const kick = mesh(new THREE.BoxGeometry(0.21, 0.018, 0.14), [wood, wood, gripMat, deckMat, wood, wood]);
    kick.position.set(0, 0.113, 0.345 * s); kick.rotation.x = -0.28 * s; g.add(kick);
    const nose = mesh(new THREE.CylinderGeometry(0.105, 0.105, 0.018, 16, 1, false, 0, Math.PI), deckMat);
    nose.rotation.y = s > 0 ? -Math.PI / 2 : Math.PI / 2; nose.position.set(0, 0.13, 0.41 * s); nose.scale.z = 0.5; g.add(nose);
    const truck = box(0.17, 0.03, 0.05, mat(c.trucks, { metalness: 0.8, roughness: 0.35 }), 0, 0.065, 0.22 * s); g.add(truck);
    for (const x of [-0.085, 0.085]) { const w = wheel(0.028, 0.03, c.wheels, c.wheels); w.position.set(x, 0.028, 0.22 * s); g.add(w); }
  }
  g.userData.deckMat = deckMat;
  g.userData.setDeck = (color) => { deckMat.color.set(color); drawDeck(color); };
  return g;
}

/* ---------------- Vehicles ---------------- */
function lights(g, w, y, zf, zb) {
  for (const s of [-1, 1]) {
    g.add(box(0.3, 0.12, 0.04, '#fff6d6', s * (w / 2 - 0.24), y, zf, { emissive: '#fff1c8', emissiveIntensity: 0.8 }));
    g.add(box(0.3, 0.1, 0.04, '#ff4b4b', s * (w / 2 - 0.24), y, zb, { emissive: '#ff1a1a', emissiveIntensity: 0.6 }));
  }
}
export function makeCar(o = {}) {
  const c = { color: '#e85d5d', style: 'sedan', ...o };
  const g = new THREE.Group(); g.name = 'Car';
  const L = c.style === 'hatch' ? 3.7 : 4.3;
  const pm = paint(c.color);
  g.add(box(1.82, 0.55, L, pm, 0, 0.6, 0));
  g.add(box(1.84, 0.12, L + 0.04, '#2b2f38', 0, 0.36, 0)); // bumper strip
  const cabLen = c.style === 'hatch' ? 2.0 : 2.1;
  const cab = box(1.6, 0.52, cabLen, pm, 0, 1.13, c.style === 'hatch' ? -0.5 : -0.2); g.add(cab);
  const glass = box(1.64, 0.36, cabLen - 0.25, GLASS(), 0, 1.14, cab.position.z); g.add(glass);
  const ws = box(1.5, 0.38, 0.05, GLASS(), 0, 1.12, cab.position.z + cabLen / 2); g.add(ws);
  const rw = box(1.5, 0.34, 0.05, GLASS(), 0, 1.12, cab.position.z - cabLen / 2); g.add(rw);
  for (const s of [-1, 1]) { const mirror = box(0.14, 0.1, 0.08, pm, s * 0.98, 0.98, cab.position.z + cabLen / 2 - 0.1); g.add(mirror); }
  g.add(box(1.3, 0.14, 0.03, CHROME(), 0, 0.52, L / 2 + 0.01));
  lights(g, 1.82, 0.7, L / 2, -L / 2);
  if (c.sign) { const s = box(0.7, 0.18, 0.3, c.sign, 0, 1.48, cab.position.z, { emissive: c.sign, emissiveIntensity: 0.5 }); g.add(s); }
  const wheels = [];
  const wz = L / 2 - 0.8;
  for (const [x, z] of [[0.8, wz], [-0.8, wz], [0.8, -wz], [-0.8, -wz]]) { const w = wheel(0.36, 0.26); w.position.set(x, 0.36, z); g.add(w); wheels.push(w); }
  return { group: g, wheels, wheelRadius: 0.36, wheelPos: [[0.8, wz], [-0.8, wz], [0.8, -wz], [-0.8, -wz]] };
}
export function makeRideshare() { return makeCar({ color: PALETTE.hailr, sign: PALETTE.hailrSign }); }

export function makeMoto(o = {}) {
  const c = { color: '#2d6cdf', ...o };
  const g = new THREE.Group(); g.name = 'Motorcycle';
  g.add(box(0.3, 0.3, 0.9, '#2b2f38', 0, 0.5, 0));
  g.add(mesh(new THREE.SphereGeometry(0.26, 16, 12), paint(c.color)).translateY(0.78).translateZ(0.2));
  g.children[1].scale.set(0.75, 0.6, 1.2);
  g.add(box(0.26, 0.1, 0.6, '#1a1b1e', 0, 0.82, -0.3));
  g.add(box(0.32, 0.12, 0.35, c.color, 0, 0.72, -0.72));
  g.add(tube([0, 0.95, 0.55], [0, 0.35, 0.8], 0.03, '#aab2bc'));
  g.add(tube([-0.32, 1.02, 0.5], [0.32, 1.02, 0.5], 0.022, '#2b2f38'));
  g.add(box(0.16, 0.12, 0.08, '#fff6d6', 0, 0.9, 0.68, { emissive: '#fff1b8', emissiveIntensity: 0.6 }));
  g.add(tube([0.14, 0.4, -0.2], [0.14, 0.5, -0.75], 0.035, '#9aa3ad'));
  const wheels = [];
  for (const z of [0.78, -0.72]) { const w = wheel(0.33, 0.14); w.position.set(0, 0.33, z); g.add(w); wheels.push(w); }
  return { group: g, wheels, wheelRadius: 0.33 };
}

export function makeEBike(o = {}) {
  const c = { color: PALETTE.zipp, accent: PALETTE.zippAccent, ...o };
  const g = new THREE.Group(); g.name = 'ZippEBike';
  const wheels = [];
  for (const z of [0.55, -0.55]) { const w = wheel(0.33, 0.06); w.position.set(0, 0.33, z); g.add(w); wheels.push(w); }
  g.add(tube([0, 0.33, -0.55], [0, 0.62, -0.1], 0.035, c.color));
  g.add(tube([0, 0.62, -0.1], [0, 0.4, 0.28], 0.045, c.color));
  g.add(tube([0, 0.4, 0.28], [0, 0.33, 0.55], 0.03, c.color));
  g.add(tube([0, 0.4, 0.28], [0, 1.0, 0.42], 0.03, c.color));
  g.add(tube([-0.28, 1.02, 0.42], [0.28, 1.02, 0.42], 0.02, '#2b2f38'));
  g.add(tube([0, 0.62, -0.1], [0, 0.9, -0.18], 0.025, '#2b2f38'));
  g.add(box(0.16, 0.06, 0.26, '#1a1b1e', 0, 0.93, -0.2));
  g.add(box(0.12, 0.14, 0.34, c.accent, 0, 0.5, 0.1)); // battery
  const basket = box(0.36, 0.2, 0.28, c.color, 0, 0.9, 0.66); basket.material = mat(c.color, { transparent: true, opacity: 0.85 }); g.add(basket);
  g.add(box(0.3, 0.02, 0.5, c.color, 0, 0.72, -0.5)); // rear rack
  return { group: g, wheels, wheelRadius: 0.33 };
}

export function makeEScooter(o = {}) {
  const c = { color: PALETTE.zipp, accent: PALETTE.zippAccent, ...o };
  const g = new THREE.Group(); g.name = 'ZippScooter';
  const wheels = [];
  for (const z of [0.4, -0.4]) { const w = wheel(0.11, 0.06); w.position.set(0, 0.11, z); g.add(w); wheels.push(w); }
  g.add(box(0.17, 0.06, 0.78, c.color, 0, 0.16, 0));
  g.add(box(0.15, 0.01, 0.6, '#1a1b1e', 0, 0.195, -0.02));
  g.add(tube([0, 0.17, 0.38], [0, 1.08, 0.46], 0.03, '#2b2f38'));
  g.add(tube([-0.24, 1.08, 0.46], [0.24, 1.08, 0.46], 0.02, '#2b2f38'));
  g.add(box(0.1, 0.1, 0.05, c.accent, 0, 0.9, 0.47));
  g.add(box(0.1, 0.03, 0.15, c.accent, 0, 0.2, -0.46));
  return { group: g, wheels, wheelRadius: 0.11 };
}

/* ---------------- City props ---------------- */
export function makeBuilding(w, d, h, color) {
  const g = new THREE.Group(); g.name = 'Building';
  g.add(box(w, h, d, color, 0, h / 2, 0));
  g.add(box(w + 0.3, 0.35, d + 0.3, PALETTE.roof, 0, h + 0.17, 0));
  if (h > 14) g.add(box(w * 0.35, 2.2, d * 0.35, PALETTE.roof, w * 0.12, h + 1.4, -d * 0.1));
  return g;
}
export function makeTree(s = 1) {
  const g = new THREE.Group(); g.name = 'Tree';
  const t = cyl(0.14 * s, 0.2 * s, 1.8 * s, '#a58a6a', 7); t.position.y = 0.9 * s; g.add(t);
  const a = mesh(new THREE.IcosahedronGeometry(1.3 * s, 1), '#8fcf7a', { flatShading: true }); a.position.y = 2.6 * s; g.add(a);
  const b = mesh(new THREE.IcosahedronGeometry(0.9 * s, 1), '#7fc46b', { flatShading: true }); b.position.set(0.5 * s, 3.3 * s, 0.2 * s); g.add(b);
  return g;
}
export function makeStreetLight() {
  const g = new THREE.Group(); g.name = 'StreetLight';
  const p = cyl(0.06, 0.08, 5, '#9aa3ad', 8); p.position.y = 2.5; g.add(p);
  g.add(tube([0, 4.95, 0], [0, 4.95, 1.1], 0.04, '#9aa3ad'));
  g.add(box(0.35, 0.1, 0.5, '#e9edf2', 0, 4.9, 1.2, { emissive: '#fff4d0', emissiveIntensity: 0.3 }));
  return g;
}
export function makeBench() {
  const g = new THREE.Group(); g.name = 'Bench';
  g.add(box(1.8, 0.08, 0.45, '#b98a5f', 0, 0.45, 0));
  g.add(box(1.8, 0.35, 0.06, '#b98a5f', 0, 0.75, -0.2));
  for (const x of [-0.75, 0.75]) g.add(box(0.08, 0.45, 0.4, '#6b7280', x, 0.22, 0));
  return g;
}
export function makeRail(len = 6, h = 0.45) {
  const g = new THREE.Group(); g.name = 'Rail';
  const bar = cyl(0.03, 0.03, len, '#c3cad3', 10, { metalness: 0.6, roughness: 0.35 }); bar.rotation.x = Math.PI / 2; bar.position.y = h; g.add(bar);
  for (const z of [-len / 2 + 0.3, len / 2 - 0.3]) { const p = cyl(0.03, 0.03, h, '#8f98a3', 8); p.position.set(0, h / 2, z); g.add(p); }
  return g;
}
export function makeLedge(len = 6, h = 0.45, w = 0.7) {
  const g = new THREE.Group(); g.name = 'Ledge';
  g.add(box(w, h, len, PALETTE.concrete, 0, h / 2, 0));
  g.add(box(0.06, 0.04, len, '#8f98a3', w / 2 - 0.03, h + 0.005, 0, { metalness: 0.6, roughness: 0.4 }));
  return g;
}
export function kickerGeometry(w, len, h) {
  const s = new THREE.Shape(); s.moveTo(0, 0); s.lineTo(len, 0); s.lineTo(len, h); s.lineTo(0, 0.001);
  const geo = new THREE.ExtrudeGeometry(s, { depth: w, bevelEnabled: false });
  geo.rotateY(-Math.PI / 2); geo.translate(w / 2, 0, -len / 2);
  return geo; // rises toward +Z
}
export function makeKicker(w = 3, len = 3, h = 0.8) {
  const g = new THREE.Group(); g.name = 'Kicker';
  g.add(mesh(kickerGeometry(w, len, h), '#d8c3a5'));
  g.add(box(w, 0.04, 0.08, '#8f98a3', 0, h, len / 2 - 0.04, { metalness: 0.6 }));
  return g;
}
export function makeStairs(steps = 5, width = 5, rise = 0.18, run = 0.38) {
  const g = new THREE.Group(); g.name = 'StairSet';
  for (let i = 0; i < steps; i++) {
    const hgt = rise * (steps - i);
    g.add(box(width, hgt, run, PALETTE.concrete, 0, hgt / 2, i * run + run / 2));
  }
  return g;
}
export function makePin(color = '#ff4f6d') {
  const g = new THREE.Group(); g.name = 'Pin';
  const head = sphere(0.9, color, 18, 14, { emissive: color, emissiveIntensity: 0.35 }); head.position.y = 4.2; g.add(head);
  const dot = sphere(0.35, '#ffffff', 12, 10); dot.position.set(0, 4.2, 0.7); g.add(dot);
  const tip = cyl(0.62, 0.02, 1.6, color, 16, { emissive: color, emissiveIntensity: 0.35 }); tip.position.y = 3.05; g.add(tip);
  const ring = mesh(new THREE.RingGeometry(1.6, 2.1, 40), color, { transparent: true, opacity: 0.55, side: THREE.DoubleSide, emissive: color, emissiveIntensity: 0.4 });
  ring.rotation.x = -Math.PI / 2; ring.position.y = 0.06; ring.castShadow = false; g.add(ring);
  g.userData.head = head; g.userData.ring = ring;
  return g;
}

export const ASSET_CATALOG = {
  avatar: () => makeAvatar().group,
  skateboard: () => makeBoard(),
  car_sedan: () => makeCar().group,
  car_hatch: () => makeCar({ style: 'hatch', color: '#5b8def' }).group,
  hailr_rideshare: () => makeRideshare().group,
  motorcycle: () => makeMoto().group,
  zipp_ebike: () => makeEBike().group,
  zipp_escooter: () => makeEScooter().group,
  building: () => makeBuilding(14, 12, 24, PALETTE.building[0]),
  tree: () => makeTree(),
  streetlight: () => makeStreetLight(),
  bench: () => makeBench(),
  rail: () => makeRail(),
  ledge: () => makeLedge(),
  kicker: () => makeKicker(),
  stairs: () => makeStairs(),
  map_pin: () => makePin(),
};
