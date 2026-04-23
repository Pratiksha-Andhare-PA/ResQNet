const { calculateDistance } = require("../utils/distance");

function rankHospitals(hospitals, patientContext) {

  if (!hospitals || hospitals.length === 0) {
    return [];
  }

  const ranked = hospitals.map((hospital) => {

    const distance = calculateDistance(
      patientContext.location.lat,
      patientContext.location.lng,
      hospital.location.lat,
      hospital.location.lng
    );

    const specializationScore =
      hospital.specializations &&
      hospital.specializations.includes(patientContext.requiredSpecialty)
        ? 1
        : 0;

    const icuScore = hospital.icuAvailable ? 1 : 0;

    const bedScore = Math.min((hospital.availableBeds || 0) / 50, 1);

    const ambulanceScore = Math.min((hospital.ambulancesAvailable || 0) / 5, 1);

    const ratingScore = (hospital.rating || 0) / 5;

    const ageScore =
      hospital.ageGroupSupport &&
      hospital.ageGroupSupport.includes(patientContext.ageGroup)
        ? 1
        : 0.5;

    const distanceScore = 1 / (distance + 1);

    const score =
      distanceScore * 0.35 +
      specializationScore * 0.20 +
      icuScore * 0.15 +
      bedScore * 0.10 +
      ambulanceScore * 0.10 +
      ratingScore * 0.05 +
      ageScore * 0.05;

    return {
      ...hospital,
      distance: Number(distance.toFixed(2)),
      score: Number(score.toFixed(3))
    };
  });

  ranked.sort((a, b) => b.score - a.score);

  return ranked.slice(0, 10);
}

module.exports = {
  rankHospitals
};