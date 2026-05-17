import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const docClient = DynamoDBDocumentClient.from(client);

const saveEmergency = async (item) => {
  await docClient.send(
    new PutCommand({
      TableName: "EmergencyRequests",
      Item: item,
    })
  );
};

export { saveEmergency };