// index.js

import {
  createEmergency,
  getEmergencyById
} from "./service/emergency.service.js";

export const handler = async (event) => {

  console.log(
    "EVENT:",
    JSON.stringify(event, null, 2)
  );

  try {

    const httpMethod =
      event.requestContext?.http?.method ||
      "POST";

    const userId =
      event.requestContext?.authorizer
        ?.jwt?.claims?.sub ||
      "test-user";

    if (!userId) {

      return {
        statusCode: 401,

        body: JSON.stringify({
          error:
            "Unauthorized - userId missing"
        })
      };

    }

    /// ✅ CREATE EMERGENCY
    if (httpMethod === "POST") {

      const body = event.body
        ? JSON.parse(event.body)
        : event;

      const result =
        await createEmergency(
          userId,
          body
        );

      return {
        statusCode: 201,

        headers: {
          "Access-Control-Allow-Origin":
            "*"
        },

        body: JSON.stringify(result)
      };

    }

    /// ✅ GET EMERGENCY
    if (httpMethod === "GET") {

      const emergencyId =
        event.pathParameters?.id;

      const result =
        await getEmergencyById(
          userId,
          emergencyId
        );

      if (!result) {

        return {
          statusCode: 404,

          body: JSON.stringify({
            error:
              "Emergency not found"
          })
        };

      }

      return {
        statusCode: 200,

        headers: {
          "Access-Control-Allow-Origin":
            "*"
        },

        body: JSON.stringify(result)
      };

    }

    return {
      statusCode: 405,

      body: JSON.stringify({
        error:
          "Method Not Allowed"
      })
    };

  } catch (error) {

    console.error(
      "HANDLER ERROR:",
      error
    );

    return {
      statusCode: 500,

      body: JSON.stringify({
        error: error.message
      })
    };

  }

};