// Konteks: Kalkulator v2 dengan Multiplier Kill & Custom Placement Poin
(function () {
    const app = window.BGApp || {};
    let mutationRequestChain = Promise.resolve();

    const qs = (selector, scope = document) => scope.querySelector(selector);
    const qsa = (selector, scope = document) => Array.from(scope.querySelectorAll(selector));
    const managerLookupCache = new Map();
    const escapeHtml = (value) => String(value ?? '').replace(/[&<>"']/g, (char) => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;',
    }[char] || char));

    const showFlash = (message, type = 'success') => {
        if (message && typeof app.showFlash === 'function') {
            app.showFlash(message, type);
        }
    };

    const updateCsrf = (payload) => {
        if (!payload || typeof app.updateCsrf !== 'function') {
            return;
        }

        if (payload.csrfTokenName && payload.csrfHash) {
            app.updateCsrf(payload.csrfTokenName, payload.csrfHash);
        }
    };

    const refreshRequestCsrf = (options = {}) => {
        if (options.body instanceof FormData) {
            ensureFormDataCsrf(options.body);
        }
    };

    const runRequest = async (url, options = {}) => {
        refreshRequestCsrf(options);

        const response = await fetch(url, {
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json',
                ...(options.headers || {}),
            },
            ...options,
        });

        const contentType = response.headers.get('content-type') || '';
        const isJson = contentType.includes('application/json');
        const payload = isJson ? await response.json() : null;

        updateCsrf(payload);

        if (!response.ok) {
            const message = payload?.message || 'Terjadi kesalahan saat memproses request.';
            throw new Error(message);
        }

        return payload || { status: 'success', message: 'Berhasil diproses.' };
    };

    const request = async (url, options = {}) => {
        const method = String(options.method || 'GET').toUpperCase();
        if (method === 'GET') {
            return runRequest(url, options);
        }

        const execute = async () => runRequest(url, options);
        const queued = mutationRequestChain.then(execute, execute);

        mutationRequestChain = queued.then(
            () => undefined,
            () => undefined,
        );

        return queued;
    };

    const ensureFormDataCsrf = (formData) => {
        const tokenName = app.csrfTokenName || 'csrf_test_name';
        const tokenHash = app.csrfHash || '';

        try {
            formData.delete(tokenName);
        } catch (error) {
            // ignore
        }

        formData.append(tokenName, tokenHash);
    };

    const clearPendingScoreSaves = () => {
        qsa('.js-score-bulk-form').forEach((form) => {
            if (form._saveTimer) {
                clearTimeout(form._saveTimer);
                form._saveTimer = null;
            }
        });
    };

    const rememberScrollPosition = () => {
        try {
            sessionStorage.setItem('bgcalc-scroll-y', String(window.scrollY));
        } catch (error) {
            // ignore
        }
    };

    const bindScoreTextZoomControls = () => {
        const host = document.getElementById('scorePageHost');
        if (!host) {
            return;
        }

        const buttons = qsa('.js-score-text-zoom', host);
        if (!buttons.length) {
            return;
        }

        const storageKey = 'bgcalc-score-text-scale';
        const clampScale = (value) => Math.min(1.35, Math.max(0.9, value));
        const applyScale = (value) => {
            const safeValue = clampScale(value);
            host.style.setProperty('--score-page-scale', String(safeValue));

            try {
                localStorage.setItem(storageKey, String(safeValue));
            } catch (error) {
                // ignore
            }
        };

        let initialScale = 1;
        try {
            initialScale = clampScale(Number.parseFloat(localStorage.getItem(storageKey) || '1') || 1);
        } catch (error) {
            initialScale = 1;
        }

        applyScale(initialScale);

        buttons.forEach((button) => {
            if (button.dataset.zoomBound === '1') {
                return;
            }

            button.dataset.zoomBound = '1';
            button.addEventListener('click', () => {
                const currentScale = clampScale(Number.parseFloat(host.style.getPropertyValue('--score-page-scale') || '1') || 1);
                const action = button.dataset.zoomAction || '';

                if (action === 'increase') {
                    applyScale(currentScale + 0.08);
                    return;
                }

                if (action === 'decrease') {
                    applyScale(currentScale - 0.08);
                    return;
                }

                applyScale(1);
            });
        });
    };

    // LOGIKA PERHITUNGAN LIVE: PLACEMENT POINT
    const getPlacement = (placementMap, rank, pointSystem, customPointsRaw) => {
        if (!Number.isInteger(rank) || rank < 1) {
            return 0;
        }

        if (pointSystem === 'custom') {
            const pointsArr = (customPointsRaw || '').split(',').map(s => s.trim());
            const index = rank - 1;
            const val = parseInt(pointsArr[index], 10);
            return isNaN(val) ? 0 : val;
        }

        return Number(placementMap[String(rank)] ?? placementMap[rank] ?? 0);
    };

    // LOGIKA PERHITUNGAN LIVE: TOTAL POINT (Kill * Multiplier + Placement)
    const updateRowTotal = (row, placementMap, pointSystem, killMultiplier, customPointsRaw) => {
        let total = 0;

        qsa('[data-col-role="rank"]', row).forEach((rankCell) => {
            const gameNo = rankCell.dataset.gameCol;
            const rankInput = qs('input', rankCell);
            const killInput = qs('[data-col-role="kill"][data-game-col="' + gameNo + '"] input', row);
            const placementCell = qs('[data-col-role="placement"][data-game-col="' + gameNo + '"]', row);

            const rank = Number.parseInt(rankInput?.value || '', 10);
            const kill = Number.parseInt(killInput?.value || '', 10);
            
            const placement = getPlacement(placementMap, rank, pointSystem, customPointsRaw);

            if (placementCell) {
                placementCell.textContent = String(placement);
            }

            total += placement + ((Number.isNaN(kill) ? 0 : kill) * killMultiplier);
        });

        const totalCell = qs('.total-cell', row);
        if (totalCell) {
            totalCell.textContent = String(total);
        }
    };

    const updateAllRows = (table, placementMap, pointSystem, killMultiplier, customPointsRaw) => {
        qsa('tbody tr[data-team-row]', table).forEach((row) => {
            updateRowTotal(row, placementMap, pointSystem, killMultiplier, customPointsRaw);
        });
    };

    const getRowTotalValue = (row) => {
        const totalText = (qs('.total-cell', row)?.textContent || '0').trim();
        const total = Number.parseInt(totalText, 10);
        return Number.isNaN(total) ? 0 : total;
    };

    const sortRowsByTotal = (table) => {
        const tbody = qs('tbody', table);
        if (!tbody) {
            return;
        }

        const rows = qsa('tr[data-team-row]', tbody);
        if (rows.length < 2) {
            updateRowNumbers(table);
            return;
        }

        rows.sort((left, right) => {
            const totalDiff = getRowTotalValue(right) - getRowTotalValue(left);
            if (totalDiff !== 0) {
                return totalDiff;
            }

            const leftIsTemp = left.dataset.isTempTeam === '1' ? 1 : 0;
            const rightIsTemp = right.dataset.isTempTeam === '1' ? 1 : 0;
            if (leftIsTemp !== rightIsTemp) {
                return leftIsTemp - rightIsTemp;
            }

            const leftName = (qs('.team-name-input', left)?.value || '').trim();
            const rightName = (qs('.team-name-input', right)?.value || '').trim();
            if (leftName && rightName) {
                const nameDiff = leftName.localeCompare(rightName, undefined, { sensitivity: 'base' });
                if (nameDiff !== 0) {
                    return nameDiff;
                }
            }

            return 0;
        });

        rows.forEach((row) => tbody.appendChild(row));
        updateRowNumbers(table);
    };

    const updateRowNumbers = (table) => {
        qsa('tbody tr[data-team-row]', table).forEach((row, index) => {
            const numberCell = qs('.js-row-number', row) || qs('.score-no-col', row);
            if (numberCell) {
                numberCell.textContent = String(index + 1);
            }
        });
    };

    const updateCompactVars = (form) => {
        const host = form.closest('.pot-module-card') || form;
        const shell = qs('.score-table-shell', form);
        const gameCount = Number.parseInt(qs('.js-game-count', form)?.value || '1', 10);
        const safeGameCount = Number.isNaN(gameCount) ? 1 : Math.max(1, gameCount);
        const allowSideScroll = safeGameCount > 8;
        const teamWidth = allowSideScroll ? 136 : Math.max(136, 300 - ((safeGameCount - 1) * 24));
        const scoreWidth = allowSideScroll ? 40 : Math.max(40, 52 - ((safeGameCount - 1) * 2));
        const gameColWidth = allowSideScroll ? 40 : Math.max(40, 56 - ((safeGameCount - 1) * 2));
        const placementWidth = allowSideScroll ? 36 : Math.max(36, 46 - ((safeGameCount - 1) * 2));

        host.style.setProperty('--team-col-width', String(teamWidth) + 'px');
        host.style.setProperty('--score-col-width', String(scoreWidth) + 'px');
        host.style.setProperty('--game-col-width', String(gameColWidth) + 'px');
        host.style.setProperty('--placement-col-width', String(placementWidth) + 'px');

        if (shell) {
            shell.classList.toggle('is-scrollable', allowSideScroll);
        }
    };

    const getStatusEl = (form) => {
        const card = form.closest('.pot-module-card');
        return qs('.auto-save-status', card || document);
    };

    const setStatus = (form, state, message) => {
        const statusEl = getStatusEl(form);
        if (!statusEl) {
            return;
        }

        statusEl.dataset.state = state;
        statusEl.textContent = message;
    };

    const hasTeamRows = (form) => Boolean(qs('tr[data-team-row]', form));

    const getAssociatedField = (form, selector) => {
        if (!form?.id) {
            return null;
        }

        return document.querySelector(`${selector}[form="${form.id}"]`);
    };

    const savePotMeta = async (form) => {
        const url = form.dataset.potUpdateUrl;
        const potId = form.dataset.potId;
        const formData = new FormData();
        const potNameInput = getAssociatedField(form, 'input[name="pot_name"]');
        const potOrderInput = getAssociatedField(form, 'input[name="pot_sort_order"]');

        ensureFormDataCsrf(formData);
        formData.append('tournament_id', qs('input[name="tournament_id"]', form)?.value || '');
        formData.append('name', potNameInput?.value || '');
        formData.append('sort_order', potOrderInput?.value || '');
        formData.append('redirect_to', qs('input[name="redirect_to"]', form)?.value || window.location.href);

        if (!url || !potId) {
            return { status: 'success', message: 'Perubahan disimpan.' };
        }

        return request(url, {
            method: 'POST',
            body: formData,
        });
    };

    const syncPotHeadingPreview = (form) => {
        const titleInput = getAssociatedField(form, 'input[name="pot_name"]');
        const contextText = qs('.js-pot-context-text', form.closest('.pot-module-card') || document);
        const tournamentValue = contextText?.dataset.tournamentName || 'Tournament';
        const nextPotName = (titleInput?.value || '').trim() || 'Pot';

        if (contextText) {
            contextText.textContent = `${tournamentValue} / ${nextPotName}`;
        }
    };

    const saveBulk = async (form) => {
        const formData = new FormData(form);
        ensureFormDataCsrf(formData);

        const potNameInput = getAssociatedField(form, 'input[name="pot_name"]');
        const potOrderInput = getAssociatedField(form, 'input[name="pot_sort_order"]');
        if (potNameInput && potNameInput.value) {
            formData.append('pot_name', potNameInput.value);
        }
        if (potOrderInput && potOrderInput.value) {
            formData.append('pot_sort_order', potOrderInput.value);
        }

        return request(form.action, {
            method: 'POST',
            body: formData,
        });
    };

    const scheduleSave = (form, saver, timerKey = '_saveTimer', queueKey = 'saveQueued') => {
        if (form.dataset.canManage !== '1') {
            return;
        }

        clearTimeout(form[timerKey]);
        form.dataset[queueKey] = '1';
        setStatus(form, 'dirty', '');
        form[timerKey] = window.setTimeout(saver, 80);
    };

    const createHeadCell = (gameNo) => {
        const th = document.createElement('th');
        th.colSpan = 3;
        th.className = 'text-center game-group-head';
        th.dataset.gameGroup = String(gameNo);
        th.textContent = 'Game ' + gameNo;
        return th;
    };

    const createSubCell = (gameNo, role, label) => {
        const th = document.createElement('th');
        th.className = 'text-center game-subhead';
        th.dataset.gameCol = String(gameNo);
        th.dataset.colRole = role;
        th.textContent = label;
        return th;
    };

    const createInputCell = (teamId, gameNo, role) => {
        const td = document.createElement('td');
        td.dataset.gameCol = String(gameNo);
        td.dataset.colRole = role;

        if (role === 'placement') {
            td.className = 'score-placement-cell';
            td.textContent = '0';
            return td;
        }

        td.className = 'game-cell';

        const input = document.createElement('input');
        input.type = 'number';
        input.min = role === 'rank' ? '1' : '0';
        if (role === 'rank') {
            input.max = '12';
        }
        input.className = 'form-control form-control-sm score-input js-score-input';
        input.name = 'scores[' + teamId + '][' + gameNo + '][' + (role === 'rank' ? 'rank_no' : 'kill_point') + ']';

        td.appendChild(input);
        return td;
    };

    const createTempTeamRow = (form, teamKey, rowNumber) => {
        const gameCount = Number.parseInt(qs('.js-game-count', form)?.value || '1', 10);
        const tr = document.createElement('tr');
        tr.dataset.teamRow = '1';
        tr.dataset.teamId = teamKey;
        tr.dataset.potId = form.dataset.potId || '';
        tr.dataset.searchLabel = '';
        tr.dataset.searchPlayers = '';
        tr.dataset.isTempTeam = '1';

        const noCell = document.createElement('td');
        noCell.className = 'text-center score-no-col js-row-number';
        noCell.textContent = String(rowNumber);
        tr.appendChild(noCell);

        const teamCell = document.createElement('td');
        teamCell.className = 'score-team-col team-cell p-0';
        teamCell.innerHTML = `
            <div class="team-cell-inner">
                <div class="team-main-line">
                    <div class="team-manager-combobox-shell team-table-combobox-shell custom-dropdown-wrapper">
                        <input
                            type="text"
                            class="form-control form-control-sm fw-semibold team-name-input compact-input js-team-input js-table-team-name-input rounded-0"
                            name="team_names[${teamKey}]"
                            value=""
                            autocomplete="off"
                        >
                        <input type="hidden" name="team_row_state[${teamKey}]" value="new">
                        <div class="custom-dropdown-menu js-custom-dropdown js-table-team-dropdown"></div>
                    </div>
                </div>
            </div>
        `;
        tr.appendChild(teamCell);

        for (let gameNo = 1; gameNo <= gameCount; gameNo++) {
            tr.appendChild(createInputCell(teamKey, gameNo, 'rank'));
            tr.appendChild(createInputCell(teamKey, gameNo, 'placement'));
            tr.appendChild(createInputCell(teamKey, gameNo, 'kill'));
        }

        const qualifyCell = document.createElement('td');
        qualifyCell.className = 'qualify-cell controller-only';
        qualifyCell.innerHTML = `
            <input type="checkbox" class="form-check-input js-advance-team" value="" disabled>
        `;
        tr.appendChild(qualifyCell);

        const totalCell = document.createElement('td');
        totalCell.className = 'score-total-cell total-cell';
        totalCell.textContent = '0';
        tr.appendChild(totalCell);

        const actionCell = document.createElement('td');
        actionCell.className = 'team-row-actions controller-only';
        actionCell.innerHTML = `
            <button type="button" class="btn btn-outline-secondary btn-sm toolbar-btn js-remove-temp-team">Batal</button>
        `;
        tr.appendChild(actionCell);

        return tr;
    };

    const buildPotLookupIndex = (potCard) => {
        const rows = qsa('tr[data-team-row]', potCard);
        return rows.map((row) => {
            const teamNameInput =
                qs('.team-name-input', row) ||
                qs('.js-team-input', row) ||
                qs('input[name^="team_names["]', row);

            const teamName = (teamNameInput?.value || '').trim();
            const membersRaw = (row.dataset.searchPlayers || '').trim();
            const members = membersRaw
                .split(/\r?\n|,/)
                .map((item) => item.trim())
                .filter(Boolean);
            const label = (row.dataset.searchLabel || '').trim() || [teamName, members.join(', ')].filter(Boolean).join(', ');

            return {
                row,
                teamName,
                members,
                label,
            };
        });
    };

    const closeDropdown = (dropdownEl) => {
        if (!dropdownEl) return;
        dropdownEl.classList.remove('is-active', 'is-open');
        dropdownEl.style.display = 'none';
        qsa('.custom-dropdown-item.is-highlighted, .custom-combobox-item.is-active', dropdownEl).forEach((el) => {
            el.classList.remove('is-highlighted', 'is-active');
        });
    };

    const attachComboboxKeyboard = (input, dropdownEl, onSelect) => {
        if (!input || !dropdownEl) return;
        input.addEventListener('keydown', (e) => {
            if (!dropdownEl.classList.contains('is-active') && !dropdownEl.classList.contains('is-open')) {
                return;
            }
            const items = Array.from(qsa('.custom-dropdown-item, .custom-combobox-item', dropdownEl));
            if (!items.length) return;

            let activeIdx = items.findIndex((it) => it.classList.contains('is-highlighted') || it.classList.contains('is-active'));

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                if (activeIdx >= 0 && items[activeIdx]) items[activeIdx].classList.remove('is-highlighted', 'is-active');
                activeIdx = (activeIdx + 1) % items.length;
                items[activeIdx].classList.add('is-highlighted');
                items[activeIdx].scrollIntoView({ block: 'nearest' });
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                if (activeIdx >= 0 && items[activeIdx]) items[activeIdx].classList.remove('is-highlighted', 'is-active');
                activeIdx = (activeIdx - 1 + items.length) % items.length;
                items[activeIdx].classList.add('is-highlighted');
                items[activeIdx].scrollIntoView({ block: 'nearest' });
            } else if (e.key === 'Enter') {
                if (activeIdx >= 0 && items[activeIdx]) {
                    e.preventDefault();
                    const val = items[activeIdx].dataset.value;
                    if (typeof onSelect === 'function') {
                        onSelect(val);
                    }
                    closeDropdown(dropdownEl);
                }
            } else if (e.key === 'Escape') {
                e.preventDefault();
                closeDropdown(dropdownEl);
            }
        });
    };

    const fillLookupDropdown = (dropdownEl, items, onSelect) => {
        if (!dropdownEl) {
            return;
        }

        dropdownEl.innerHTML = '';

        if (!items || items.length === 0) {
            dropdownEl.innerHTML = '<div class="custom-dropdown-empty">Tidak ada hasil</div>';
            dropdownEl.classList.add('is-active', 'is-open');
            dropdownEl.style.display = 'block';
            return;
        }

        const seen = new Set();
        items.forEach((item) => {
            const teamTitle = (item.teamName || item.name || item.label || '').trim();
            const value = teamTitle;
            if (!value || seen.has(value.toLowerCase())) {
                return;
            }

            seen.add(value.toLowerCase());

            let metaText = '';
            if (Array.isArray(item.members) && item.members.length > 0) {
                metaText = item.members.join(', ');
            } else if (item.member_text) {
                metaText = item.member_text;
            } else if (item.search_text) {
                metaText = item.search_text;
            }

            const itemDiv = document.createElement('div');
            itemDiv.className = 'custom-dropdown-item';
            itemDiv.dataset.value = value;

            if (metaText) {
                itemDiv.innerHTML = `
                    <span class="rich-search-title">${escapeHtml(teamTitle)}</span>
                    <span class="rich-search-meta">${escapeHtml(metaText)}</span>
                `;
            } else {
                itemDiv.innerHTML = `
                    <span class="rich-search-title">${escapeHtml(teamTitle)}</span>
                `;
            }

            itemDiv.addEventListener('mousedown', (e) => {
                e.preventDefault();
                if (typeof onSelect === 'function') {
                    onSelect(value, item);
                }
            });
            dropdownEl.appendChild(itemDiv);
        });

        dropdownEl.classList.add('is-active', 'is-open');
        dropdownEl.style.display = 'block';
    };

    const fillLookupDatalist = fillLookupDropdown;

    const maybeFocusMatchedRow = (potCard, value) => {
        const keyword = (value || '').trim().toLowerCase();
        if (!keyword) {
            return;
        }

        const match = buildPotLookupIndex(potCard).find((item) => 
            (item.teamName || '').trim().toLowerCase() === keyword ||
            (item.label || '').trim().toLowerCase() === keyword ||
            (item.members || []).some((m) => m.trim().toLowerCase() === keyword)
        );
        if (!match?.row) {
            return;
        }

        match.row.scrollIntoView({
            behavior: 'smooth',
            block: 'nearest',
            inline: 'nearest',
        });

        match.row.classList.remove('row-highlight-flash');
        void match.row.offsetWidth;
        match.row.classList.add('row-highlight-flash');
    };

    const hideLookupBox = (box) => {
        if (!box) {
            return;
        }

        box.style.display = 'none';
        box.classList.remove('is-active', 'is-open');
        box.innerHTML = '';
    };

    const renderLookupBox = (box, items, emptyMessage = 'Tidak ada team yang cocok.') => {
        if (!box) {
            return;
        }

        if (!items.length) {
            box.innerHTML = `<div class="team-manager-combobox-empty">${escapeHtml(emptyMessage)}</div>`;
            box.style.display = 'block';
            box.classList.add('is-active', 'is-open');
            return;
        }

        box.innerHTML = items.map((team) => {
            const members = (team.member_text || '').trim();
            const meta = team.scope_label || 'Tanpa Pot';

            return `
                <button type="button" class="team-manager-combobox-item" data-team-id="${Number(team.id)}">
                    <span class="team-manager-combobox-title">${escapeHtml(team.name || '-')}</span>
                    <span class="team-manager-combobox-meta">${escapeHtml(meta)}</span>
                    <span class="team-manager-combobox-members">${escapeHtml(members || 'Belum ada member')}</span>
                </button>`;
        }).join('');

        box.style.display = 'block';
        box.classList.add('is-active', 'is-open');
    };

    const bindLookupBoxSelection = (box, teams, handler) => {
        if (!box) {
            return;
        }

        qsa('.team-manager-combobox-item', box).forEach((button) => {
            button.addEventListener('mousedown', (event) => {
                event.preventDefault();
            });

            button.addEventListener('click', async () => {
                const team = teams.find((item) => Number(item.id) === Number(button.dataset.teamId || '0'));
                if (!team) {
                    return;
                }

                await handler(team);
            });
        });
    };

    const fetchLookupTeams = async (tournamentId, potId = 0, force = false) => {
        const safeTournamentId = Number.parseInt(String(tournamentId || '0'), 10);
        if (!safeTournamentId) {
            return [];
        }

        const cacheKey = String(safeTournamentId);
        if (!force && managerLookupCache.has(cacheKey)) {
            return managerLookupCache.get(cacheKey) || [];
        }

        const params = new URLSearchParams();
        params.set('tournament_id', String(safeTournamentId));
        params.set('pot_id', String(Number.parseInt(String(potId || '0'), 10) || 0));

        const payload = await request(`${app.baseUrl}teams/manager-data?${params.toString()}`, { method: 'GET' });
        const lookupTeams = payload.lookupTeams || [];
        managerLookupCache.set(cacheKey, lookupTeams);
        return lookupTeams;
    };

    const bindLookupToolbars = () => {
        qsa('.pot-module-card').forEach((potCard) => {
            const universalInput = qs('.js-universal-lookup', potCard);
            const universalDropdown = qs('.js-universal-lookup-dropdown', potCard);

            const bindOne = (input, type, dropdownEl) => {
                if (!input || !dropdownEl || input.dataset.lookupBound === '1') {
                    return;
                }

                input.dataset.lookupBound = '1';

                let debounceTimer = null;
                const debouncedRun = () => {
                    clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        const keyword = (input.value || '').trim().toLowerCase();
                        const index = buildPotLookupIndex(potCard);

                        let matches = index;
                        if (keyword) {
                            if (type === 'universal') {
                                matches = index.filter((item) =>
                                    item.teamName.toLowerCase().includes(keyword) ||
                                    item.members.some((member) => member.toLowerCase().includes(keyword))
                                );
                            } else if (type === 'team') {
                                matches = index.filter((item) =>
                                    item.teamName.toLowerCase().includes(keyword)
                                );
                            } else {
                                matches = index.filter((item) =>
                                    item.members.some((member) => member.toLowerCase().includes(keyword))
                                );
                            }
                        }

                        fillLookupDropdown(dropdownEl, matches, (selectedValue) => {
                            input.value = selectedValue;
                            closeDropdown(dropdownEl);
                            maybeFocusMatchedRow(potCard, selectedValue);
                        });
                    }, 150); // 150ms debounce
                };

                input.addEventListener('input', debouncedRun);
                input.addEventListener('focus', debouncedRun);
                input.addEventListener('blur', () => {
                    setTimeout(() => closeDropdown(dropdownEl), 150);
                });
                attachComboboxKeyboard(input, dropdownEl, (selectedValue) => {
                    input.value = selectedValue;
                    closeDropdown(dropdownEl);
                    maybeFocusMatchedRow(potCard, selectedValue);
                });
                input.addEventListener('change', () => {
                    maybeFocusMatchedRow(potCard, input.value || '');
                });
            };

            if (universalInput && universalDropdown) {
                bindOne(universalInput, 'universal', universalDropdown);
            } else {
                // Fallback for older instances if any
                const teamInput = qs('.js-team-lookup', potCard);
                const teamDropdown = qs('.js-team-lookup-dropdown', potCard);
                if (teamInput && teamDropdown) bindOne(teamInput, 'team', teamDropdown);

                const playerInput = qs('.js-player-lookup', potCard);
                const playerDropdown = qs('.js-player-lookup-dropdown', potCard);
                if (playerInput && playerDropdown) bindOne(playerInput, 'player', playerDropdown);
            }
        });
    };

    const bindTeamManagerWorkspace = () => {
        qsa('.js-team-manager-workspace').forEach((workspace) => {
            if (workspace.dataset.managerBound === '1') {
                return;
            }

            workspace.dataset.managerBound = '1';

            const endpoint = workspace.dataset.endpoint || '';
            const createUrl = workspace.dataset.createUrl || '';
            const updateUrlBase = workspace.dataset.updateUrlBase || '';
            const deleteUrlBase = workspace.dataset.deleteUrlBase || '';
            const detachUrlBase = workspace.dataset.detachUrlBase || '';
            const canManage = workspace.dataset.canManage === '1';
            const allowUnassigned = workspace.dataset.allowUnassigned === '1';
            const managerContext = workspace.dataset.context || 'import';
            const currentTournamentId = Number.parseInt(workspace.dataset.currentTournamentId || '0', 10);
            const currentPotId = Number.parseInt(workspace.dataset.currentPotId || '0', 10);
            const fixedTournamentId = Number.parseInt(workspace.dataset.fixedTournamentId || workspace.dataset.selectedTournamentId || '0', 10);

            const tournamentSelect = qs('.js-manager-tournament', workspace);
            const potSelect = qs('.js-manager-pot', workspace);
            const listEl = qs('.js-manager-list', workspace);
            const countEl = qs('.js-manager-count', workspace);
            const currentScopeEl = qs('.js-manager-current-scope', workspace);
            const statusEl = qs('.js-manager-status', workspace);
            const modeEl = qs('.js-manager-mode', workspace);
            const teamIdInput = qs('.js-manager-team-id', workspace);
            const teamNameInput = qs('.js-manager-team-name', workspace);
            const memberTextInput = qs('.js-manager-member-text', workspace);
            const searchInput = qs('.js-manager-search', workspace);
            const searchCombobox = qs('.js-manager-search-combobox', workspace);
            const nameCombobox = qs('.js-manager-name-combobox', workspace);
            const resetButtons = qsa('.js-manager-reset', workspace);
            const submitButton = qs('.js-manager-submit', workspace);
            const deleteButton = qs('.js-manager-delete', workspace);

            const state = {
                teams: [],
                lookupTeams: [],
                activeTeamId: 0,
                query: '',
            };

            const getSelectedTournamentId = () => {
                const selectedValue = tournamentSelect?.value || '';
                const parsed = Number.parseInt(selectedValue || String(fixedTournamentId || 0), 10);
                return Number.isNaN(parsed) ? 0 : parsed;
            };

            const setStatus = (message, status = 'idle') => {
                if (!statusEl) {
                    return;
                }

                statusEl.dataset.state = status;
                statusEl.textContent = message || '';
            };

            const syncEditorState = () => {
                const isEditing = state.activeTeamId > 0;
                const isLoading = workspace.dataset.loading === '1';

                if (modeEl) {
                    modeEl.textContent = isEditing ? 'Mode edit team terpilih' : 'Mode tambah team baru';
                }

                if (submitButton) {
                    submitButton.textContent = isEditing ? 'Simpan Perubahan' : 'Tambah Team';
                    submitButton.disabled = !canManage || isLoading;
                }

                if (deleteButton) {
                    deleteButton.disabled = !canManage || !isEditing || isLoading;
                }
            };

            const setLoading = (loading) => {
                workspace.dataset.loading = loading ? '1' : '0';

                [tournamentSelect, potSelect, teamNameInput, memberTextInput, searchInput, ...resetButtons]
                    .filter(Boolean)
                    .forEach((el) => {
                        const isEditorControl = el === teamNameInput || el === memberTextInput || resetButtons.includes(el);
                        if (!canManage && isEditorControl) {
                            return;
                        }

                        if (loading) {
                            el.setAttribute('disabled', 'disabled');
                        } else if (canManage || !isEditorControl) {
                            el.removeAttribute('disabled');
                        }
                    });

                syncEditorState();
            };

            const fillPotOptions = (pots, selectedPotId) => {
                if (!potSelect) {
                    return;
                }

                potSelect.innerHTML = allowUnassigned
                    ? '<option value="">Tanpa Pot (database only)</option>'
                    : '<option value="">Pilih pot</option>';
                pots.forEach((pot) => {
                    const option = document.createElement('option');
                    option.value = String(pot.id);
                    option.textContent = pot.name;
                    option.selected = Number(pot.id) === Number(selectedPotId);
                    potSelect.appendChild(option);
                });
            };

            const hideCombobox = (box) => {
                if (!box) {
                    return;
                }

                box.style.display = 'none';
                box.classList.remove('is-active', 'is-open');
                box.innerHTML = '';
            };

            const getLookupMatches = (keyword, mode = 'all') => {
                const normalized = (keyword || '').trim().toLowerCase();
                if (!normalized) {
                    return [];
                }

                return state.lookupTeams
                    .filter((team) => {
                        const searchText = (team.search_text || '').toLowerCase();
                        if (!searchText.includes(normalized)) {
                            return false;
                        }

                        if (mode === 'name') {
                            return (team.name || '').toLowerCase().includes(normalized);
                        }

                        return true;
                    })
                    .slice(0, 8);
            };

            const renderCombobox = (box, items, emptyMessage = 'Tidak ada team yang cocok.') => {
                if (!box) {
                    return;
                }

                if (!items.length) {
                    box.innerHTML = `<div class="team-manager-combobox-empty">${escapeHtml(emptyMessage)}</div>`;
                    box.style.display = 'block';
                    box.classList.add('is-active', 'is-open');
                    return;
                }

                box.innerHTML = items.map((team) => {
                    const members = (team.member_text || '').trim();
                    const meta = team.scope_label || 'Tanpa Pot';

                    return `
                        <button type="button" class="team-manager-combobox-item" data-team-id="${Number(team.id)}">
                            <span class="team-manager-combobox-title">${escapeHtml(team.name || '-')}</span>
                            <span class="team-manager-combobox-meta">${escapeHtml(meta)}</span>
                            <span class="team-manager-combobox-members">${escapeHtml(members || 'Belum ada member')}</span>
                        </button>`;
                }).join('');

                box.style.display = 'block';
                box.classList.add('is-active', 'is-open');
            };

            const bindComboboxSelection = (box, handler) => {
                if (!box) {
                    return;
                }

                qsa('.team-manager-combobox-item', box).forEach((button) => {
                    button.addEventListener('mousedown', (event) => {
                        event.preventDefault();
                    });

                    button.addEventListener('click', async () => {
                        const team = state.lookupTeams.find((item) => Number(item.id) === Number(button.dataset.teamId || '0'));
                        if (!team) {
                            return;
                        }

                        await handler(team);
                    });
                });
            };

            const getFilteredTeams = () => {
                const keyword = (state.query || '').trim().toLowerCase();
                if (!keyword) {
                    return state.teams;
                }

                return state.teams.filter((team) => {
                    const haystack = [team.name, team.member_text, (team.members || []).join(', ')].join(' ').toLowerCase();
                    return haystack.includes(keyword);
                });
            };

            const clearSelectionStyles = () => {
                qsa('.team-manager-list-item', workspace).forEach((item) => item.classList.remove('is-active'));
            };

            const resetEditor = ({ keepStatus = false } = {}) => {
                state.activeTeamId = 0;

                if (teamIdInput) teamIdInput.value = '';
                if (teamNameInput) teamNameInput.value = '';
                if (memberTextInput) memberTextInput.value = '';

                clearSelectionStyles();
                syncEditorState();

                if (!keepStatus) {
                    if (allowUnassigned && (potSelect?.value || '') === '') {
                        setStatus('Mode semua team tournament aktif. Anda bisa tambah team tanpa pot atau kelola semua team yang sudah ada.', 'idle');
                    } else {
                        setStatus(potSelect?.value ? 'Siap tambah team baru di pot ini.' : 'Pilih pot untuk mulai.', 'idle');
                    }
                }
            };

            const fillEditor = (team) => {
                if (!team) {
                    resetEditor();
                    return;
                }

                state.activeTeamId = Number(team.id);

                if (teamIdInput) teamIdInput.value = String(team.id);
                if (teamNameInput) teamNameInput.value = team.name || '';
                if (memberTextInput) memberTextInput.value = team.member_text || '';

                qsa('.team-manager-list-item', workspace).forEach((item) => {
                    item.classList.toggle('is-active', Number(item.dataset.teamId || '0') === Number(team.id));
                });

                syncEditorState();
                setStatus(`Mode edit aktif untuk ${team.name || 'team terpilih'}.`, 'info');
            };

            const renderList = () => {
                if (!listEl) {
                    return;
                }

                const filteredTeams = getFilteredTeams();

                if (countEl) {
                    countEl.textContent = state.teams.length === filteredTeams.length ? `${state.teams.length} team` : `${filteredTeams.length} / ${state.teams.length} team`;
                }

                if (currentScopeEl) {
                    const potValue = (potSelect?.value || '').trim();
                    if (allowUnassigned && potValue === '') {
                        currentScopeEl.textContent = 'Semua team tournament / database only';
                    } else {
                        const isCurrentScope = getSelectedTournamentId() === currentTournamentId && Number.parseInt(potValue || '0', 10) === currentPotId;
                        currentScopeEl.textContent = isCurrentScope ? 'Pot yang sedang ditampilkan' : 'Pot lain / mode global';
                    }
                }

                if (!filteredTeams.length) {
                    const emptyMessage = state.teams.length
                        ? 'Tidak ada team yang cocok dengan pencarian.'
                        : (allowUnassigned && (potSelect?.value || '') === '')
                            ? 'Belum ada team dalam tournament ini.'
                            : 'Belum ada team di pot ini.';
                    listEl.innerHTML = `<div class="team-manager-empty">${emptyMessage}</div>`;
                    if (!state.teams.length) {
                        clearSelectionStyles();
                    }
                    return;
                }

                listEl.innerHTML = filteredTeams.map((team) => {
                    const preview = team.member_text || 'Belum ada member';
                    const scopeLabel = (team.scope_label || '').trim();

                    return `
                        <button type="button" class="team-manager-list-item${Number(team.id) === Number(state.activeTeamId) ? ' is-active' : ''}" data-team-id="${team.id}">
                            <span class="team-manager-list-top">
                                <span class="team-manager-list-name">${escapeHtml(team.name || '-')}</span>
                                <span class="team-manager-list-order">#${Number(team.sort_order || 0)}</span>
                            </span>
                            <span class="team-manager-list-meta">
                                <span>${escapeHtml(scopeLabel || 'Tanpa Pot')}</span>
                                <span>${Number(team.member_count || 0)} member</span>
                                <span>${Number(team.games_played || 0)} game</span>
                                <span>${Number(team.total_score || 0)} pts</span>
                            </span>
                            <span class="team-manager-list-preview">${escapeHtml(preview)}</span>
                        </button>`;
                }).join('');

                qsa('.team-manager-list-item', listEl).forEach((button) => {
                    button.addEventListener('click', () => {
                        const team = state.teams.find((item) => Number(item.id) === Number(button.dataset.teamId || '0'));
                        fillEditor(team || null);
                    });
                });
            };

            const attachLookupTeamToCurrentPot = async (team) => {
                const rawPotValue = (potSelect?.value || '').trim();
                const potId = Number.parseInt(rawPotValue || '0', 10);
                if (!potId) {
                    fillEditor(team);
                    setStatus('Team dipilih. Pilih pot jika ingin langsung memasukkannya ke tabel team.', 'info');
                    return;
                }

                const formData = new FormData();
                ensureFormDataCsrf(formData);
                formData.append('pot_id', String(potId));
                formData.append('tournament_id', String(getSelectedTournamentId()));
                formData.append('name', team.name || '');
                formData.append('member_text', team.member_text || '');
                formData.append('redirect_to', window.location.href);
                formData.append('manager_context', managerContext);

                setLoading(true);
                setStatus(`Memasukkan ${team.name || 'team'} ke pot aktif...`, 'pending');

                try {
                    const payload = await request(updateUrlBase.replace(/\/$/, '') + '/' + team.id, {
                        method: 'POST',
                        body: formData,
                    });

                    const touchesCurrentScorePage = managerContext === 'score' && potId === currentPotId;
                    if (touchesCurrentScorePage) {
                        rememberScrollPosition();
                        setStatus(payload?.message || 'Team berhasil dimasukkan ke pot aktif.', 'success');
                        window.setTimeout(() => {
                            window.location.reload();
                        }, 120);
                        return;
                    }

                    await loadData({
                        keepSelection: true,
                        preferredTeamId: Number(team.id),
                    });

                    setStatus(payload?.message || 'Team berhasil dimasukkan ke pot aktif.', 'success');
                    syncScoreViews();
                } catch (error) {
                    setStatus(error.message || 'Gagal memasukkan team ke pot aktif.', 'error');
                } finally {
                    setLoading(false);
                }
            };

            const applyLookupTeam = async (team, source = 'search') => {
                hideCombobox(searchCombobox);
                hideCombobox(nameCombobox);

                if (searchInput && source === 'search') {
                    searchInput.value = team.name || '';
                }

                if (teamNameInput && source === 'name') {
                    teamNameInput.value = team.name || '';
                }

                const rawPotValue = (potSelect?.value || '').trim();
                const currentSelectedPotId = Number.parseInt(rawPotValue || '0', 10);
                const currentTournamentValue = getSelectedTournamentId();
                const teamPotId = team.pot_id === null ? null : Number(team.pot_id);
                const teamTournamentId = team.tournament_id === null ? null : Number(team.tournament_id);
                const isUnassignedTeam = teamPotId === null;
                const isCurrentScope = allowUnassigned && rawPotValue === ''
                    ? isUnassignedTeam
                    : teamPotId !== null && currentSelectedPotId === teamPotId;

                if (isCurrentScope) {
                    const currentTeam = state.teams.find((item) => Number(item.id) === Number(team.id));
                    fillEditor(currentTeam || team);
                    setStatus(`Team ${team.name || ''} ditemukan di scope ini.`, 'info');
                    return;
                }

                if (isUnassignedTeam && currentSelectedPotId > 0 && canManage) {
                    await attachLookupTeamToCurrentPot(team);
                    return;
                }

                if (teamTournamentId !== null && tournamentSelect && currentTournamentValue !== teamTournamentId) {
                    tournamentSelect.value = String(teamTournamentId);
                }

                if (teamPotId !== null && potSelect) {
                    potSelect.value = String(teamPotId);
                    await loadData({
                        keepSelection: true,
                        preferredTeamId: Number(team.id),
                    });
                    setStatus(`Team ${team.name || ''} ditemukan di pot ${team.scope_label || 'lain'}.`, 'info');
                    return;
                }

                fillEditor(team);
                setStatus(`Team ${team.name || ''} dipilih dari database.`, 'info');
            };

            const syncScoreViews = () => {
                bindLookupToolbars();
                if (typeof window.initScoreWorkspace === 'function') {
                    window.initScoreWorkspace();
                }
            };

            const loadData = async ({ keepSelection = false, preferredTeamId = 0 } = {}) => {
                if (!endpoint) {
                    return;
                }

                const previousTeamId = preferredTeamId || (keepSelection ? state.activeTeamId : 0);
                const params = new URLSearchParams();

                const selectedTournamentId = getSelectedTournamentId();
                if (selectedTournamentId > 0) params.set('tournament_id', String(selectedTournamentId));
                if (potSelect) params.set('pot_id', potSelect.value || '');
                if (allowUnassigned && (potSelect?.value || '') === '') params.set('pot_scope', 'unassigned');

                setLoading(true);
                setStatus('Memuat data team...', 'pending');

                try {
                    const payload = await request(endpoint + '?' + params.toString(), { method: 'GET' });

                    updateCsrf(payload);

                    if (tournamentSelect && payload.selectedTournamentId) {
                        tournamentSelect.value = String(payload.selectedTournamentId);
                    }

                    fillPotOptions(payload.pots || [], payload.selectedPotId || 0);

                    if (potSelect && payload.selectedPotId) {
                        potSelect.value = String(payload.selectedPotId);
                    }

                    state.teams = payload.teams || [];
                    state.lookupTeams = payload.lookupTeams || [];
                    renderList();

                    const selectedTeam = state.teams.find((team) => Number(team.id) === Number(previousTeamId));
                    if (selectedTeam) {
                        fillEditor(selectedTeam);
                    } else {
                        resetEditor({ keepStatus: true });
                    }

                    if (allowUnassigned && (potSelect?.value || '') === '') {
                        setStatus(
                            state.teams.length === 0
                                ? 'Belum ada team dalam tournament ini. Silakan tambah team baru.'
                                : `Memuat ${state.teams.length} team dari semua pot dan database tournament ini.`,
                            'idle'
                        );
                    } else if (!potSelect?.value) {
                        setStatus('Pilih pot untuk mulai.', 'idle');
                    } else if (state.teams.length === 0) {
                        setStatus('Belum ada team di pot ini. Silakan tambah team baru.', 'idle');
                    } else if (!selectedTeam) {
                        setStatus(`Memuat ${state.teams.length} team di pot ini. Pilih satu untuk edit atau tambah team baru.`, 'idle');
                    }
                } catch (error) {
                    state.teams = [];
                    state.lookupTeams = [];
                    if (listEl) {
                        listEl.innerHTML = '<div class="team-manager-empty">Gagal memuat team manager.</div>';
                    }
                    resetEditor({ keepStatus: true });
                    setStatus(error.message || 'Gagal memuat team manager.', 'error');
                } finally {
                    setLoading(false);
                }
            };

            const submitManagerAction = async (action) => {
                const selectedTournamentId = getSelectedTournamentId();
                const rawPotValue = (potSelect?.value || '').trim();
                const potId = Number.parseInt(rawPotValue || '0', 10);
                const teamId = Number.parseInt(teamIdInput?.value || '0', 10);
                const teamName = (teamNameInput?.value || '').trim();
                const memberText = (memberTextInput?.value || '').trim();
                const hasPot = rawPotValue !== '' && !Number.isNaN(potId) && potId > 0;

                if (!allowUnassigned && !hasPot) {
                    setStatus('Pilih pot terlebih dahulu.', 'error');
                    potSelect?.focus();
                    return;
                }

                if (action === 'delete' && !teamId) {
                    setStatus('Pilih team dari daftar terlebih dahulu.', 'error');
                    return;
                }

                let url = createUrl;
                if (action === 'update') {
                    url = updateUrlBase.replace(/\/$/, '') + '/' + teamId;
                } else if (action === 'delete') {
                    const deleteBase = managerContext === 'score' ? (detachUrlBase || deleteUrlBase) : deleteUrlBase;
                    url = deleteBase.replace(/\/$/, '') + '/' + teamId;
                }

                const formData = new FormData();
                ensureFormDataCsrf(formData);
                formData.append('tournament_id', String(selectedTournamentId > 0 ? selectedTournamentId : ''));
                formData.append('pot_id', hasPot ? String(potId) : '');
                formData.append('name', teamName);
                formData.append('member_text', memberText);
                formData.append('redirect_to', window.location.href);
                formData.append('manager_context', managerContext);

                setLoading(true);
                setStatus(
                    action === 'delete'
                        ? 'Menghapus team...'
                        : action === 'update'
                            ? 'Menyimpan perubahan team...'
                            : 'Menambahkan team...',
                    'pending'
                );

                try {
                    const payload = await request(url, { method: 'POST', body: formData });
                    const successMessage = payload?.message || (action === 'delete' ? 'Team berhasil dihapus.' : action === 'update' ? 'Team berhasil diperbarui.' : 'Team berhasil ditambahkan.');

                    const touchesCurrentScorePage = managerContext === 'score' && hasPot && selectedTournamentId === currentTournamentId && potId === currentPotId;
                    if (touchesCurrentScorePage) {
                        rememberScrollPosition();
                        setStatus(successMessage, 'success');
                        window.setTimeout(() => {
                            window.location.reload();
                        }, 120);
                        return;
                    }

                    const nextTeamId = action === 'delete' ? 0 : Number(payload?.teamId || teamId || 0);
                    if (action === 'delete') {
                        resetEditor({ keepStatus: true });
                    }

                    await loadData({
                        keepSelection: action !== 'delete',
                        preferredTeamId: nextTeamId,
                    });

                    setStatus(successMessage, 'success');
                    syncScoreViews();
                } catch (error) {
                    setStatus(error.message || 'Gagal memproses team manager.', 'error');
                } finally {
                    setLoading(false);
                }
            };

            tournamentSelect?.addEventListener('change', async () => {
                state.query = '';
                if (searchInput) searchInput.value = '';
                resetEditor({ keepStatus: true });
                if (potSelect) potSelect.value = '';
                await loadData();
            });

            potSelect?.addEventListener('change', async () => {
                state.query = '';
                if (searchInput) searchInput.value = '';
                resetEditor({ keepStatus: true });
                await loadData();
            });

            searchInput?.addEventListener('input', () => {
                state.query = searchInput.value || '';
                renderList();
                if (!String(searchInput.value || '').trim()) {
                    hideCombobox(searchCombobox);
                    return;
                }

                renderCombobox(searchCombobox, getLookupMatches(searchInput.value || '', 'all'));
                bindComboboxSelection(searchCombobox, async (team) => {
                    await applyLookupTeam(team, 'search');
                });
            });

            searchInput?.addEventListener('focus', () => {
                const matches = getLookupMatches(searchInput.value || '', 'all');
                if (matches.length) {
                    renderCombobox(searchCombobox, matches);
                    bindComboboxSelection(searchCombobox, async (team) => {
                        await applyLookupTeam(team, 'search');
                    });
                }
            });

            searchInput?.addEventListener('blur', () => {
                window.setTimeout(() => hideCombobox(searchCombobox), 120);
            });

            teamNameInput?.addEventListener('input', () => {
                const keyword = teamNameInput.value || '';
                if (!keyword.trim()) {
                    hideCombobox(nameCombobox);
                    return;
                }

                renderCombobox(nameCombobox, getLookupMatches(keyword, 'name'));
                bindComboboxSelection(nameCombobox, async (team) => {
                    await applyLookupTeam(team, 'name');
                });
            });

            teamNameInput?.addEventListener('focus', () => {
                const matches = getLookupMatches(teamNameInput.value || '', 'name');
                if (matches.length) {
                    renderCombobox(nameCombobox, matches);
                    bindComboboxSelection(nameCombobox, async (team) => {
                        await applyLookupTeam(team, 'name');
                    });
                }
            });

            teamNameInput?.addEventListener('blur', () => {
                window.setTimeout(() => hideCombobox(nameCombobox), 120);
            });

            resetButtons.forEach((button) => {
                button.addEventListener('click', () => {
                    resetEditor();
                    hideCombobox(searchCombobox);
                    hideCombobox(nameCombobox);
                    teamNameInput?.focus();
                });
            });

            submitButton?.addEventListener('click', async () => {
                await submitManagerAction(state.activeTeamId > 0 ? 'update' : 'create');
            });

            deleteButton?.addEventListener('click', async () => {
                const ok = await openDeleteConfirmPopup({
                    title: managerContext === 'score' ? 'Lepas Dari Pot' : 'Hapus Team',
                    message: managerContext === 'score'
                        ? 'Yakin ingin melepas team ini dari pot dan menghapus score terkait? Data team tetap tersimpan di database.'
                        : 'Yakin ingin menghapus team ini beserta score yang terkait?',
                    submitText: managerContext === 'score' ? 'Lepas' : 'Hapus',
                });

                if (!ok) {
                    return;
                }

                await submitManagerAction('delete');
            });

            loadData();
        });
    };

    const bindAddPotForms = () => {
        qsa('.js-add-pot-form').forEach((form) => {
            if (form.dataset.addPotBound === '1') {
                return;
            }

            form.dataset.addPotBound = '1';

            form.addEventListener('submit', async (event) => {
                event.preventDefault();

                if (form.dataset.submitting === '1') {
                    return;
                }

                const submitButton = event.submitter || qs('button[type="submit"]', form);
                const statusForm = qs('.js-score-bulk-form');
                form.dataset.submitting = '1';
                clearPendingScoreSaves();

                if (statusForm) {
                    setStatus(statusForm, 'saving', 'Membuat pot baru...');
                }

                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.dataset.originalText = submitButton.textContent;
                    submitButton.textContent = '...';
                }

                try {
                    const formData = new FormData(form);
                    const payload = await request(form.action, {
                        method: 'POST',
                        body: formData,
                    });

                    window.location.href = payload.redirectUrl || window.location.href;
                } catch (error) {
                    if (statusForm) {
                        setStatus(statusForm, 'error', error.message || 'Gagal menambahkan pot.');
                    }

                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.textContent = submitButton.dataset.originalText || 'Tambah Pot';
                    }

                    form.dataset.submitting = '0';
                }
            });
        });
    };

    const bindQuickAddTeamForms = () => {
        qsa('form[action*="teams/store"]').forEach((form) => {
            if (form.dataset.quickTeamBound === '1') {
                return;
            }

            form.dataset.quickTeamBound = '1';

            form.addEventListener('submit', async (event) => {
                event.preventDefault();

                if (form.dataset.submitting === '1') {
                    return;
                }

                const submitButton = event.submitter || qs('button[type="submit"]', form);

                form.dataset.submitting = '1';
                clearPendingScoreSaves();

                if (submitButton) {
                    submitButton.disabled = true;
                    submitButton.dataset.originalText = submitButton.textContent;
                    submitButton.textContent = '...';
                }

                try {
                    const formData = new FormData(form);
                    ensureFormDataCsrf(formData);

                    const payload = await request(form.action, {
                        method: 'POST',
                        body: formData,
                    });

                    window.setTimeout(() => {
                        window.location.href = payload.redirectUrl || window.location.href;
                    }, 100);
                } catch (error) {
                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.textContent = submitButton.dataset.originalText || 'Add Team';
                    }

                    form.dataset.submitting = '0';
                }
            });
        });
    };

    const bindFormInputs = (form) => {
        const table = qs('.score-table', form);
        const placementMap = JSON.parse(form.dataset.placementMap || '{}');
        
        // AMBIL DATA TURNAMEN UNTUK KALKULASI DINAMIS DARI FORM
        const pointSystem = form.dataset.pointSystem || 'ffws';
        const killMultiplier = Number.parseInt(form.dataset.killMultiplier || '1', 10) || 1;
        const customPointsRaw = form.dataset.customPoints || '';

        updateCompactVars(form);

        const saveNow = async (options = {}) => {
            if (form.dataset.canManage !== '1' || form.dataset.saving === '1') {
                if (form.dataset.saving === '1') {
                    form.dataset.saveQueued = '1';
                }

                return;
            }

            form.dataset.saving = '1';
            form.dataset.saveQueued = '0';
            setStatus(form, 'saving', '');

            try {
                const payload = hasTeamRows(form) ? await saveBulk(form) : await savePotMeta(form);
                const successMessage = payload.message || 'Perubahan berhasil disimpan.';
                setStatus(form, 'saved', (payload.reloadPage || options.showMessage) ? successMessage : '');

                if (payload.reloadPage) {
                    rememberScrollPosition();
                    window.setTimeout(() => {
                        window.location.reload();
                    }, 180);
                    return;
                }
            } catch (error) {
                setStatus(form, 'error', error.message || 'Gagal menyimpan perubahan.');
            } finally {
                form.dataset.saving = '0';

                if (form.dataset.saveQueued === '1') {
                    clearTimeout(form._saveTimer);
                    form._saveTimer = window.setTimeout(saveNow, 120);
                }
            }
        };

        form.addEventListener('bgcalc:save-now', async () => {
            if (form.dataset.canManage !== '1') {
                return;
            }

            if (form._saveTimer) {
                clearTimeout(form._saveTimer);
                form._saveTimer = null;
            }

            await saveNow({ showMessage: true });
        });

        const bindManualSaveButtons = () => {
            const card = form.closest('.pot-module-card') || document;
            qsa('.js-save-score-now', card)
                .filter((button) => button.getAttribute('form') === form.id)
                .forEach((button) => {
                    if (button.dataset.manualSaveBound === '1') {
                        return;
                    }

                    button.dataset.manualSaveBound = '1';
                    button.addEventListener('click', async (event) => {
                        event.preventDefault();

                        if (form.dataset.canManage !== '1') {
                            return;
                        }

                        if (typeof form.reportValidity === 'function' && !form.reportValidity()) {
                            return;
                        }

                        if (form._saveTimer) {
                            clearTimeout(form._saveTimer);
                            form._saveTimer = null;
                        }

                        const originalText = button.dataset.originalText || button.textContent || 'Simpan';
                        button.dataset.originalText = originalText;
                        button.disabled = true;
                        button.textContent = 'Menyimpan...';

                        try {
                            await saveNow({ showMessage: true });
                        } finally {
                            button.disabled = false;
                            button.textContent = button.dataset.originalText || 'Simpan';
                        }
                    });
                });
        };

        const bindClearScoreButtons = () => {
            const card = form.closest('.pot-module-card') || document;
            qsa('.js-clear-score-data', card).forEach((button) => {
                if (button.dataset.clearScoreBound === '1') {
                    return;
                }

                button.dataset.clearScoreBound = '1';
                button.addEventListener('click', async () => {
                    if (button.disabled || form.dataset.canManage !== '1') {
                        return;
                    }

                    const ok = await openDeleteConfirmPopup({
                        title: 'Clear Data Skor',
                        message: 'Kosongkan semua Rank dan Kill di pot ini? Team dan pot tetap disimpan.',
                        submitText: 'Clear Data',
                    });

                    if (!ok) {
                        return;
                    }

                    if (form._saveTimer) {
                        clearTimeout(form._saveTimer);
                        form._saveTimer = null;
                    }

                    const originalText = button.dataset.originalText || button.textContent || 'Clear Data';
                    button.dataset.originalText = originalText;
                    button.disabled = true;
                    button.textContent = '...';

                    try {
                        qsa('.js-score-input', form).forEach((input) => {
                            if (!input.disabled) {
                                input.value = '';
                            }
                        });

                        if (table) {
                            updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
                        }

                        await saveNow();
                    } finally {
                        button.disabled = false;
                        button.textContent = button.dataset.originalText || 'Clear Data';
                    }
                });
            });
        };

        const bindTableTeamNameComboboxes = () => {
            qsa('.js-table-team-name-input', form).forEach((input) => {
                if (input.dataset.tableLookupBound === '1') {
                    return;
                }

                input.dataset.tableLookupBound = '1';
                const shell = input.closest('.custom-dropdown-wrapper') || input.closest('.team-table-combobox-shell') || input.closest('.custom-combobox-wrapper');
                const dropdownEl = qs('.js-table-team-dropdown', shell) || qs('.js-custom-dropdown', shell);

                if (!dropdownEl) {
                    return;
                }

                const fillList = async () => {
                    const tournamentId = qs('input[name="tournament_id"]', form)?.value || '0';
                    const potId = form.dataset.potId || '0';

                    try {
                        const lookupTeams = await fetchLookupTeams(tournamentId, potId);
                        const keyword = (input.value || '').trim().toLowerCase();
                        const matches = lookupTeams
                            .filter((team) => !keyword || (team.name || '').toLowerCase().includes(keyword) || (team.search_text || '').includes(keyword))
                            .slice(0, 15);

                        fillLookupDropdown(dropdownEl, matches.map((t) => ({
                            teamName: t.name,
                            label: t.name,
                            members: t.members || [],
                            member_text: t.member_text || t.members_text || ''
                        })), (selectedValue) => {
                            input.value = selectedValue;
                            closeDropdown(dropdownEl);
                            form._saveNow = saveNow;
                            scheduleSave(form, saveNow);
                        });

                        return lookupTeams;
                    } catch (error) {
                        closeDropdown(dropdownEl);
                        return [];
                    }
                };

                let fillListTimer = null;
                const debouncedFillList = () => {
                    clearTimeout(fillListTimer);
                    fillListTimer = setTimeout(() => {
                        void fillList();
                    }, 150);
                };

                input.addEventListener('input', debouncedFillList);
                input.addEventListener('focus', debouncedFillList);

                input.addEventListener('blur', () => {
                    setTimeout(() => closeDropdown(dropdownEl), 150);
                });

                attachComboboxKeyboard(input, dropdownEl, (selectedValue) => {
                    input.value = selectedValue;
                    closeDropdown(dropdownEl);
                    form._saveNow = saveNow;
                    scheduleSave(form, saveNow);
                });

                input.addEventListener('change', async () => {
                    const tournamentId = qs('input[name="tournament_id"]', form)?.value || '0';
                    const potId = form.dataset.potId || '0';
                    const lookupTeams = await fetchLookupTeams(tournamentId, potId);
                    const typedValue = (input.value || '').trim().toLowerCase();
                    const exactMatch = lookupTeams.find((team) => (team.name || '').trim().toLowerCase() === typedValue);
                    if (exactMatch) {
                        input.value = exactMatch.name || '';
                    }

                    form._saveNow = saveNow;
                    scheduleSave(form, saveNow);
                });
            });
        };

        // EVENT DELEGATION: Bind input/change events at the form level instead of per-input
        if (form.dataset.inputBound !== '1') {
            form.dataset.inputBound = '1';

            const handleInputEvent = (e) => {
                const target = e.target;
                if (!target || target.tagName !== 'INPUT') return;
                
                if (target.classList.contains('js-score-input') || 
                    target.classList.contains('js-team-input') || 
                    target.classList.contains('js-member-input')) {
                    
                    const row = target.closest('tr[data-team-row]');
                    if (row) {
                        updateRowTotal(row, placementMap, pointSystem, killMultiplier, customPointsRaw);
                    }

                    if (target.classList.contains('team-name-input') || target.classList.contains('team-members-inline')) {
                        bindLookupToolbars();
                    }

                    form._saveNow = saveNow;
                    scheduleSave(form, saveNow);
                }
            };

            // Use 'input' event for live updates
            form.addEventListener('input', handleInputEvent);
            // Use 'change' event to capture auto-fills and browser changes
            form.addEventListener('change', handleInputEvent);
        }

        bindTableTeamNameComboboxes();
        bindManualSaveButtons();
        bindClearScoreButtons();

        const addGameButton = qs('.js-add-game', form.closest('.pot-module-card') || document);
        const removeGameButton = qs('.js-remove-game', form.closest('.pot-module-card') || document);
        const sortButton = qs('.js-sort-standings', form.closest('.pot-module-card') || document);
        const gameCountInput = qs('.js-game-count', form);

        if (table && sortButton && sortButton.dataset.sortBound !== '1') {
            sortButton.dataset.sortBound = '1';

            sortButton.addEventListener('click', () => {
                updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
                sortRowsByTotal(table);
                setStatus(form, 'saved', 'Klasemen sudah diurutkan berdasarkan total skor.');
            });
        }

        if (table && gameCountInput && addGameButton && addGameButton.dataset.gameBound !== '1') {
            addGameButton.dataset.gameBound = '1';

            addGameButton.addEventListener('click', () => {
                const nextGameNo = Number.parseInt(gameCountInput.value || '1', 10) + 1;
                const firstHeaderRow = qs('thead tr:first-child', table);
                const secondHeaderRow = qs('thead tr:nth-child(2)', table);
                const totalHead = qs('.js-total-head', firstHeaderRow);
                const qualifyHead = qs('.qualify-col', firstHeaderRow);
                const insertHeadBefore = qualifyHead || totalHead;

                if (!firstHeaderRow || !secondHeaderRow || !totalHead || !insertHeadBefore) {
                    return;
                }

                firstHeaderRow.insertBefore(createHeadCell(nextGameNo), insertHeadBefore);
                secondHeaderRow.appendChild(createSubCell(nextGameNo, 'rank', 'Rank'));
                secondHeaderRow.appendChild(createSubCell(nextGameNo, 'placement', 'P.Rank'));
                secondHeaderRow.appendChild(createSubCell(nextGameNo, 'kill', 'Kill'));

                qsa('tbody tr[data-team-row]', table).forEach((row) => {
                    const totalCell = qs('.score-total-cell', row);
                    const qualifyCell = qs('.qualify-cell', row);
                    const insertCellBefore = qualifyCell || totalCell;
                    const teamId = row.dataset.teamId;
                    if (!totalCell || !insertCellBefore || !teamId) {
                        return;
                    }

                    row.insertBefore(createInputCell(teamId, nextGameNo, 'rank'), insertCellBefore);
                    row.insertBefore(createInputCell(teamId, nextGameNo, 'placement'), insertCellBefore);
                    row.insertBefore(createInputCell(teamId, nextGameNo, 'kill'), insertCellBefore);
                });

                gameCountInput.value = String(nextGameNo);
                updateCompactVars(form);
                bindFormInputs(form);
                updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
                updateRowNumbers(table);
                form._saveNow = saveNow;
                scheduleSave(form, saveNow);
            });
        }

        if (table && gameCountInput && removeGameButton && removeGameButton.dataset.gameBound !== '1') {
            removeGameButton.dataset.gameBound = '1';

            removeGameButton.addEventListener('click', () => {
                const currentGameNo = Number.parseInt(gameCountInput.value || '1', 10);
                if (currentGameNo <= 1) {
                    return;
                }

                qs('[data-game-group="' + currentGameNo + '"]', table)?.remove();
                qsa('[data-game-col="' + currentGameNo + '"]', table).forEach((cell) => cell.remove());
                gameCountInput.value = String(currentGameNo - 1);
                updateCompactVars(form);
                updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
                updateRowNumbers(table);
                form._saveNow = saveNow;
                scheduleSave(form, saveNow);
            });
        }

        if (table) {
            updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
            updateRowNumbers(table);
        }
    };

    const bindLocalAddTeamButtons = () => {
        qsa('.js-add-team-row').forEach((button) => {
            if (button.dataset.localAddBound === '1') {
                return;
            }

            button.dataset.localAddBound = '1';

            button.addEventListener('click', () => {
                if (button.disabled) {
                    return;
                }

                const potCard = button.closest('.pot-module-card');
                const form = qs('.js-score-bulk-form', potCard || document);
                const table = qs('.score-table', form || document);
                const tbody = qs('tbody', table || document);
                if (!form || !table || !tbody) {
                    return;
                }

                const tempKey = `temp_${Date.now()}_${Math.random().toString(36).slice(2, 7)}`;
                const row = createTempTeamRow(form, tempKey, qsa('tr[data-team-row]', tbody).length + 1);
                tbody.appendChild(row);
                updateRowNumbers(table);
                bindFormInputs(form);
                bindLookupToolbars();
                
                // MENGAMBIL DATA UNTUK KALKULASI PADA ROW BARU
                const placementMap = JSON.parse(form.dataset.placementMap || '{}');
                const pointSystem = form.dataset.pointSystem || 'ffws';
                const killMultiplier = Number.parseInt(form.dataset.killMultiplier || '1', 10) || 1;
                const customPointsRaw = form.dataset.customPoints || '';
                updateAllRows(table, placementMap, pointSystem, killMultiplier, customPointsRaw);
                
                updateRowNumbers(table);

                const emptyState = qs('.js-pot-empty-state', form);
                window.setTimeout(() => {
                    form.dispatchEvent(new CustomEvent('bgcalc:save-now'));
                }, 60);
                if (emptyState) {
                    emptyState.hidden = true;
                }

                qs('.js-table-team-name-input', row)?.focus();

                qs('.js-remove-temp-team', row)?.addEventListener('click', () => {
                    row.remove();
                    updateRowNumbers(table);
                    const hasRows = qsa('tr[data-team-row]', tbody).length > 0;
                    if (!hasRows && emptyState) {
                        emptyState.hidden = false;
                    }
                });
            });
        });
    };

    const ensureDeleteConfirmPopup = () => {
        let overlay = document.getElementById('appDeleteConfirmOverlay');
        if (overlay) {
            return overlay;
        }

        overlay = document.createElement('div');
        overlay.id = 'appDeleteConfirmOverlay';
        overlay.className = 'app-confirm-overlay';
        overlay.hidden = true;

        overlay.innerHTML = `
            <div class="app-confirm-card" role="dialog" aria-modal="true" aria-labelledby="appConfirmTitle">
                <div class="app-confirm-head">
                    <div class="app-confirm-title" id="appConfirmTitle">Konfirmasi</div>
                </div>
                <div class="app-confirm-body" id="appConfirmMessage">
                    Yakin ingin melanjutkan?
                </div>
                <div class="app-confirm-actions">
                    <button type="button" class="btn btn-outline-secondary btn-sm app-confirm-cancel">Batal</button>
                    <button type="button" class="btn btn-danger btn-sm app-confirm-ok">Hapus</button>
                </div>
            </div>
        `;

        document.body.appendChild(overlay);

        overlay.addEventListener('click', (event) => {
            if (event.target === overlay) {
                overlay._resolver?.(false);
            }
        });

        qs('.app-confirm-cancel', overlay)?.addEventListener('click', () => {
            overlay._resolver?.(false);
        });

        qs('.app-confirm-ok', overlay)?.addEventListener('click', () => {
            overlay._resolver?.(true);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && overlay && !overlay.hidden) {
                overlay._resolver?.(false);
            }
        });

        return overlay;
    };

    const openDeleteConfirmPopup = ({ title, message, submitText }) => {
        const overlay = ensureDeleteConfirmPopup();
        const titleEl = qs('#appConfirmTitle', overlay);
        const messageEl = qs('#appConfirmMessage', overlay);
        const okBtn = qs('.app-confirm-ok', overlay);

        if (titleEl) titleEl.textContent = title || 'Konfirmasi';
        if (messageEl) messageEl.textContent = message || 'Yakin ingin melanjutkan?';
        if (okBtn) okBtn.textContent = submitText || 'Hapus';

        overlay.hidden = false;

        return new Promise((resolve) => {
            overlay._resolver = (result) => {
                overlay.hidden = true;
                overlay._resolver = null;
                resolve(Boolean(result));
            };
        });
    };

    const bindDeleteConfirmForms = () => {
        qsa('.js-confirm-delete-form').forEach((form) => {
            if (form.dataset.confirmBound === '1') {
                return;
            }

            form.dataset.confirmBound = '1';

            form.addEventListener('submit', async (event) => {
                if (form.dataset.confirmApproved === '1') {
                    form.dataset.confirmApproved = '0';
                    return;
                }

                event.preventDefault();

                const ok = await openDeleteConfirmPopup({
                    title: form.dataset.confirmTitle || 'Konfirmasi',
                    message: form.dataset.confirmMessage || 'Yakin ingin menghapus?',
                    submitText: form.dataset.confirmSubmit || 'Hapus',
                });

                if (!ok) {
                    return;
                }

                rememberScrollPosition();

                form.dataset.confirmApproved = '1';

                if (typeof form.requestSubmit === 'function') {
                    form.requestSubmit();
                } else {
                    form.submit();
                }
            });
        });
    };

    const bindInlineTeamDeleteButtons = () => {
        qsa('.js-inline-team-delete').forEach((button) => {
            if (button.dataset.deleteBound === '1') {
                return;
            }

            button.dataset.deleteBound = '1';

            button.addEventListener('click', async () => {
                const deleteUrl = button.dataset.deleteUrl || '';
                if (!deleteUrl || button.disabled) {
                    return;
                }

                const ok = await openDeleteConfirmPopup({
                    title: button.dataset.confirmTitle || 'Hapus Team',
                    message: button.dataset.confirmMessage || 'Yakin ingin menghapus team ini?',
                    submitText: button.dataset.confirmSubmit || 'Hapus',
                });

                if (!ok) {
                    return;
                }

                clearPendingScoreSaves();
                button.disabled = true;

                const formData = new FormData();
                ensureFormDataCsrf(formData);
                formData.append('redirect_to', window.location.href);
                formData.append('delete_mode', 'detach');
                formData.append('manager_context', 'score');

                try {
                    await request(deleteUrl, {
                        method: 'POST',
                        body: formData,
                    });

                    rememberScrollPosition();
                    window.location.reload();
                } catch (error) {
                    button.disabled = false;
                    showFlash(error.message || 'Gagal menghapus team.', 'error');
                }
            });
        });
    };

    const bindAdvanceSelectedButtons = () => {
        qsa('.js-advance-selected').forEach((button) => {
            if (button.dataset.advanceBound === '1') {
                return;
            }

            button.dataset.advanceBound = '1';

            button.addEventListener('click', async () => {
                if (button.disabled) {
                    return;
                }

                const potCard = button.closest('.pot-module-card');
                const form = qs('.js-score-bulk-form', potCard || document);
                const table = qs('.score-table', form || document);
                const advanceUrl = button.dataset.advanceUrl || form?.dataset.potAdvanceUrl || '';
                if (!form || !table || !advanceUrl) {
                    return;
                }

                const selectedCheckboxes = qsa('.js-advance-team:checked', table)
                    .filter((input) => !input.disabled && String(input.value || '').trim() !== '');

                if (!selectedCheckboxes.length) {
                    setStatus(form, 'error', 'Centang minimal satu team di kolom Lolos terlebih dahulu.');
                    return;
                }

                const ok = await openDeleteConfirmPopup({
                    title: 'Buat Pot Baru',
                    message: `${selectedCheckboxes.length} team tercentang akan dipindahkan ke pot baru. Lanjutkan?`,
                    submitText: 'Lanjut',
                });

                if (!ok) {
                    return;
                }

                clearPendingScoreSaves();
                button.disabled = true;
                setStatus(form, 'saved', 'Membuat pot baru dari team yang lolos...');

                const formData = new FormData();
                ensureFormDataCsrf(formData);
                selectedCheckboxes.forEach((input) => {
                    formData.append('team_ids[]', String(input.value));
                });
                formData.append('redirect_to', window.location.href);

                try {
                    const payload = await request(advanceUrl, {
                        method: 'POST',
                        body: formData,
                    });

                    window.location.href = payload.redirectUrl || window.location.href;
                } catch (error) {
                    button.disabled = false;
                    setStatus(form, 'error', error.message || 'Gagal membuat pot baru.');
                }
            });
        });
    };

    const restoreScrollAfterDelete = () => {
        try {
            const y = sessionStorage.getItem('bgcalc-scroll-y');
            if (!y) return;

            sessionStorage.removeItem('bgcalc-scroll-y');

            window.requestAnimationFrame(() => {
                window.scrollTo({
                    top: Number.parseInt(y, 10) || 0,
                    behavior: 'auto',
                });
            });
        } catch (error) {
            // ignore
        }
    };

    const bindManagerDrawer = () => {
        qsa('[data-team-manager-toggle]').forEach((toggle) => {
            if (toggle.dataset.drawerBound === '1') {
                return;
            }

            toggle.dataset.drawerBound = '1';

            const target = toggle.getAttribute('data-team-manager-toggle');
            const drawer = target ? document.getElementById(target) : null;
            const workspace = drawer?.closest('.score-page-workspace') || null;

            if (!drawer) {
                return;
            }

            const syncExpandedState = () => {
                if (workspace) {
                    const isOpen = workspace.classList.contains('is-manager-open');
                    drawer.hidden = !isOpen;
                    drawer.dataset.open = isOpen ? '1' : '0';
                    toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
                    return;
                }

                const isOpen = drawer.dataset.open === '1';
                drawer.hidden = !isOpen;
                toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            };

            syncExpandedState();

            toggle.addEventListener('click', () => {
                if (workspace) {
                    workspace.classList.toggle('is-manager-open');
                    syncExpandedState();
                    return;
                }

                const isOpen = drawer.dataset.open === '1';
                drawer.dataset.open = isOpen ? '0' : '1';
                syncExpandedState();
            });
        });

        qsa('[data-team-manager-close]').forEach((button) => {
            if (button.dataset.drawerCloseBound === '1') {
                return;
            }

            button.dataset.drawerCloseBound = '1';

            button.addEventListener('click', () => {
                const drawer = button.closest('.score-team-manager-panel, .team-manager-drawer');
                if (!drawer) {
                    return;
                }

                const workspace = drawer.closest('.score-page-workspace');
                if (workspace) {
                    workspace.classList.remove('is-manager-open');
                    drawer.hidden = true;
                    drawer.dataset.open = '0';
                    qsa(`[data-team-manager-toggle="${drawer.id}"]`).forEach((toggle) => {
                        toggle.setAttribute('aria-expanded', 'false');
                    });
                    return;
                }

                drawer.dataset.open = '0';
                drawer.hidden = true;
            });
        });
    };

    const bindControllerVisibilityToggle = () => {
        const scorePage = document.getElementById('scorePageHost');
        if (!scorePage) {
            return;
        }

        const workspace = document.getElementById('scorePageWorkspace');
        const hideButtons = qsa('.js-hide-controller');
        const showButtons = qsa('.js-show-controller');
        const restoreButtons = qsa('.controller-restore-btn');
        const closeManagerPanel = () => {
            if (!workspace) {
                return;
            }

            workspace.classList.remove('is-manager-open');

            qsa('.score-team-manager-panel', workspace).forEach((drawer) => {
                drawer.hidden = true;
                drawer.dataset.open = '0';
            });

            qsa('[data-team-manager-toggle]', scorePage).forEach((toggle) => {
                toggle.setAttribute('aria-expanded', 'false');
            });
        };

        const hideController = () => {
            closeManagerPanel();
            scorePage.classList.add('is-controller-hidden');
            hideButtons.forEach((button) => button.hidden = true);
            showButtons.forEach((button) => button.hidden = false);
            restoreButtons.forEach((button) => button.hidden = false);

            try {
                sessionStorage.setItem('bgcalc-hide-controllers', '1');
            } catch (error) {
                // ignore
            }
        };

        const showController = () => {
            scorePage.classList.remove('is-controller-hidden');
            hideButtons.forEach((button) => button.hidden = false);
            showButtons.forEach((button) => button.hidden = true);
            restoreButtons.forEach((button) => button.hidden = true);

            try {
                sessionStorage.setItem('bgcalc-hide-controllers', '0');
            } catch (error) {
                // ignore
            }
        };

        let initialHidden = false;
        try {
            initialHidden = sessionStorage.getItem('bgcalc-hide-controllers') === '1';
        } catch (error) {
            initialHidden = false;
        }

        if (initialHidden) {
            hideController();
        } else {
            showController();
        }

        hideButtons.forEach((button) => {
            if (button.dataset.hideBound === '1') {
                return;
            }
            button.dataset.hideBound = '1';
            button.addEventListener('click', hideController);
        });

        showButtons.forEach((button) => {
            if (button.dataset.showBound === '1') {
                return;
            }
            button.dataset.showBound = '1';
            button.addEventListener('click', showController);
        });

        restoreButtons.forEach((button) => {
            if (button.dataset.restoreBound === '1') {
                return;
            }
            button.dataset.restoreBound = '1';
            button.addEventListener('click', showController);
        });
    };

    const bindPotMetaForms = () => {
        qsa('.js-pot-meta-form').forEach((metaForm) => {
            if (metaForm.dataset.metaBound === '1') {
                return;
            }

            metaForm.dataset.metaBound = '1';

            const card = metaForm.closest('.pot-module-card') || document;
            const bulkForm = qs('.js-score-bulk-form', card);
            if (!bulkForm) {
                return;
            }

            const formId = metaForm.id;
            const inputs = formId
                ? qsa(`[form="${formId}"].js-pot-input`)
                : [];

            inputs.forEach((input) => {
                if (input.dataset.potInputBound === '1') {
                    return;
                }

                input.dataset.potInputBound = '1';

                const handler = () => {
                    syncPotHeadingPreview(bulkForm);

                    if (bulkForm.dataset.canManage !== '1') {
                        return;
                    }

                    clearTimeout(bulkForm._metaSaveTimer);
                    setStatus(bulkForm, 'dirty', '');

                    bulkForm._metaSaveTimer = window.setTimeout(async () => {
                        try {
                            setStatus(bulkForm, 'saving', '');
                            const payload = await savePotMeta(bulkForm);
                            updateCsrf(payload);
                            setStatus(bulkForm, 'saved', payload?.message || 'Perubahan pot disimpan.');
                        } catch (error) {
                            setStatus(bulkForm, 'error', error.message || 'Gagal menyimpan perubahan pot.');
                        }
                    }, 300);
                };

                input.addEventListener('input', handler);
                input.addEventListener('change', handler);
            });
        });
    };

    const initScoreWorkspace = () => {
        console.log("Kalkulator v2 ACTIVE! JS Terbaru Berhasil Dimuat.");
        bindPotMetaForms();
        qsa('.js-score-bulk-form').forEach((form) => bindFormInputs(form));
        bindAddPotForms();
        bindQuickAddTeamForms();
        bindLocalAddTeamButtons();
        bindAdvanceSelectedButtons();
        bindDeleteConfirmForms();
        bindInlineTeamDeleteButtons();
        bindLookupToolbars();
        bindTeamManagerWorkspace();
        bindManagerDrawer();
        bindControllerVisibilityToggle();
        bindScoreTextZoomControls();
        restoreScrollAfterDelete();

        document.addEventListener('click', (e) => {
            if (!e.target.closest('.custom-dropdown-wrapper') && !e.target.closest('.custom-combobox-wrapper') && !e.target.closest('.team-manager-combobox-shell')) {
                qsa('.custom-dropdown-menu.is-active, .custom-dropdown-menu.is-open, .custom-combobox-dropdown.is-open, .custom-combobox-dropdown.is-active, .team-manager-combobox.is-active, .team-manager-combobox.is-open').forEach((dd) => {
                    closeDropdown(dd);
                });
            }
        });
    };

    
    window.addEventListener('beforeunload', () => {
        try {
            qsa('.js-score-bulk-form').forEach((form) => {
                if (form._saveTimer) {
                    clearTimeout(form._saveTimer);
                    form._saveTimer = null;
                }
            });
        } catch (error) {
            // ignore
        }
    });

    document.addEventListener('DOMContentLoaded', initScoreWorkspace);
    window.initScoreWorkspace = initScoreWorkspace;
})();