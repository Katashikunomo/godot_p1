// Genera un HTML autocontenido (con imagenes embebidas en base64) a partir del
// documento de entrega en Markdown. Abrir el HTML en el navegador y
// Ctrl+P -> "Guardar como PDF" produce el entregable.
//
// Uso:  node tools/build_html.js
// Salida: docs/documento_entrega.html

const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const MD = path.join(ROOT, "docs", "documento_entrega.md");
const OUT = path.join(ROOT, "docs", "documento_entrega.html");
const CAP_DIR = path.join(ROOT, "docs", "capturas");

let md = fs.readFileSync(MD, "utf8");

// --- Embeber imagenes locales como data URI ---
function imgToDataUri(relPath) {
  const abs = path.join(ROOT, "docs", relPath);
  if (!fs.existsSync(abs)) return null;
  const ext = path.extname(abs).slice(1).toLowerCase();
  const mime = ext === "jpg" ? "jpeg" : ext;
  const b64 = fs.readFileSync(abs).toString("base64");
  return `data:image/${mime};base64,${b64}`;
}

// --- Mini conversor Markdown -> HTML (suficiente para este documento) ---
function esc(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function inline(s) {
  // imagenes ![alt](src)
  s = s.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (m, alt, src) => {
    const uri = imgToDataUri(src);
    if (uri) return `<img alt="${esc(alt)}" src="${uri}" />`;
    return `<div class="missing">[Falta la imagen: ${esc(src)}]</div>`;
  });
  // enlaces [txt](url)
  s = s.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
  // negritas y cursivas y codigo inline
  s = s.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  s = s.replace(/`([^`]+)`/g, "<code>$1</code>");
  s = s.replace(/(^|[^*])\*([^*]+)\*(?!\*)/g, "$1<em>$2</em>");
  return s;
}

const lines = md.split(/\r?\n/);
let html = "";
let i = 0;
let inCode = false;
let codeBuf = [];
let tableBuf = [];

function flushTable() {
  if (tableBuf.length === 0) return;
  const rows = tableBuf.filter((r) => !/^\s*\|?\s*:?-{2,}/.test(r));
  html += "<table>";
  rows.forEach((r, idx) => {
    const cells = r.replace(/^\s*\|/, "").replace(/\|\s*$/, "").split("|").map((c) => c.trim());
    const tag = idx === 0 ? "th" : "td";
    html += "<tr>" + cells.map((c) => `<${tag}>${inline(esc(c))}</${tag}>`).join("") + "</tr>";
  });
  html += "</table>";
  tableBuf = [];
}

for (i = 0; i < lines.length; i++) {
  let ln = lines[i];

  if (/^```/.test(ln)) {
    if (!inCode) { inCode = true; codeBuf = []; }
    else { inCode = false; html += `<pre><code>${esc(codeBuf.join("\n"))}</code></pre>`; }
    continue;
  }
  if (inCode) { codeBuf.push(ln); continue; }

  if (/^\s*\|.*\|\s*$/.test(ln)) { tableBuf.push(ln); continue; }
  else if (tableBuf.length) { flushTable(); }

  if (/^###\s+/.test(ln)) { html += `<h3>${inline(esc(ln.replace(/^###\s+/, "")))}</h3>`; continue; }
  if (/^##\s+/.test(ln)) { html += `<h2>${inline(esc(ln.replace(/^##\s+/, "")))}</h2>`; continue; }
  if (/^#\s+/.test(ln)) { html += `<h1>${inline(esc(ln.replace(/^#\s+/, "")))}</h1>`; continue; }
  if (/^---\s*$/.test(ln)) { html += "<hr/>"; continue; }
  if (/^>\s?/.test(ln)) { html += `<blockquote>${inline(esc(ln.replace(/^>\s?/, "")))}</blockquote>`; continue; }

  if (/^\s*[-*]\s+/.test(ln)) {
    html += "<ul>";
    while (i < lines.length && /^\s*[-*]\s+/.test(lines[i])) {
      html += `<li>${inline(esc(lines[i].replace(/^\s*[-*]\s+/, "")))}</li>`;
      i++;
    }
    i--;
    html += "</ul>";
    continue;
  }
  if (/^\s*\d+\.\s+/.test(ln)) {
    html += "<ol>";
    while (i < lines.length && /^\s*\d+\.\s+/.test(lines[i])) {
      html += `<li>${inline(esc(lines[i].replace(/^\s*\d+\.\s+/, "")))}</li>`;
      i++;
    }
    i--;
    html += "</ol>";
    continue;
  }

  if (ln.trim() === "") { html += "\n"; continue; }
  html += `<p>${inline(esc(ln))}</p>`;
}
if (tableBuf.length) flushTable();

const doc = `<!DOCTYPE html>
<html lang="es"><head><meta charset="utf-8"/>
<title>Tarea 1 — Documento de entrega</title>
<style>
  @page { size: A4; margin: 18mm 16mm; }
  body { font-family: "Segoe UI", Arial, sans-serif; color: #1a1a1a; line-height: 1.5; font-size: 11pt; }
  h1 { font-size: 20pt; border-bottom: 3px solid #478cbf; padding-bottom: 6px; }
  h2 { font-size: 14pt; color: #2b5e86; margin-top: 22px; border-bottom: 1px solid #ddd; padding-bottom: 3px; }
  h3 { font-size: 12pt; color: #333; }
  code { background: #f2f4f7; padding: 1px 4px; border-radius: 3px; font-family: Consolas, monospace; font-size: 9.5pt; }
  pre { background: #1e2430; color: #e6e6e6; padding: 12px; border-radius: 6px; overflow-x: auto; font-size: 9pt; }
  pre code { background: transparent; color: inherit; padding: 0; }
  table { border-collapse: collapse; width: 100%; margin: 10px 0; font-size: 10pt; }
  th, td { border: 1px solid #ccc; padding: 6px 8px; text-align: left; vertical-align: top; }
  th { background: #eaf1f7; }
  blockquote { border-left: 4px solid #478cbf; margin: 8px 0; padding: 4px 12px; color: #555; background: #f7fafc; }
  img { max-width: 100%; border: 1px solid #ccc; border-radius: 4px; margin: 8px 0; display: block; }
  .missing { color: #b00; font-style: italic; border: 1px dashed #b00; padding: 8px; border-radius: 4px; }
  a { color: #2b5e86; }
  hr { border: none; border-top: 1px solid #ddd; margin: 16px 0; }
</style></head><body>
${html}
</body></html>`;

fs.writeFileSync(OUT, doc, "utf8");
const have = fs.existsSync(CAP_DIR) ? fs.readdirSync(CAP_DIR).filter((f) => /\.(png|jpg|jpeg)$/i.test(f)) : [];
console.log("HTML generado:", OUT);
console.log("Capturas encontradas en docs/capturas:", have.length ? have.join(", ") : "(ninguna todavia)");
