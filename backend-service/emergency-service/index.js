const { createEmergency, getEmergencyById } = require("./service/emergency.service");

exports.handler = async (event) => {
  console.log("EVENT:", JSON.stringify(event, null, 2));

  try {
    const httpMethod = event.requestContext.http.method;

    const userId = event.requestContext?.authorizer?.jwt?.claims?.sub;

    if (!userId) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: "Unauthorized - userId missing" }),
      };
    }

    if (httpMethod === "POST") {
      const body = JSON.parse(event.body);
      const result = await createEmergency(userId, body);

      return {
        statusCode: 201,
        headers: { "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify(result),
      };
    }

    if (httpMethod === "GET") {
      const emergencyId = event.pathParameters.id;

      const result = await getEmergencyById(userId, emergencyId);

      if (!result) {
        return { statusCode: 404, body: "EmergencyRequest not found" };
      }

      return {
        statusCode: 200,
        headers: { "Access-Control-Allow-Origin": "*" },
        body: JSON.stringify(result),
      };
    }

    return { statusCode: 405, body: "Method Not Allowed" };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};