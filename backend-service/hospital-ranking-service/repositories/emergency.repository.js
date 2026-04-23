const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.EMERGENCY_TABLE;

async function getEmergency(emergencyId) {

  const params = {
    TableName: TABLE_NAME,
    FilterExpression: "emergencyId = :eid",
    ExpressionAttributeValues: {
      ":eid": emergencyId
    }
  };

  const result = await dynamo.scan(params).promise();

  if (!result.Items || result.Items.length === 0) {
    return null;
  }

  return result.Items[0];
}

module.exports = {
  getEmergency
};