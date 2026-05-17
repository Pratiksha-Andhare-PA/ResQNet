// service/emergency.service.js

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
  GetCommand,
} from "@aws-sdk/lib-dynamodb";

import {
  LambdaClient,
  InvokeCommand,
} from "@aws-sdk/client-lambda";

const dynamoClient = new DynamoDBClient({
  region: "ap-south-1",
});

const dynamo = DynamoDBDocumentClient.from(dynamoClient);

const lambda = new LambdaClient({
  region: "ap-south-1",
});

const TABLE = process.env.EMERGENCY_TABLE;

const createEmergency = async (
  userId,
  data
) => {
  console.log("PARSED BODY:", data);

  const emergencyId =
    `emergency_${Date.now()}`;

  /// ✅ CREATE IMMEDIATELY
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

    ambulancePreference:
      data.ambulancePreference || null,

    /// ✅ AI INITIAL STATE
    severity: "PENDING",
    severityScore: 0,
    possibleCondition: "",
    recommendedAction: "",
    aiProcessed: false,
  };

  console.log("INITIAL ITEM:", item);

  /// ✅ SAVE TO DYNAMODB
  await dynamo.send(
    new PutCommand({
      TableName: TABLE,
      Item: item,
    })
  );

  console.log(
    "Emergency saved immediately"
  );

  /// ✅ INVOKE AI LAMBDA ASYNC
  try {
    await lambda.send(
      new InvokeCommand({
        FunctionName:
          process.env.AI_TRIAGE_LAMBDA,

        InvocationType: "Event",

        Payload: Buffer.from(
          JSON.stringify({
            emergencyId,
            userId,
            data,
          })
        ),
      })
    );

    console.log(
      "AI Lambda invoked successfully"
    );
  } catch (err) {
    console.error(
      "AI invoke failed:",
      err.message
    );
  }

  /// ✅ RETURN IMMEDIATELY
  return item;
};

/// OPTIONAL GET METHOD
const getEmergencyById = async (
  userId,
  emergencyId
) => {
  const result = await dynamo.send(
    new GetCommand({
      TableName: TABLE,

      Key: {
        userId,
        emergencyId,
      },
    })
  );

  return result.Item;
};

export {
  createEmergency,
  getEmergencyById,
};