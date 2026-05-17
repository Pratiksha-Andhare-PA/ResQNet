import {
  DynamoDBClient,
} from "@aws-sdk/client-dynamodb";

import {
  DynamoDBDocumentClient,
  QueryCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({
  region: "ap-south-1",
});

const dynamo =
  DynamoDBDocumentClient.from(client);

const TABLE_NAME =
  process.env.EMERGENCY_TABLE;

export async function getEmergency(
  emergencyId
) {
  const params = {
    TableName: TABLE_NAME,

    IndexName: "emergencyId-index",

    KeyConditionExpression:
      "emergencyId = :eid",

    ExpressionAttributeValues: {
      ":eid": emergencyId,
    },

    Limit: 1,
  };

  const result = await dynamo.send(
    new QueryCommand(params)
  );

  if (
    !result.Items ||
    result.Items.length === 0
  ) {
    return null;
  }

  return result.Items[0];
}