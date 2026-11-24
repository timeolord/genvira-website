const office_map = document.querySelector('.contact-map');
const office_location = [Number(office_map.dataset.latitude), Number(office_map.dataset.longitude)];
const office_zoom = 16;
office_map.hidden = false;

const map = L.map(office_map, { scrollWheelZoom: false }).setView(office_location, office_zoom);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
}).addTo(map);

const office_pin = L.divIcon({ className: 'office-pin', iconSize: [24, 24], iconAnchor: [12, 24], popupAnchor: [0, -24] });
L.marker(office_location, { icon: office_pin, title: 'Genvira Biosciences Inc.' })
    .bindPopup('<strong>Genvira Biosciences Inc.</strong><br>310 Hunt Club Rd, Suite 304<br>Ottawa, Ontario K1V 1C1')
    .addTo(map);

const office_control = L.control({ position: 'topright' });
office_control.onAdd = () => {
    const panel = L.DomUtil.create('div', 'office-map-card');
    panel.append(document.querySelector('.contact-details address').cloneNode(true));

    const reset = L.DomUtil.create('button', 'office-map-reset', panel);
    reset.type = 'button';
    reset.textContent = 'Back to office';
    reset.addEventListener('click', () => map.closePopup().setView(office_location, office_zoom, { animate: false }));

    L.DomEvent.disableClickPropagation(panel);
    L.DomEvent.disableScrollPropagation(panel);
    return panel;
};
office_control.addTo(map);
