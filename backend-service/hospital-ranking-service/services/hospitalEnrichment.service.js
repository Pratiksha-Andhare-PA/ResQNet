function randomBool(prob = 0.5) {
  return Math.random() < prob;
}

function randomInt(min, max) {
  return Math.floor(Math.random()*(max-min+1))+min;
}

const specializations = [
  "trauma",
  "cardiac",
  "neuro",
  "pediatric",
  "general"
];

function enrichHospitals(hospitals) {

  return hospitals.map(h => ({

    ...h,

    icuAvailable: randomBool(0.7),

    availableBeds: randomInt(0,50),

    ambulancesAvailable: randomInt(0,5),

    specializations:
      specializations.sort(()=>0.5-Math.random())
      .slice(0,2),

    ageGroupSupport: ["child","adult","elderly"],

    rating: (Math.random()*5).toFixed(1)

  }));
}

module.exports = {
  enrichHospitals
};