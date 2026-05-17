import AWS from "aws-sdk";

import { getTriageAI }
  from "./ai.service.js";

const dynamo =
  new AWS.DynamoDB.DocumentClient({
    region: "ap-south-1",
  });

const TABLE =
  process.env.EMERGENCY_TABLE;

export const handler = async (
  event
) => {
  console.log(
    "AI EVENT:",
    JSON.stringify(event)
  );

  try {
    const emergencyId =
      event.emergencyId;

    const userId =
      event.userId;

    const data =
      event.data;

    if (!emergencyId || !userId) {
      throw new Error(
        "Missing emergencyId or userId"
      );
    }

    console.log("Running AI...");

    const aiResult =
      await getTriageAI(data);

    console.log(
      "AI RESULT:",
      aiResult
    );

    await dynamo.update({
      TableName: TABLE,

      Key: {
        userId,
        emergencyId,
      },

      UpdateExpression: `
        SET
          severity = :severity,
          severityScore = :score,
          possibleCondition = :condition,
          recommendedAction = :action,
          aiProcessed = :processed
      `,

      ExpressionAttributeValues: {
        ":severity":
          aiResult.severity ||
          "MEDIUM",

        ":score":
          aiResult.severityScore ||
          50,

        ":condition":
          aiResult.possibleCondition ||
          "Unknown",

        ":action":
          aiResult.recommendedAction ||
          "Seek medical attention",

        ":processed": true,
      },

      ReturnValues: "UPDATED_NEW",
    }).promise();

    console.log(
      "Emergency updated with AI"
    );

    return {
      statusCode: 200,

      body: JSON.stringify({
        success: true,
      }),
    };
  } catch (err) {
    console.log(
      "AI LAMBDA ERROR:",
      err
    );

    return {
      statusCode: 500,

      body: JSON.stringify({
        error: err.message,
      }),
    };
  }
};