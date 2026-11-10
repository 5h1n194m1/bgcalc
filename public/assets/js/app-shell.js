/**
 * BGCalc Unified App Shell (Navigation Drawer + CSRF + Session + Roster Search)
 * Menggantikan: dashboard-layout.js, app-shell.js lama, pro-search-upgrade.js
 */
(function () {
    'use strict';

    const body = document.body;
    if (!body) return;

    const config = {
        csrfTokenName: body.dataset.bgCsrfTokenName || '',
        csrfHash: body.dataset.bgCsrfHash || '',
        baseUrl: body.dataset.bgBaseUrl || '',
        idleTimeoutSeconds: Number(body.dataset.bgIdleTimeoutSeconds || 0),
        idleWarningSeconds: Number(body.dataset.bgIdleWarningSeconds || 0),
        idleLogoutUrl: body.dataset.bgIdleLogoutUrl || '',
        keepAliveUrl: body.dataset.bgKeepAliveUrl || '',
    };

    const BGApp = {
        ...config,
        idleTimer: null,
        idleWarningTimer: null,
        idleCountdownTimer: null,
        idleDeadlineAt: 0,

        /* ==================================================================
           1. UNIFIED OFF-CANVAS SIDEBAR DRAWER (Desktop & Mobile)
           ================================================================== */
        initSidebarDrawer() {
            const sidebar = document.querySelector('.js-dashboard-sidebar');
            const overlay = document.querySelector('.js-sidebar-overlay');
            const toggleBtns = document.querySelectorAll('.js-sidebar-toggle');
            const closeBtns = document.querySelectorAll('.js-sidebar-close');

            if (!sidebar) return;

            const openSidebar = () => {
                sidebar.classList.add('is-open');
                sidebar.setAttribute('aria-hidden', 'false');
                body.classList.add('sidebar-open');
                if (overlay) overlay.classList.add('is-open');
            };

            const closeSidebar = () => {
                sidebar.classList.remove('is-open');
                sidebar.setAttribute('aria-hidden', 'true');
                body.classList.remove('sidebar-open', 'sidebar-collapsed');
                if (overlay) overlay.classList.remove('is-open');
            };

            const toggleSidebar = (e) => {
                if (e) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                if (sidebar.classList.contains('is-open')) {
                    closeSidebar();
                } else {
                    openSidebar();
                }
            };

            // Pastikan saat halaman baru dimuat, sidebar selalu tertutup rapat tanpa glitch
            closeSidebar();

            toggleBtns.forEach((btn) => {
                btn.addEventListener('click', toggleSidebar);
            });

            closeBtns.forEach((btn) => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    closeSidebar();
                });
            });

            if (overlay) {
                overlay.addEventListener('click', closeSidebar);
            }

            // Tutup otomatis saat menekan tombol Escape
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && sidebar.classList.contains('is-open')) {
                    closeSidebar();
                }
            });
        },

        /* ==================================================================
           2. CSRF FORM SYNCHRONIZATION
           ================================================================== */
        ensureFormCsrf(form) {
            if (!form || !this.csrfTokenName || !this.csrfHash) return;

            let input = form.querySelector(`input[name="${this.csrfTokenName}"]`);
            if (!input) {
                form.querySelectorAll('input[type="hidden"]').forEach((hidden) => {
                    if (/csrf/i.test(hidden.name || '')) {
                        hidden.remove();
                    }
                });

                input = document.createElement('input');
                input.type = 'hidden';
                input.name = this.csrfTokenName;
                form.prepend(input);
            }

            input.value = this.csrfHash;
        },

        syncAllPostForms() {
            document.querySelectorAll('form').forEach((form) => {
                const method = (form.getAttribute('method') || 'get').toLowerCase();
                if (method === 'post') {
                    this.ensureFormCsrf(form);
                }
            });
        },

        updateCsrf(tokenName, tokenHash) {
            if (!tokenName || !tokenHash) return;
            this.csrfTokenName = tokenName;
            this.csrfHash = tokenHash;
            body.dataset.bgCsrfTokenName = tokenName;
            body.dataset.bgCsrfHash = tokenHash;
            this.syncAllPostForms();
        },

        showFlash() {
            // Silent UI directive
        },

        /* ==================================================================
           3. SESSION IDLE WATCHER & KEEP-ALIVE
           ================================================================== */
        resetIdleTimer() {
            if (!this.idleTimeoutSeconds || !this.idleLogoutUrl) return;

            if (this.idleWarningTimer) window.clearTimeout(this.idleWarningTimer);
            if (this.idleCountdownTimer) {
                window.clearInterval(this.idleCountdownTimer);
                this.idleCountdownTimer = null;
            }

            this.hideSessionWarning();
            this.idleDeadlineAt = Date.now() + (this.idleTimeoutSeconds * 1000);
            window.clearTimeout(this.idleTimer);
            this.idleTimer = window.setTimeout(() => {
                window.location.href = this.idleLogoutUrl;
            }, this.idleTimeoutSeconds * 1000);

            const warningDelay = Math.max(0, (this.idleTimeoutSeconds - this.idleWarningSeconds) * 1000);
            this.idleWarningTimer = window.setTimeout(() => {
                this.showSessionWarning();
            }, warningDelay);
        },

        startIdleWatcher() {
            if (!this.idleTimeoutSeconds) return;
            const activityEvents = ['mousedown', 'keydown', 'mousemove', 'scroll', 'touchstart'];
            const reset = () => this.resetIdleTimer();
            activityEvents.forEach((evt) => window.addEventListener(evt, reset, { passive: true }));
            this.resetIdleTimer();
        },

        showSessionWarning() {
            const modal = document.getElementById('sessionWarningModal');
            if (!modal) return;
            const countdownEl = modal.querySelector('.js-session-warning-countdown');
            modal.hidden = false;

            const renderCountdown = () => {
                const seconds = Math.max(0, Math.ceil((this.idleDeadlineAt - Date.now()) / 1000));
                if (countdownEl) countdownEl.textContent = String(seconds);
            };

            renderCountdown();
            if (this.idleCountdownTimer) window.clearInterval(this.idleCountdownTimer);
            this.idleCountdownTimer = window.setInterval(renderCountdown, 1000);
        },

        hideSessionWarning() {
            const modal = document.getElementById('sessionWarningModal');
            if (modal) modal.hidden = true;
        },

        async keepSessionAlive() {
            if (!this.keepAliveUrl) {
                this.resetIdleTimer();
                return;
            }

            const response = await fetch(this.keepAliveUrl, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json',
                },
            });

            if (!response.ok) throw new Error('Sesi sudah berakhir.');

            const payload = await response.json();
            if (payload && payload.csrfTokenName && payload.csrfHash) {
                this.updateCsrf(payload.csrfTokenName, payload.csrfHash);
            }

            this.resetIdleTimer();
        },

        /* ==================================================================
           4. FAST TOKENIZED ROSTER SEARCH (Pengganti pro-search-upgrade.js)
           ================================================================== */
        initRosterSearch() {
            const shell = document.querySelector('.js-roster-search-shell');
            if (!shell) return;

            const input = shell.querySelector('.js-roster-search-input');
            const clearButton = shell.querySelector('.js-roster-search-clear');
            const meta = shell.querySelector('.js-roster-search-meta');
            const emptyState = document.querySelector('.js-roster-search-empty');
            const rows = Array.from(document.querySelectorAll('[data-roster-row]'));

            if (!rows.length || !input) return;

            const indexedRows = rows.map((row) => {
                const raw = String(row.dataset.searchText || '').toLowerCase().trim();
                return {
                    row,
                    raw,
                    tokens: raw.split(/\s+/).map((t) => t.trim()).filter(Boolean),
                };
            });

            const totalRows = indexedRows.length;
            const normalize = (val) => String(val || '').toLowerCase().replace(/[^\w\s]/g, ' ').replace(/\s+/g, ' ').trim();

            const renderSearch = () => {
                const keyword = normalize(input.value);
                if (keyword === '') {
                    indexedRows.forEach(({ row }) => { row.hidden = false; });
                    if (meta) meta.textContent = `${totalRows} team`;
                    if (emptyState) emptyState.classList.add('d-none');
                    return;
                }

                const terms = keyword.split(' ').filter(Boolean);
                let visibleCount = 0;

                indexedRows.forEach((item) => {
                    const matched = terms.every((term) => item.raw.includes(term) || item.tokens.some((tok) => tok.startsWith(term)));
                    item.row.hidden = !matched;
                    if (matched) visibleCount++;
                });

                if (meta) {
                    meta.textContent = visibleCount > 0 ? `${visibleCount} hasil ditemukan` : 'Tidak ada hasil';
                }
                if (emptyState) {
                    emptyState.classList.toggle('d-none', visibleCount > 0);
                }
            };

            let timer = null;
            input.addEventListener('input', () => {
                clearTimeout(timer);
                timer = setTimeout(() => window.requestAnimationFrame(renderSearch), 100);
            });

            input.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    input.value = '';
                    renderSearch();
                }
            });

            if (clearButton) {
                clearButton.addEventListener('click', () => {
                    input.value = '';
                    renderSearch();
                    input.focus();
                });
            }

            renderSearch();
        }
    };

    window.BGApp = BGApp;

    document.addEventListener('DOMContentLoaded', () => {
        BGApp.initSidebarDrawer();
        BGApp.syncAllPostForms();
        BGApp.startIdleWatcher();
        BGApp.initRosterSearch();

        const warningModal = document.getElementById('sessionWarningModal');
        const keepaliveButton = warningModal ? warningModal.querySelector('.js-session-warning-keepalive') : null;
        const logoutButton = warningModal ? warningModal.querySelector('.js-session-warning-logout') : null;

        if (keepaliveButton) {
            keepaliveButton.addEventListener('click', async () => {
                try {
                    await BGApp.keepSessionAlive();
                } catch (error) {
                    window.location.href = BGApp.idleLogoutUrl;
                }
            });
        }

        if (logoutButton) {
            logoutButton.addEventListener('click', () => {
                window.location.href = BGApp.idleLogoutUrl;
            });
        }
    });

    document.addEventListener('submit', (event) => {
        const form = event.target;
        if (!(form instanceof HTMLFormElement)) return;

        const message = form.getAttribute('data-confirm');
        if (message && window.confirm(message) === false) {
            event.preventDefault();
            return;
        }

        const method = (form.getAttribute('method') || 'get').toLowerCase();
        if (method === 'post') {
            BGApp.ensureFormCsrf(form);
        }
    }, true);

    document.addEventListener('click', (event) => {
        const button = event.target instanceof Element ? event.target.closest('[data-confirm-click]') : null;
        if (!button) return;

        const message = button.getAttribute('data-confirm-click') || 'Lanjutkan aksi ini?';
        if (window.confirm(message) === false) {
            event.preventDefault();
            event.stopPropagation();
        }
    }, true);
})();