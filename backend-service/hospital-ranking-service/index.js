import { getEmergency } from "./repositories/emergency.repository.js";

import { getUser } from "./repositories/user.repository.js";

import { buildPatientContext } from "./utils/patientContext.js";

import { fetchNearbyHospitals } from "./services/hospitalFetcher.service.js";

import { enrichHospitals } from "./services/hospitalEnrichment.service.js";

import { rankHospitals } from "./services/hospitalRanking.service.js";

export const handler = async (event) => {
  try {

    const userId =
      event.requestContext
        ?.authorizer
        ?.jwt
        ?.claims
        ?.sub;

    if (!userId) {
      return {
        statusCode: 401,

        headers: {
          "Access-Control-Allow-Origin": "*",
        },

        body: JSON.stringify({
          error: "Unauthorized",
        }),
      };
    }

    const emergencyId =
      event.queryStringParameters?.emergencyId;

    if (!emergencyId) {
      return {
        statusCode: 400,

        headers: {
          "Access-Control-Allow-Origin": "*",
        },

        body: JSON.stringify({
          error: "emergencyId is required",
        }),
      };
    }

    // Fetch emergency
    const emergency =
      await getEmergency(emergencyId);

    if (!emergency) {
      return {
        statusCode: 404,

        headers: {
          "Access-Control-Allow-Origin": "*",
        },

        body: JSON.stringify({
          error: "Emergency not found",
        }),
      };
    }

    // Authorization check
    if (emergency.userId !== userId) {
      return {
        statusCode: 403,

        headers: {
          "Access-Control-Allow-Origin": "*",
        },

        body: JSON.stringify({
          error: "Forbidden",
        }),
      };
    }

    // Fetch user
    const user =
      await getUser(emergency.userId);

    if (!user) {
      return {
        statusCode: 404,

        headers: {
          "Access-Control-Allow-Origin": "*",
        },

        body: JSON.stringify({
          error: "User profile not found",
        }),
      };
    }

    // Build patient context
    const patientContext =
      buildPatientContext(user, emergency);

    // Fetch hospitals
    let hospitals = [];

    try {

      hospitals =
        await fetchNearbyHospitals(
          patientContext.location.lat,
          patientContext.location.lng
        );

    } catch (err) {

      console.error(
        "Hospital fetch failed:",
        err
      );

    }

    // Fallback hospitals
    if (!hospitals || hospitals.length === 0) {

      console.log(
        "Using fallback hospitals"
      );

      hospitals = [
        {
          hospitalId: "fallback_1",

          name:
            "City General Hospital",

          location: {
            lat:
              patientContext.location.lat + 0.01,

            lng:
              patientContext.location.lng + 0.01,
          },
        },

        {
          hospitalId: "fallback_2",

          name:
            "Metro Care Hospital",

          location: {
            lat:
              patientContext.location.lat + 0.02,

            lng:
              patientContext.location.lng - 0.01,
          },
        },

        {
          hospitalId: "fallback_3",

          name:
            "Community Health Center",

          location: {
            lat:
              patientContext.location.lat - 0.015,

            lng:
              patientContext.location.lng + 0.005,
          },
        },
      ];
    }

    // Enrich hospitals
    let enrichedHospitals;

    try {

      enrichedHospitals =
        enrichHospitals(hospitals);

    } catch (err) {

      console.log(
        "Enrichment failed fallback",
        err
      );

      enrichedHospitals = hospitals;
    }

    // Rank hospitals
    const rankedHospitals =
      rankHospitals(
        enrichedHospitals,
        patientContext
      );

    return {
      statusCode: 200,

      headers: {
        "Content-Type":
          "application/json",

        "Access-Control-Allow-Origin":
          "*",
      },

      body: JSON.stringify({
        emergency: {
          severity:
            emergency.severity,

          severityScore:
            emergency.severityScore,

          possibleCondition:
            emergency.possibleCondition,

          recommendedAction:
            emergency.recommendedAction,

          aiProcessed:
            emergency.aiProcessed,
        },

        hospitals: rankedHospitals,
      }),
    };

  } catch (error) {

    console.error(
      "Lambda error",
      error
    );

    return {
      statusCode: 500,

      headers: {
        "Access-Control-Allow-Origin":
          "*",
      },

      body: JSON.stringify({
        error:
          "Internal Server Error",
      }),
    };
  }
};