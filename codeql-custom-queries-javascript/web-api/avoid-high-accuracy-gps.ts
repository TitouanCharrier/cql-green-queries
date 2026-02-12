// --- POSITIVE CASES (Should be flagged) ---

// Direct object literal
navigator.geolocation.getCurrentPosition(success, error, {
    enableHighAccuracy: true, // FLAG THIS
    timeout: 5000
});

// Variable reference
const powerHungryOptions = {
    enableHighAccuracy: true, // FLAG THIS
    maximumAge: 0
};
navigator.geolocation.getCurrentPosition(success, error, powerHungryOptions);

// Using watchPosition
navigator.geolocation.watchPosition(success, error, {
    enableHighAccuracy: true // FLAG THIS
});


// --- NEGATIVE CASES (Should NOT be flagged) ---

// Explicitly false (Eco-friendly)
navigator.geolocation.getCurrentPosition(success, error, {
    enableHighAccuracy: false,
    timeout: 10000
});

// Property missing (Defaults to false)
navigator.geolocation.getCurrentPosition(success, error, {
    timeout: 5000
});

// No options argument at all
navigator.geolocation.getCurrentPosition(success);

function success(pos: any) { console.log(pos); }
function error(err: any) { console.warn(err); }