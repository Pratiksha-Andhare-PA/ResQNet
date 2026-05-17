import rankingWeights from "../config/rankingWeights.js";

export function normalizeDistance(d) {
  return 1 - Math.min(d / 20, 1);
}

export default function computeScore(
  h,
  context,
  distance
) {
  const weights =
    rankingWeights[
      context.severity
    ] || rankingWeights.MEDIUM;

  const distanceScore =
    normalizeDistance(distance);

  const specialty =
    h.specializations &&
    h.specializations.includes(
      context.requiredSpecialty
    )
      ? 1
      : 0;

  const ageCompat =
    h.ageGroupSupport &&
    h.ageGroupSupport.includes(
      context.ageGroup
    )
      ? 1
      : 0;

  const score =
    distanceScore *
      weights.distance +
    specialty *
      weights.specialty +
    (h.icuAvailable ? 1 : 0) *
      weights.icu +
    ((h.availableBeds || 0) /
      50) *
      weights.beds +
    ((h.ambulancesAvailable ||
      0) /
      5) *
      weights.ambulances +
    ((h.rating || 0) / 5) *
      weights.rating +
    ageCompat *
      weights.ageCompatibility;

  return Number(score.toFixed(3));
}