const rankingWeights = {
  LOW: {
    distance: 0.45,
    specialty: 0.15,
    icu: 0.05,
    beds: 0.15,
    ambulances: 0.05,
    rating: 0.10,
    ageCompatibility: 0.05
  },

  MEDIUM: {
    distance: 0.35,
    specialty: 0.20,
    icu: 0.15,
    beds: 0.10,
    ambulances: 0.10,
    rating: 0.05,
    ageCompatibility: 0.05
  },

  HIGH: {
    distance: 0.20,
    specialty: 0.25,
    icu: 0.25,
    beds: 0.10,
    ambulances: 0.10,
    rating: 0.05,
    ageCompatibility: 0.05
  },

  CRITICAL: {
    distance: 0.10,
    specialty: 0.30,
    icu: 0.30,
    beds: 0.10,
    ambulances: 0.15,
    rating: 0.00,
    ageCompatibility: 0.05
  }
};

export default rankingWeights;