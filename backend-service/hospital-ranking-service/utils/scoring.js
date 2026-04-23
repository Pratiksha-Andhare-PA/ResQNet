const weights = require("../config/rankingWeights");

function normalizeDistance(d) {
  return 1 - Math.min(d/20,1);
}

function computeScore(h, context, distance) {

  const distanceScore =
    normalizeDistance(distance);

  const specialty =
    h.specializations.includes(
      context.requiredSpecialty
    ) ? 1 : 0;

  const ageCompat =
    h.ageGroupSupport.includes(
      context.ageGroup
    ) ? 1 : 0;

  const score =
      distanceScore * weights.distance +
      specialty * weights.specialty +
      (h.icuAvailable?1:0) * weights.icu +
      (h.availableBeds/50) * weights.beds +
      (h.ambulancesAvailable/5) * weights.ambulances +
      (h.rating/5) * weights.rating +
      ageCompat * weights.ageCompatibility;

  return score;
}

module.exports = computeScore;