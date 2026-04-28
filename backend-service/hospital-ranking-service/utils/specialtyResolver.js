function resolveSpecialty(symptoms = []) {

  const map = {
    "chest pain": "cardiac",
    "stroke signs": "neuro",
    "accident": "trauma",
    "seizure": "neuro",
    "head injury": "trauma",
    "breathing problem": "pulmonary"
  };

  for (let s of symptoms) {
    const key = s.toLowerCase();

    if (map[key]) return map[key];
  }

  return "general";
}

module.exports = resolveSpecialty;