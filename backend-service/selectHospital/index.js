import {
  DynamoDBClient,
} from "@aws-sdk/client-dynamodb";

import {
  DynamoDBDocumentClient,
  GetCommand,
  UpdateCommand,
} from "@aws-sdk/lib-dynamodb";

const client =
  new DynamoDBClient({});

const dynamo =
  DynamoDBDocumentClient.from(
    client
  );

const TABLE =
  process.env.EMERGENCY_TABLE;

export const handler = async (
  event
) => {
  try {
    /// ✅ SAFE JWT ACCESS
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
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          error: "Unauthorized",
        }),
      };
    }

    /// ✅ SAFE BODY PARSE
    const body = event.body
      ? JSON.parse(event.body)
      : {};

    const {
      emergencyId,
      hospitalId,
      hospitalName,
    } = body;

    /// ✅ VALIDATION
    if (
      !emergencyId ||
      !hospitalId ||
      !hospitalName
    ) {
      return {
        statusCode: 400,

        headers: {
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          error:
            "Missing required fields",
        }),
      };
    }

    /// ✅ CHECK EXISTING EMERGENCY
    const existing =
      await dynamo.send(
        new GetCommand({
          TableName: TABLE,

          Key: {
            userId,
            emergencyId,
          },
        })
      );

    if (!existing.Item) {
      return {
        statusCode: 404,

        headers: {
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          error:
            "Emergency not found",
        }),
      };
    }

    /// ✅ PREVENT RE-SELECTION
    if (
      existing.Item
        .selectedHospitalId
    ) {
      return {
        statusCode: 409,

        headers: {
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          error:
            "Hospital already selected",
        }),
      };
    }

    /// ✅ UPDATE EMERGENCY
    await dynamo.send(
      new UpdateCommand({
        TableName: TABLE,

        Key: {
          userId,
          emergencyId,
        },

        UpdateExpression: `
          SET
            selectedHospitalId = :hid,
            selectedHospitalName = :hname,
            #status = :status,
            selectedAt = :time
        `,

        ExpressionAttributeNames: {
          "#status": "status",
        },

        ExpressionAttributeValues: {
          ":hid": hospitalId,

          ":hname":
            hospitalName,

          ":status":
            "ASSIGNED",

          ":time":
            new Date().toISOString(),
        },
      })
    );

    console.log(
      JSON.stringify({
        metric:
          "hospital_selected",
        emergencyId,
        hospitalId,
        hospitalName,
        timestamp: Date.now(),
      })
    );

    return {
      statusCode: 200,

      headers: {
        "Access-Control-Allow-Origin":
          "*",
      },

      body: JSON.stringify({
        message:
          "Hospital selected successfully",
      }),
    };
  } catch (err) {
    console.error(
      "SELECT HOSPITAL ERROR:",
      err
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