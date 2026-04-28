const resolveSpecialty = require("./specialtyResolver");

function getAgeGroup(age) {

  if (age <= 15) return "child";
  if (age <= 60) return "adult";
  return "elderly";
}

function buildPatientContext(user, emergency) {

  const ageGroup = getAgeGroup(user.age);

  const requiredSpecialty =
    resolveSpecialty(emergency.symptoms);

  return {
    location: emergency.location,
    severity: emergency.severity,
    symptoms: emergency.symptoms || [],
    age: user.age,
    ageGroup,
    medicalConditions: user.medical_conditions,
    allergies: user.allergies,
    requiredSpecialty,
    ambulancePreference: emergency.ambulancePreference
  };
}

module.exports = {
  buildPatientContext
};