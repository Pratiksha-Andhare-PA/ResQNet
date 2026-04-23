const AWS = require("aws-sdk");
const dynamo = new AWS.DynamoDB.DocumentClient({ region: "ap-south-1" });
const TABLE = process.env.EMERGENCY_TABLE;

exports.createEmergency = async (userId, data) => {
  console.log("PARSED BODY:", data); // 🔥 DEBUG

  const emergencyId = `emergency_${Date.now()}`;

  const item = {
    userId,
    emergencyId,
    createdAt: new Date().toISOString(),

    location: data.location || null,
    symptoms: data.symptoms || [],
    patientType: data.patientType || null,
    ageGroup: data.ageGroup || null,
    conscious: data.conscious ?? null,
    breathing: data.breathing ?? null,
    ambulancePreference: data.ambulancePreference || null,

    // optional (if you use later)
    severity: data.severity || null,
  };

  console.log("ITEM TO SAVE:", item); // 🔥 DEBUG

  await dynamo.put({
    TableName: TABLE,
    Item: item,
  }).promise();

  return item;
};