(function () {
  const SLUG = window.GA_STORE_SLUG;
  const app = document.getElementById('app');
  const FMT = new Intl.DateTimeFormat('en-GB', { day: 'numeric', month: 'long', year: 'numeric', weekday: 'long' });

  function escapeHtml(str) {
    const div = document.createElement('div');
    div.textContent = str == null ? '' : String(str);
    return div.innerHTML;
  }

  function renderError(message) {
    app.innerHTML = `<div class="page"><div class="error">${escapeHtml(message)}</div></div>`;
  }

  function formatDate(row) {
    if (row.date_tbd || !row.date) return null;
    return FMT.format(new Date(row.date + 'T00:00:00'));
  }

  function prizeListHtml(prizeStructure) {
    if (!prizeStructure) {
      return `<p class="pending">Prize details will be announced by the store closer to the event. Check the <a href="https://storage.googleapis.com/omnidex/seasons/PRD%20Season%20Guide.pdf" target="_blank" rel="noopener noreferrer" style="color: var(--gold);">PRD Season Guide</a> for baseline structure.</p>`;
    }
    const lines = prizeStructure.split('\n').map(l => l.trim()).filter(Boolean);
    return `<ul>${lines.map(l => `<li>${escapeHtml(l)}</li>`).join('')}</ul>`;
  }

  function render(row) {
    const dateStr = formatDate(row);
    const hasPoster = !!row.poster_url;

    document.title = `${row.store_name} | Store Championship`;

    const metaLines = [
      `<div><strong>Store championship:</strong> PRD season at ${escapeHtml(row.store_name)}</div>`,
      `<div><strong>Date:</strong> ${dateStr ? escapeHtml(dateStr) : 'To be announced'}</div>`,
      `<div><strong>Venue:</strong> ${escapeHtml(row.address)}</div>`,
    ];
    if (row.format) metaLines.push(`<div><strong>Format:</strong> ${escapeHtml(row.format)}</div>`);
    if (row.registration_window) metaLines.push(`<div><strong>Registration:</strong> ${escapeHtml(row.registration_window)}</div>`);
    if (row.round1_time) metaLines.push(`<div><strong>Round 1:</strong> ${escapeHtml(row.round1_time)}</div>`);
    if (row.entry_fee) metaLines.push(`<div><strong>Entry:</strong> ${escapeHtml(row.entry_fee)}</div>`);

    const ctas = [];
    if (row.registration_url) {
      ctas.push(`<a class="cta primary" href="${escapeHtml(row.registration_url)}" target="_blank" rel="noopener noreferrer">Register today</a>`);
    } else {
      ctas.push(`<span class="cta primary disabled">Registration opening soon</span>`);
    }
    ctas.push(`<a class="cta secondary" href="${escapeHtml(row.google_maps_url)}" target="_blank" rel="noopener noreferrer">Get directions</a>`);
    ctas.push(`<a class="cta secondary" href="../../index.html">Back to list</a>`);

    app.innerHTML = `
      <div class="page">
        <div class="header">
          <div>
            <p class="eyebrow">Grand Archive TCG</p>
            <div style="font-size: 12px; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted);">Store championship</div>
          </div>
          <a class="back" href="../../index.html">← Back to Horizon</a>
        </div>

        <div class="content">
          <div class="hero ${hasPoster ? '' : 'no-poster'}">
            ${hasPoster ? `<img class="poster" src="${escapeHtml(row.poster_url)}" alt="${escapeHtml(row.store_name)} store championship poster" />` : ''}
            <div class="info">
              <span class="pill ${row.date_tbd ? 'tbd' : ''}">Malaysia · ${escapeHtml(row.state)}</span>
              <h1>${escapeHtml(row.store_name)}</h1>
              <div class="meta">${metaLines.join('')}</div>
              <div class="cta-row">${ctas.join('')}</div>
            </div>
          </div>

          <div class="two-up">
            <div class="card">
              <h2>Prize structure</h2>
              ${prizeListHtml(row.prize_structure)}
            </div>
            <div class="card">
              <h2>Highlights</h2>
              <p>${row.highlights ? escapeHtml(row.highlights) : `<span class="pending">More details coming as the store confirms — check back closer to the event, or see the season guide for general rules.</span>`}</p>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  async function init() {
    if (!SLUG) {
      renderError('No store specified.');
      return;
    }
    if (!window.GA_HORIZON_CONFIG || !window.GA_HORIZON_CONFIG.supabaseUrl || !window.supabase) {
      renderError('Unable to load store data right now — please try again shortly.');
      return;
    }
    const cfg = window.GA_HORIZON_CONFIG;
    const supabase = window.supabase.createClient(cfg.supabaseUrl, cfg.supabaseAnonKey, { auth: { persistSession: false } });

    const { data, error } = await supabase
      .from('store_detail_summary')
      .select('*')
      .eq('season_slug', cfg.seasonSlug || 'prd-2026')
      .eq('store_slug', SLUG)
      .maybeSingle();

    if (error || !data) {
      renderError('Could not find this store championship. It may have been removed or renamed.');
      return;
    }
    render(data);
  }

  app.innerHTML = '<div class="page"><div class="loading">Loading store championship…</div></div>';
  init();
})();
