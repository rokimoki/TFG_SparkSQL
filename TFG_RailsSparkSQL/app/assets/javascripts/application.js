// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require proj4.js
//= require_self
    var mapa;
    var opcionesMapa;

    var heatColors = ["#000099", // 0 -> 0-10 km/h
                    "#003399", // 1 -> 11-15 km/h
                    "#285AA1", // 2 -> 15-20 km/h
                    "#0073E6", // 3 -> 21-30 km/h
                    "#0099CC", // 4 -> 31-35 km/h
                    "#00CCFF", // 5 -> 36-40 km/h
                    "#00FF99", // 6 -> 41-45 km/h
                    "#66FF66", // 7 -> 46-50 km/h
                    "#CCFF66", // 8 -> 51-55 km/h
                    "#FFFF66", // 9 -> 56-60 km/h
                    "#FFFF00", // 10 -> 61-70 km/h
                    "#FFA646", // 11 -> 71-75 km/h
                    "#FF7200", // 12 -> 76-80 km/h
                    "#FF5500", // 13 -> 81-90 km/h
                    "#FF3600", // 14 -> 91-100 km/h
                    "#FF1F00", // 15 -> 101-110 km/h
                    "#FF0000"]; // 16 -> 110 km/h

    var speedRange = [[0, 10], // 0
                    [10, 15], // 1
                    [15, 20], // 2
                    [20, 30], // 3
                    [30, 35], // 4
                    [35, 40], // 5
                    [40, 45], // 6
                    [45, 50], // 7
                    [50, 55], // 8
                    [55, 60], // 9
                    [60, 70], // 10
                    [70, 75], // 11
                    [75, 80], // 12
                    [80, 90], // 13
                    [90, 100], // 14
                    [100, 110], // 15
                    [110, 120]]; // 16

    var projections = {
        wgs84: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
        ETRS89: "+proj=utm +zone=30 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    };

    function addMarker(lat, lon, elementId, elementName, avgSpeed) {
        var htmlDescription = "<p>Sensor: " + elementName + "</p>"+
            "<p>Id: " + elementId + "</p>" +
            "<p>Velocidad media: <strong>" + avgSpeed + "</strong></p>";
        var infoWindow = new google.maps.InfoWindow({
            content: htmlDescription
        });
        var marker = new google.maps.Marker({
            position: { lat: lat, lng: lon },
            map: mapa,
            title: "Sensor: " + elementName,
            icon: {
                path: google.maps.SymbolPath.CIRCLE,
                fillOpacity: 1,
                fillColor: getColorByAvgSpeed(avgSpeed),
                strokeOpacity: 0,
                scale: 15
            }
        });
        marker.addListener('click', function() {
            infoWindow.open(mapa, marker);
        });
    }

    function getColorByAvgSpeed(avgSpeed) {
        if (avgSpeed <= 10) { // First
            return heatColors[0];
        }
        var color = heatColors[16]; // Last
        for (var i = 1; i < speedRange.length - 1; i++) { // Range
            if (avgSpeed > speedRange[i][0] && avgSpeed <= speedRange[i][1]) {
                color = heatColors[i];
                break;
            }
        }
        return color;
    }

    function loadLeyend() {
        var leyend = document.getElementById("leyenda");
        for (var i = 0; i < heatColors.length; i++) {
            leyend.innerHTML +=
                "<div class='contenedor'>" +
                    "<div style='background: " + heatColors[i] + ";' class='leyendaCasilla rounded-circle'></div>" +
                    "<div class='leyendaDato'>" + speedRange[i][0] + "~" + speedRange[i][1] + " Km/h</div>" +
                    "<div class='separador'></div>" +
                "</div>";
        }
    }