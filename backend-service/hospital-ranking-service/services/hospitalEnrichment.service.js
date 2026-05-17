function seededNumber(str) {
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

    const icuAvailable =
      seed % 2 === 0;

    const availableBeds =
      (seed % 45) + 5;

    const ambulancesAvailable =
      seed % 5;

    const rating = (
      (seed % 15) / 10 + 3.5
    ).toFixed(1);

    const shuffled = [
      ...specializations,
    ].sort(
      (a, b) =>
        ((seed + a.length) % 7) -
        ((seed + b.length) % 7)
    );

    return {
      ...h,

      icuAvailable,

      availableBeds,

      ambulancesAvailable,

      rating: Number(rating),

      specializations:
        shuffled.slice(0, 2),

      ageGroupSupport: [
        "child",
        "adult",
        "elderly",
      ],
    };
  });
}