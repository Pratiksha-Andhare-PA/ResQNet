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

const dynamo =
  DynamoDBDocumentClient.from(client);

const TABLE_NAME =
  process.env.USER_TABLE;

export async function getUser(
  userId
) {
  const params = {
    TableName: TABLE_NAME,

    Key: {
      userId,
    },
  };

  const result = await dynamo.send(
    new GetCommand(params)
  );

  return result.Item;
}