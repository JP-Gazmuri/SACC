document.addEventListener("click", function(event) {
    // Handle clicks on 'Estacion' and 'Historic' buttons
    if (event.target.matches('.estacion-button')) {
        const dataTitle = event.target.getAttribute('data-name');
        console.log(dataTitle);
        updateLockersTable(dataTitle);
        updateTitleAndButtonStyles(event.target, ".recent-Articles", "active");
        const stationLink = document.getElementById('stationLink');
        stationLink.href = `/stations/${dataTitle}`;
        updateHistoricButtons(data.lockers)
        console.log('button estacion')
    }
    else if (event.target.matches('.historic-button')) {
        updateTitleAndButtonStyles(event.target, ".historic-title", "active");
        console.log('button historic')
        const lockerNumber = event.target.getAttribute('data-title');
        // updateHistoricButtons(data.lockers)
        updateHistoricTable(lockerNumber);
    }

    // Handle clicks on the 'Load More' button
    else if (event.target.matches('.load-more-button')) {
        const hiddenItems = document.querySelectorAll(".report-container:last-child .item1.hidden");
        console.log('button load more')
        hiddenItems.forEach((item, index) => {
            if (index < 5) {
                item.classList.remove("hidden");
            }
        });
        if (hiddenItems.length <= 5) {
            event.target.style.display = 'none';
        }
    }

    // Toggle notification popup
    if (event.target.closest('.notification-circle')) {
        document.querySelector('.notification-popup').classList.toggle('hidden');
        console.log('Notification circle or its child clicked - toggling popup');
    }

    // Close the notification popup when clicking outside
    else if (!event.target.closest('.notification-circle') && !event.target.closest('.notification-popup')) {
        document.querySelector('.notification-popup').classList.add('hidden');
        console.log('Clicked outside - hiding popup');
    }
});
function updateHistoricButtons(lockers) {
    var historicButtonsContainer = document.getElementById('historic-buttons-container');
    var buttonsHTML = '';
    lockers.forEach(function(locker) {
        buttonsHTML += `<button class="historic-button" data-title="${locker.number}">Locker ${locker.number}</button>`;
    });
    historicButtonsContainer.innerHTML = buttonsHTML;
}

function updateLockersTable(estacionId) {
    fetch(`/stations/lockers_for_estacion/${estacionId}`)
        .then(response => response.json())
        .then(data => {
            console.log('Data received:', data); 
            var lockersTableContainer = document.querySelector('.items');
            var lockersTableHTML = buildLockersTableHTML(data.lockers);
            lockersTableContainer.innerHTML = lockersTableHTML;
            // Ahora actualizamos la información de porcentaje
            var percentageContainer = document.querySelector('.box-container');
            var percentageHTML = buildPercentageHTML(data.lockerStats);
            percentageContainer.innerHTML = percentageHTML;
            // Actualiza los botones del historial para la nueva estación
            updateHistoricButtons(data.lockers);
            // Actualiza el historial para el primer locker después de cargar la tabla de lockers
            var firstLockerNumber = data.lockers[0].id;
            updateHistoricTable(firstLockerNumber);
        })
        .catch(error => console.error('Error fetching lockers:', error));
}
// Añade estas funciones al final de tu archivo JavaScript
function updateHistoricTable(lockerNumber) {
    fetch(`/stations/historic_for_locker/${lockerNumber}`)
        .then(response => response.json())
        .then(data => {
            var historicTableContainer = document.querySelector('#historic-items-container');
            var historicTableHTML = buildHistoricTableHTML(data.historic);
            historicTableContainer.innerHTML = historicTableHTML;
        })
        .catch(error => console.error('Error fetching historic:', error));
}

function buildHistoricTableHTML(historic) {
    var tableHTML = '';
    historic.forEach(function(log) {
        tableHTML += `
      <div class="item1">
        <h3 class="t-op-nextlvl casillo">Locker ${log.casillero}</h3>
        <h3 class="t-op-nextlvl">${log.fecha}</h3>
        <h3 class="t-op-nextlvl label-tag">${log.accion}</h3>
      </div>`;
    });
    return tableHTML;
}
function buildPercentageHTML(lockerStats) {
    if (!lockerStats) {
        console.error('Locker stats are undefined');
        return '';
    }
    var percentageHTML = '';
    lockerStats.forEach(function(lockerStat) {
        percentageHTML += `
      <div class="box box${lockerStat.locker_number}">
        <div class="text">
          <h2 class="topic-heading">${lockerStat.percentage_occupied_changes}%</h2>
          <h2 class="topic">Locker ${lockerStat.locker_number}</h2>
        </div>
      </div>`;
    });
    console.log('Generated HTML:', percentageHTML);
    return percentageHTML;
}

function buildLockersTableHTML(lockers) {
    var tableHTML = '';
    lockers.forEach(function(locker) {
        tableHTML += `<div class="item1 <%= 'red-background' if locker.sensors == 0 && locker.state == 'ocupado' %>">
      <h3 class="t-op-nextlvl history">Locker ${locker.number}</h3>
      <h3 class="t-op-nextlvl">${locker.alto}x${locker.largo}x${locker.ancho} cm</h3>
      <h3 class="t-op-nextlvl">${locker.updated_at}</h3>
      <h3 class="t-op-nextlvl label-tag">${locker.estado}</h3>
    </div>`;
    });
    return tableHTML;
}



// Function to update titles and button styles
function updateTitleAndButtonStyles(button, titleSelector, activeClass) {
    const titleElement = document.querySelector(titleSelector);
    titleElement.textContent = button.getAttribute('data-title');
    const buttons = document.querySelectorAll(`.${button.className}`);
    buttons.forEach(btn => btn.classList.remove(activeClass));
    button.classList.add(activeClass);
}
// Añade estas funciones al final de tu archivo JavaScript
function updateHistoricButtons(lockers) {
    var historicButtonsContainer = document.querySelector('#historic-buttons-container');
    var buttonsHTML = buildHistoricButtonsHTML(lockers);
    historicButtonsContainer.innerHTML = buttonsHTML;

    // Asegúrate de agregar el event listener para los nuevos botones
    document.querySelectorAll('.historic-button').forEach(function(button) {
        button.addEventListener('click', function() {
            updateTitleAndButtonStyles(button, ".historic-title", "active");
            const lockerNumber = button.getAttribute('data-title');
            updateHistoricTable(lockerNumber);
        });
    });
}

function buildHistoricButtonsHTML(lockers) {
    var buttonsHTML = '';
    lockers.forEach(function(locker) {
        buttonsHTML += `
      <button class="historic-button" data-title="${locker.number}">
        Locker ${locker.number}
      </button>`;
    });
    return buttonsHTML;
}

// Toggle the navigation container
let menuicn = document.querySelector(".menuicn");
let nav = document.querySelector(".navcontainer");
menuicn.addEventListener("click", () => {
    nav.classList.toggle("navclose");
});
