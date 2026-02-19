// ─── STATE ───
let currentView = 'login';
let searchTerm = '';
let typeFilter = '';
let statusFilter = '';

// ─── DATA ───
const inversores = [
  { id: '7721098821', name: 'Global Capital Group', email: 'corp@globalcapital.io', phone: '3002211445', type: 'Jurídico', part: 25.5, status: 'ACTIVO' },
  { id: '1023445566', name: 'Inversiones del Pacífico S.A.', email: 'gestion@invpacifico.co', phone: '3114455882', type: 'Jurídico', part: 18.0, status: 'ACTIVO' },
  { id: '8827711002', name: 'Dr. Fernando Arango', email: 'fernando.arango@med.com', phone: '3009988112', type: 'Natural', part: 12.2, status: 'INACTIVO' },
  { id: '1109922883', name: 'Fundación Bienestar Social', email: 'proyectos@fbienestar.org', phone: '3205566778', type: 'Jurídico', part: 5.4, status: 'ACTIVO' },
  { id: '9921188334', name: 'Ing. Marta Lucía Pérez', email: 'marta.perez@consultores.co', phone: '3152233445', type: 'Natural', part: 8.8, status: 'ACTIVO' },
  { id: '1002233445', name: 'Holdings Unidas del Norte', email: 'admin@unidasnorte.co', phone: '3041122334', type: 'Jurídico', part: 30.1, status: 'INACTIVO' },
];

const proyectos = [
  { id: 'PROY-9982', name: 'Refinería Norte Fase II', desc: 'Despliegue operativo de sistemas de respaldo y redundancia para los nodos centrales de la red corporativa.', budget: 1250000, resp: 'Ing. Carlos Ruiz', days: 124, progress: 65, status: 'ACTIVO' },
  { id: 'PROY-4411', name: 'Planta Potabilizadora Sede B', desc: 'Modernización de los filtros de agua y sistemas de bombeo para la planta de producción secundaria.', budget: 850000, resp: 'Arq. Elena Soler', days: 90, progress: 100, status: 'COMPLETADO' },
  { id: 'PROY-1108', name: 'Sede Administrativa Central', desc: 'Remodelación integral de la torre principal incluyendo cableado estructurado y eficiencia energética.', budget: 3420000, resp: 'Ing. David Luna', days: 240, progress: 40, status: 'ACTIVO' },
  { id: 'PROY-0056', name: 'Optimización de Nube Privada', desc: 'Migración de servicios legacy a infraestructura contenerizada de alta disponibilidad.', budget: 560000, resp: 'Ing. Marta Pérez', days: 60, progress: 15, status: 'ACTIVO' },
];

// ─── DARK MODE ───
function applyDark() {
  if (isDark) {
    document.documentElement.classList.add('dark');
    // moon icon → show sun
    const moonSvg = '<circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>';
    document.querySelectorAll('[id*=dark-icon]').forEach(el => el.innerHTML = moonSvg);
  } else {
    document.documentElement.classList.remove('dark');
    const sunSvg = '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>';
    document.querySelectorAll('[id*=dark-icon]').forEach(el => el.innerHTML = sunSvg);
  }
  // redraw charts if visible
  if (document.getElementById('view-dashboard')?.classList.contains('active')) {
    setTimeout(initCharts, 50);
  }
}
function toggleDark() { isDark = !isDark; applyDark(); }

// ─── ROUTING ───
function goTo(view) {
  ['login','register','app'].forEach(v => {
    const el = document.getElementById('view-' + v);
    if (el) { el.style.display = 'none'; el.classList.remove('active'); }
  });
  if (view === 'app') {
    const app = document.getElementById('view-app');
    app.style.display = 'flex';
    renderProyectos();
    renderInversores();
    setTimeout(initCharts, 100);
  } else {
    const el = document.getElementById('view-' + view);
    el.style.display = 'flex';
    el.classList.add('active');
  }
  currentView = view;
}

// Mostrar login al cargar
window.addEventListener('DOMContentLoaded', () => { goTo('login'); });

function doLogin(e) { e.preventDefault(); goTo('app'); }

// ─── TABS ───
function switchTab(btn) {
  document.querySelectorAll('.nav-item').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  const viewId = btn.dataset.view;
  document.querySelectorAll('#view-app .view').forEach(v => v.classList.remove('active'));
  document.getElementById('view-' + viewId)?.classList.add('active');
  if (viewId === 'dashboard') setTimeout(initCharts, 100);
}

// ─── CHARTS ───
let barChart, areaChart;
function initCharts() {
  const gridColor = isDark ? '#334155' : '#e2e8f0';
  const textColor = isDark ? '#94a3b8' : '#64748b';
  const tooltipBg = isDark ? '#1e293b' : '#ffffff';
  const data = [
    { name: 'Ene', ventas: 4000, gastos: 2400 },
    { name: 'Feb', ventas: 3000, gastos: 1398 },
    { name: 'Mar', ventas: 2000, gastos: 9800 },
    { name: 'Abr', ventas: 2780, gastos: 3908 },
    { name: 'May', ventas: 1890, gastos: 4800 },
    { name: 'Jun', ventas: 2390, gastos: 3800 },
  ];
  const labels = data.map(d => d.name);

  const barCtx = document.getElementById('barChart');
  if (barCtx) {
    if (barChart) barChart.destroy();
    barChart = new Chart(barCtx, {
      type: 'bar',
      data: {
        labels,
        datasets: [
          { label: 'Ventas', data: data.map(d=>d.ventas), backgroundColor: '#2563eb', borderRadius: 6, barThickness: 16 },
          { label: 'Gastos', data: data.map(d=>d.gastos), backgroundColor: '#94a3b8', borderRadius: 6, barThickness: 16 },
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false }, tooltip: { backgroundColor: tooltipBg, titleColor: isDark?'#f8fafc':'#0f172a', bodyColor: isDark?'#94a3b8':'#64748b', borderColor: gridColor, borderWidth: 1, cornerRadius: 12 } },
        scales: {
          x: { grid: { display: false }, ticks: { color: textColor, font: { size: 10, weight: 'bold' } }, border: { display: false } },
          y: { grid: { color: gridColor }, ticks: { color: textColor, font: { size: 10, weight: 'bold' } }, border: { display: false } }
        }
      }
    });
  }

  const areaCtx = document.getElementById('areaChart');
  if (areaCtx) {
    if (areaChart) areaChart.destroy();
    const gradient = areaCtx.getContext('2d').createLinearGradient(0, 0, 0, 240);
    gradient.addColorStop(0, 'rgba(37,99,235,.4)');
    gradient.addColorStop(1, 'rgba(37,99,235,0)');
    areaChart = new Chart(areaCtx, {
      type: 'line',
      data: {
        labels,
        datasets: [{ label: 'Ventas', data: data.map(d=>d.ventas), borderColor: '#2563eb', borderWidth: 4, pointRadius: 0, fill: true, backgroundColor: gradient, tension: 0.4 }]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false }, tooltip: { backgroundColor: tooltipBg, borderColor: gridColor, borderWidth: 1, cornerRadius: 12 } },
        scales: {
          x: { grid: { display: false }, ticks: { color: textColor, font: { size: 10, weight: 'bold' } }, border: { display: false } },
          y: { grid: { color: gridColor }, ticks: { color: textColor, font: { size: 10, weight: 'bold' } }, border: { display: false } }
        }
      }
    });
  }
}

// ─── INVERSORES ───
function renderInversores() {
  const grid = document.getElementById('inversores-grid');
  if (!grid) return;
  const filtered = inversores.filter(inv => {
    const matchSearch = inv.name.toLowerCase().includes(searchTerm.toLowerCase()) || inv.id.includes(searchTerm);
    const matchType = !typeFilter || inv.type === typeFilter;
    const matchStatus = !statusFilter || inv.status === statusFilter;
    return matchSearch && matchType && matchStatus;
  });
  if (filtered.length === 0) {
    grid.innerHTML = `<div style="grid-column:1/-1;text-align:center;padding:60px 20px;background:var(--card);border:2px dashed var(--border);border-radius:32px"><svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="margin:0 auto 12px"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg><h3 style="font-weight:900;text-transform:uppercase;color:var(--text)">Sin resultados</h3><p style="color:var(--text-muted);margin-top:4px">No hay inversores que coincidan con los filtros.</p><button onclick="resetInversores()" style="margin-top:16px;font-size:11px;font-weight:900;color:var(--blue-600);background:none;border:none;cursor:pointer;text-transform:uppercase;text-decoration:underline">Restablecer Búsqueda</button></div>`;
    return;
  }
  grid.innerHTML = filtered.map(inv => `
    <div class="inversor-card">
      <div class="inversor-top">
        <div class="inv-avatar-wrap">
          <img class="inv-avatar" src="https://picsum.photos/seed/${inv.id}/100/100" alt="${inv.name}"/>
          <div class="inv-status-dot ${inv.status === 'ACTIVO' ? 'active' : 'inactive'}">
            ${inv.status === 'ACTIVO'
              ? '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>'
              : '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>'
            }
          </div>
        </div>
        <div>
          <div class="inv-name">${inv.name}</div>
          <div class="inv-badges">
            <span class="badge badge-blue">${inv.type}</span>
            <span class="badge ${inv.status === 'ACTIVO' ? 'badge-green' : 'badge-gray'}">${inv.status}</span>
          </div>
        </div>
      </div>
      <div class="inv-details">
        <div class="inv-detail"><div class="inv-detail-icon"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg></div>${inv.email}</div>
        <div class="inv-detail"><div class="inv-detail-icon"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13 19.79 19.79 0 0 1 1.61 4.38 2 2 0 0 1 3.58 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></div>(+57) ${inv.phone}</div>
        <div class="inv-detail" style="font-size:12px;font-family:monospace;font-style:italic"><div class="inv-detail-icon"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--gray-400)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" y1="9" x2="20" y2="9"/><line x1="4" y1="15" x2="20" y2="15"/><line x1="10" y1="3" x2="8" y2="21"/><line x1="16" y1="3" x2="14" y2="21"/></svg></div>ID: ${inv.id}</div>
      </div>
      <div class="inv-part-row">
        <div class="inv-part-label">
          <span class="inv-part-text">Participación Societaria</span>
          <span class="inv-part-pct">${inv.part}%</span>
        </div>
        <div class="progress-bar"><div class="progress-fill ${inv.status !== 'ACTIVO' ? '' : ''}" style="width:${inv.part}%;${inv.status !== 'ACTIVO' ? 'background:#9ca3af;box-shadow:none' : ''}"></div></div>
      </div>
    </div>
  `).join('');
}

function filterInversores(val) { searchTerm = val; renderInversores(); }
function filterByType(val) { typeFilter = val; renderInversores(); }
function filterByStatus(val) { statusFilter = val; renderInversores(); }
function resetInversores() {
  searchTerm = ''; typeFilter = ''; statusFilter = '';
  document.querySelectorAll('.filter-input,.filter-select').forEach(el => el.value = '');
  renderInversores();
}

// ─── PROYECTOS ───
function renderProyectos() {
  const grid = document.querySelector('.proyectos-grid');
  if (!grid) return;
  grid.innerHTML = proyectos.map(p => `
    <div class="proyecto-card">
      <div class="proyecto-body">
        <div class="proyecto-top">
          <div style="display:flex;align-items:center;gap:12px">
            <div class="proyecto-id-box"><span>${p.id.slice(-4)}</span></div>
            <div>
              <div class="proyecto-id">${p.id}</div>
              <div class="proyecto-name">${p.name}</div>
            </div>
          </div>
          <span class="badge ${p.status === 'COMPLETADO' ? 'badge-green' : 'badge-blue'}">${p.status}</span>
        </div>
        <p class="proyecto-desc">${p.desc}</p>
        <div class="proyecto-meta-grid">
          <div class="proyecto-meta"><div class="proyecto-meta-icon"><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div><div><div class="proyecto-meta-label">Asignado</div><div class="proyecto-meta-val">$${p.budget.toLocaleString()}</div></div></div>
          <div class="proyecto-meta"><div class="proyecto-meta-icon"><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div><div><div class="proyecto-meta-label">Responsable</div><div class="proyecto-meta-val">${p.resp}</div></div></div>
          <div class="proyecto-meta"><div class="proyecto-meta-icon"><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div><div><div class="proyecto-meta-label">Días Restantes</div><div class="proyecto-meta-val">${p.days}d</div></div></div>
          <div class="proyecto-meta"><div class="proyecto-meta-icon"><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div><div><div class="proyecto-meta-label">Auditoría</div><div class="proyecto-meta-val">VALIDADA</div></div></div>
        </div>
        <div class="proyecto-progress-label"><span>Progreso de Ejecución</span><span style="color:var(--blue-600);font-size:14px">${p.progress}%</span></div>
        <div class="progress-bar" style="height:10px"><div class="progress-fill" style="width:${p.progress}%;${p.status==='COMPLETADO'?'background:#22c55e':''};border-radius:8px"></div></div>
      </div>
      <div class="proyecto-footer">
        <span class="proyecto-footer-txt">Presupuesto: PR-2025-GRP</span>
        <button class="table-link">Gestionar Bitácora</button>
      </div>
    </div>
  `).join('');
}

// ─── NOTIF ───
function toggleNotif() {
  document.getElementById('notif-panel').classList.toggle('open');
}
document.addEventListener('click', e => {
  const panel = document.getElementById('notif-panel');
  const btn = document.getElementById('notif-btn');
  if (panel && btn && !panel.contains(e.target) && !btn.contains(e.target)) {
    panel.classList.remove('open');
  }
});

// ─── EXPORT CSV ───
function exportCSV() {
  const csv = 'ID Cálculo,Indicador,Valor,Estado,Fecha\nCAL-9981-A,Nivel de Endeudamiento,58.4%,DANGER,2025-05-20\nCAL-2245-X,Rentabilidad Operativa,14.2%,DANGER,2025-05-20\nCAL-1102-L,Liquidez Corriente,1.62,WARNING,2025-05-20\nCAL-8874-R,Rotación de Inventarios,12.4,OK,2025-05-19';
  const blob = new Blob([csv], { type: 'text/csv' });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = 'indicadores_kpis_' + new Date().toISOString().split('T')[0] + '.csv';
  a.click();
}

// ─── REPORTES ───
function selectReport(btn) {
  document.querySelectorAll('.report-option').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
}
function downloadReport() {
  const icon = document.getElementById('dl-icon');
  const text = document.getElementById('dl-text');
  text.textContent = 'Procesando...';
  icon.innerHTML = '<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>';
  setTimeout(() => {
    document.getElementById('success-overlay').style.display = 'flex';
    setTimeout(() => {
      document.getElementById('success-overlay').style.display = 'none';
      text.textContent = 'Descargar Reporte PDF';
      icon.innerHTML = '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>';
    }, 3000);
  }, 2500);
}

// ─── PASSWORD TOGGLE ───
function togglePw() {
  const input = document.getElementById('pw-input');
  const eye = document.getElementById('pw-eye');
  if (input.type === 'password') {
    input.type = 'text';
    eye.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
  } else {
    input.type = 'password';
    eye.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
  }
}

// ─── INIT ───
applyDark();