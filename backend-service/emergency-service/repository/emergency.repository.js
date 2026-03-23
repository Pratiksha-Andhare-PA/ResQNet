const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");

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

module.exports = {
  saveEmergency,
};