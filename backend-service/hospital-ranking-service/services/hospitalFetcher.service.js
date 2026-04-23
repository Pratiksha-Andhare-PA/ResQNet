const axios = require("axios");

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

      return response.data.elements.map((h) => ({
        hospitalId: `osm_${h.id}`,
        name: h.tags?.name || "Nearby Hospital",
        location: {
          lat: h.lat || h.center?.lat,
          lng: h.lon || h.center?.lon
        }
      }));

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