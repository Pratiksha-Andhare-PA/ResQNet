const { getEmergency } = require("./repositories/emergency.repository");
const { getUser } = require("./repositories/user.repository");

const { buildPatientContext } = require("./utils/patientContext");

const { fetchNearbyHospitals } = require("./services/hospitalFetcher.service");
const { enrichHospitals } = require("./services/hospitalEnrichment.service");
const { rankHospitals } = require("./services/hospitalRanking.service");

exports.handler = async (event) => {
  try {

    const emergencyId = event.queryStringParameters?.emergencyId;

    if (!emergencyId) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          error: "emergencyId is required"
        })
      };
    }

    // Fetch emergency
    const emergency = await getEmergency(emergencyId);

    if (!emergency) {
      return {
        statusCode: 404,
        body: JSON.stringify({
          error: "Emergency not found"
        })
      };
    }

    // Fetch user
    const user = await getUser(emergency.userId);

    if (!user) {
      return {
        statusCode: 404,
        body: JSON.stringify({
          error: "User profile not found"
        })
      };
    }

    // Build patient context
    const patientContext = buildPatientContext(user, emergency);

    // Fetch hospitals
    let hospitals = [];

    try {
      hospitals = await fetchNearbyHospitals(
        patientContext.location.lat,
        patientContext.location.lng
      );
    } catch (err) {
      console.error("Hospital fetch failed:", err);
    }

    // Fallback hospitals if API fails
    if (!hospitals || hospitals.length === 0) {

      console.log("Using fallback hospitals");

      hospitals = [
        {
          hospitalId: "fallback_1",
          name: "City General Hospital",
          location: {
            lat: patientContext.location.lat + 0.01,
            lng: patientContext.location.lng + 0.01
          }
        },
        {
          hospitalId: "fallback_2",
          name: "Metro Care Hospital",
          location: {
            lat: patientContext.location.lat + 0.02,
            lng: patientContext.location.lng - 0.01
          }
        },
        {
          hospitalId: "fallback_3",
          name: "Community Health Center",
          location: {
            lat: patientContext.location.lat - 0.015,
            lng: patientContext.location.lng + 0.005
          }
        }
      ];
    }

    // Enrich hospitals
    let enrichedHospitals;

    try {
      enrichedHospitals = enrichHospitals(hospitals);
    } catch (err) {
      console.log("Enrichment failed fallback", err);
      enrichedHospitals = hospitals;
    }

    // Rank hospitals
    const rankedHospitals = rankHospitals(
      enrichedHospitals,
      patientContext
    );

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(rankedHospitals)
    };

  } catch (error) {

    console.error("Lambda error", error);

    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Internal Server Error"
      })
    };
  }
};