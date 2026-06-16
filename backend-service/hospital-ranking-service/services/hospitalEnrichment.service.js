function seededNumber(str = "") {
  let hash = 0;

  for (let i = 0; i < str.length; i++) {
    hash =
      str.charCodeAt(i) +
      ((hash << 5) - hash);
  }

  return Math.abs(hash);
}

const specializations = [
  "trauma",
  "cardiac",
  "neuro",
  "pediatric",
  "general",
];

export function enrichHospitals(
  hospitals
) {
  return hospitals.map((h) => {

    const seed = seededNumber(
      h.hospitalId || h.name
    );

    return {
      ...h,

      // ~70% hospitals have ICU
      icuAvailable:
        seed % 10 < 7,

      // 10–99 beds
      availableBeds:
        (seed % 90) + 10,

      // 0–5 ambulances
      ambulancesAvailable:
        seed % 6,

      // 3.0–5.0 rating
      rating: Number(
        (
          3 +
          (seed % 21) / 10
        ).toFixed(1)
      ),

      specializations: [
        "general",
        specializations[
          seed %
            specializations.length
        ],
        specializations[
          (seed + 2) %
            specializations.length
        ],
      ],

      ageGroupSupport: [
        "child",
        "adult",
        "elderly",
      ],
    };
  });
}