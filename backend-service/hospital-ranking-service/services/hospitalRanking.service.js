const { calculateDistance } = require("../utils/distance");
const computeScore = require("../utils/scoring");

function rankHospitals(hospitals, patientContext) {

  if (!hospitals || hospitals.length === 0) return [];

  const ranked = hospitals.map((hospital) => {

    const distance = calculateDistance(
      patientContext.location.lat,
      patientContext.location.lng,
      hospital.location.lat,
      hospital.location.lng
    );

    const score = computeScore(
      hospital,
      patientContext,
      distance
    );

    return {
      ...hospital,
      distance: Number(distance.toFixed(2)),
      score: Number((score || 0).toFixed(3))
    };
  });

  ranked.sort((a, b) => b.score - a.score);

  return ranked.slice(0, 10);
}

module.exports = {
  rankHospitals
};