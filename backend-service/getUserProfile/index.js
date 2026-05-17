import {
  DynamoDBClient,
} from "@aws-sdk/client-dynamodb";

import {
  DynamoDBDocumentClient,
  GetCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({
  region: "ap-south-1",
});

const ddb =
  DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  try {
    /// ✅ SAFE JWT ACCESS
    const userId =
      event.requestContext?.authorizer
        ?.jwt?.claims?.sub;

    /// ✅ AUTH CHECK
    if (!userId) {
      return {
        statusCode: 401,

        headers: {
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          message: "Unauthorized",
        }),
      };
    }

    /// ✅ FETCH PROFILE
    const result = await ddb.send(
      new GetCommand({
        TableName:
          process.env.USERS_TABLE,

        Key: {
          userId,
        },
      })
    );

    /// ✅ OPTIONAL 404
    if (!result.Item) {
      return {
        statusCode: 404,

        headers: {
          "Access-Control-Allow-Origin":
            "*",
        },

        body: JSON.stringify({
          message: "Profile not found",
        }),
      };
    }

    return {
      statusCode: 200,

      headers: {
        "Access-Control-Allow-Origin":
          "*",
      },

      body: JSON.stringify({
        profile: result.Item,
      }),
    };
  } catch (error) {
    console.error(
      "GET PROFILE ERROR:",
      error
    );

    return {
      statusCode: 500,

      headers: {
        "Access-Control-Allow-Origin":
          "*",
      },

      body: JSON.stringify({
        message:
          "Internal server error",
      }),
    };
  }
};