import { calculateDistance }
  from "../utils/distance.js";

import computeScore
  from "../utils/scoring.js";

export function rankHospitals(
  hospitals,
  patientContext
) {

  if (
    !hospitals ||
    hospitals.length === 0
  ) {
    return [];
  }

  const ranked =
    hospitals.map(
      (hospital) => {

        const distance =
          calculateDistance(
            patientContext.location.lat,
            patientContext.location.lng,
            hospital.location.lat,
            hospital.location.lng
          );

        return {
          ...hospital,

          distance: Number(
            distance.toFixed(2)
          ),

          score: computeScore(
            hospital,
            patientContext,
            distance
          ),
        };
      }
    );

  ranked.sort(
    (a, b) =>
      b.score - a.score
  );

  return ranked.slice(0, 10);
}