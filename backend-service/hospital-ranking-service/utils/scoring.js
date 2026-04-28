const weights = require("../config/rankingWeights");
const analyzeEmergency = require("./emergencyAnalysis");

function normalizeDistance(d) {
  return 1 - Math.min(d/20,1);
}

function computeScore(h, context, distance) {

  const analysis = analyzeEmergency(context);

  let score = 0;

  // 🚨 Severity
  if (analysis.severity === "HIGH") score += 40;
  if (analysis.severity === "MEDIUM") score += 20;

  // 🚑 Ambulance priority (CRITICAL FIX)
  if (
    context.ambulancePreference === "ambulance" &&
    h.ambulancesAvailable > 0
  ) {
    score += 30;
  }

  // 🏥 ICU priority
  if (analysis.needsICU && h.icuAvailable) {
    score += 25;
  }

  // 🧠 Speciality
  if (h.specializations.includes(context.requiredSpecialty)) {
    score += 20;
  }

  // 👶 Age compatibility
  if (h.ageGroupSupport.includes(context.ageGroup)) {
    score += 10;
  }

  // 📍 Distance (reduced dominance)
  score += normalizeDistance(distance) * 20;

  // ⭐ Rating
  score += (h.rating || 0);

  // 🛏 Beds
  score += Math.min((h.availableBeds || 0) / 10, 5);

  return score;

}

module.exports = computeScore;