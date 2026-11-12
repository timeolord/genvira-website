document.documentElement.classList.add('js');

const menu_toggle = document.querySelector('.menu-toggle');
const site_navigation = document.querySelector('#site-navigation');
if (menu_toggle && site_navigation) {
    function close_menu() {
        menu_toggle.setAttribute('aria-expanded', 'false');
        site_navigation.classList.remove('is-open');
    }
    menu_toggle.addEventListener('click', () => {
        const expanded = menu_toggle.getAttribute('aria-expanded') !== 'true';
        menu_toggle.setAttribute('aria-expanded', String(expanded));
        site_navigation.classList.toggle('is-open', expanded);
    });
    document.addEventListener('keydown', event => {
        if (event.key === 'Escape' && menu_toggle.getAttribute('aria-expanded') === 'true') {
            close_menu();
            menu_toggle.focus();
        }
    });
    document.addEventListener('click', event => {
        if (!event.target.closest('.site-header')) close_menu();
    });
}

const platform = document.querySelector('[data-platform]');
if (platform) {
    const steps = [...platform.querySelectorAll('[data-step]')];
    const panels = [...platform.querySelectorAll('[data-panel]')];
    function choose_step(step) {
        steps.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.step === step)));
        panels.forEach(panel => { panel.hidden = panel.dataset.panel !== step; });
    }
    steps.forEach((button, index) => {
        button.addEventListener('click', () => choose_step(button.dataset.step));
        button.addEventListener('keydown', event => {
            if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;
            event.preventDefault();
            const next = event.key === 'Home' ? 0 : event.key === 'End' ? steps.length - 1 : (index + (event.key === 'ArrowRight' ? 1 : -1) + steps.length) % steps.length;
            steps[next].focus();
            choose_step(steps[next].dataset.step);
        });
    });
    choose_step('design');
}

const research_controls = document.querySelector('[data-research-controls]');
if (research_controls) {
    research_controls.hidden = false;
    const buttons = [...research_controls.querySelectorAll('[data-filter]')];
    const search = document.querySelector('#research-search');
    const entries = [...document.querySelectorAll('.research-archive .research-entry')];
    const status = document.querySelector('[data-filter-status]');
    const empty_results = document.querySelector('.empty-results');
    let active_filter = 'all';
    function filter_research() {
        const query = search.value.trim().toLocaleLowerCase();
        entries.forEach(entry => {
            entry.hidden = (active_filter !== 'all' && entry.dataset.kind !== active_filter) || !entry.textContent.toLocaleLowerCase().includes(query);
        });
        const count = entries.filter(entry => !entry.hidden).length;
        status.textContent = `${count} ${count === 1 ? 'update' : 'updates'} shown`;
        empty_results.hidden = count !== 0;
    }
    buttons.forEach(button => button.addEventListener('click', () => {
        active_filter = button.dataset.filter;
        buttons.forEach(item => item.setAttribute('aria-pressed', String(item === button)));
        filter_research();
    }));
    search.addEventListener('input', filter_research);
    filter_research();
}

const contact_topic = document.querySelector('[data-contact-topic]');
const email_link = document.querySelector('[data-email-link]');
if (contact_topic && email_link) {
    contact_topic.addEventListener('change', () => {
        email_link.href = `mailto:info@genvira.com?subject=${encodeURIComponent(contact_topic.value)}`;
    });
}
