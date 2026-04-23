function resolveSpecialty(symptoms = []) {

  const map = {
    "chest pain": "cardiac",
    "stroke": "neuro",
    "fracture": "trauma",
    "seizure": "neuro",
    "head injury": "trauma"
  };

  for (let s of symptoms) {
    if (map[s]) return map[s];
  }

  return "general";
}

module.exports = resolveSpecialty;