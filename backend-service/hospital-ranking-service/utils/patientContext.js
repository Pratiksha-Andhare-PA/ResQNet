import resolveSpecialty from "./specialtyResolver.js";

function getAgeGroup(age) {
  if (age <= 15) {
    return "child";
  }

  if (age <= 60) {
    return "adult";
  }

  return "elderly";
}

export function buildPatientContext(
  user,
  emergency
) {
  const ageGroup = user?.age
    ? getAgeGroup(user.age)
    : emergency.ageGroup ||
      "adult";

  const requiredSpecialty =
    resolveSpecialty(
      emergency.symptoms
    );

  return {
    location: emergency.location,

    severity: emergency.severity,

    symptoms:
      emergency.symptoms || [],

    age: user.age,

    ageGroup,

    medicalConditions:
      user.medical_conditions,

    allergies: user.allergies,

    requiredSpecialty,
  };
}