export default function resolveSpecialty(
  symptoms = []
) {
  const map = {
    "chest pain": "cardiac",
    stroke: "neuro",
    fracture: "trauma",
    seizure: "neuro",
    "head injury": "trauma",
  };

  for (const s of symptoms) {
    if (map[s]) {
      return map[s];
    }
  }

  return "general";
}