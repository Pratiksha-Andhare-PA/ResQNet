const axios = require("axios");

function isDuplicate(h1, h2) {
  const sameName = h1.name === h2.name;

  const distance =
    Math.abs(h1.location.lat - h2.location.lat) +
    Math.abs(h1.location.lng - h2.location.lng);

  // ~500m threshold
  return sameName && distance < 0.005;
}

async function fetchNearbyHospitals(lat, lng) {

  const query = `
  [out:json][timeout:20];
  (
    node["amenity"="hospital"](around:8000,${lat},${lng});
    way["amenity"="hospital"](around:8000,${lat},${lng});
    relation["amenity"="hospital"](around:8000,${lat},${lng});
  );
  out center;
  `;

  const endpoints = [
    "https://overpass.kumi.systems/api/interpreter",
    "https://overpass-api.de/api/interpreter"
  ];

  for (const url of endpoints) {

    try {

      const response = await axios.post(
        url,
        query,
        {
          headers: {
            "Content-Type": "text/plain",
            "User-Agent": "resq-net-app"
          },
          timeout: 5000
        }
      );

      if (!response.data?.elements?.length) continue;

      const hospitals = [];

      response.data.elements.forEach((h) => {

        const nameRaw = h.tags?.name || "";
        const name = nameRaw.trim();

        const lowerName = name.toLowerCase();

        // ❌ FILTER unwanted places
        if (!name) return;
        if (lowerName.includes("clinic")) return;
        if (lowerName.includes("diagnostic")) return;
        if (lowerName.includes("pathology")) return;
        if (lowerName.includes("lab")) return;

        const hospital = {
          hospitalId: `osm_${h.id}`,
          name: name || "Nearby Hospital",
          location: {
            lat: h.lat || h.center?.lat,
            lng: h.lon || h.center?.lon
          }
        };

        // ❌ skip if no coordinates
        if (!hospital.location.lat || !hospital.location.lng) return;

        // ✅ DEDUPLICATION
        const exists = hospitals.some(existing =>
          isDuplicate(existing, hospital)
        );

        if (!exists) {
          hospitals.push(hospital);
        }

      });

      console.log(`Fetched ${hospitals.length} unique hospitals`);

      return hospitals;

    } catch (error) {

      console.log("Overpass failed for", url);
      console.log("ERROR:", error.message);

      await new Promise(r => setTimeout(r, 1000));

    }

  }

  console.log("All Overpass servers failed");

  return [];
}

module.exports = { fetchNearbyHospitals };