const AWS = require("aws-sdk");
const dynamo = new AWS.DynamoDB.DocumentClient({ region: "ap-south-1" }); 
const TABLE = process.env.EMERGENCY_TABLE;
console.log("Using table:", TABLE);

exports.createEmergency = async (userId, data) => {
  const emergencyId = `emergency_${Date.now()}`;
  const item = {
    userId,        // Partition Key
    emergencyId,   // Sort Key
    location: data.location,
    severity: data.severity,
    symptoms: data.symptoms,
    createdAt: new Date().toISOString(),
  };

  await dynamo.put({
    TableName: TABLE,
    Item: item,
  }).promise();

  return item;
};

exports.getEmergencyById = async (userId, emergencyId) => {
  const res = await dynamo.get({
    TableName: TABLE,
    Key: { userId, emergencyId }, // both PK + SK
  }).promise();

  return res.Item;
};