const getSeverity = (symptoms) => {
  if (!symptoms || symptoms.length === 0) return "MEDIUM";

  const highRisk = ["chest pain", "unconscious", "breathing difficulty"];

  if (symptoms.some((s) => highRisk.includes(s.toLowerCase()))) {
    return "HIGH";
  }

  return "MEDIUM";
};

module.exports = {
  getSeverity,
};