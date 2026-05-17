import { DynamoDBClient } from "@aws-sdk/client-dynamodb";

import {
  DynamoDBDocumentClient,
  UpdateCommand,
} from "@aws-sdk/lib-dynamodb";

import { z } from "zod";

import sanitizeHtml from "sanitize-html";

const client = new DynamoDBClient({
  region: "ap-south-1",
});

const ddb = DynamoDBDocumentClient.from(client);

/// ✅ VALIDATION SCHEMA
const profileSchema = z.object({
  name: z.string().min(2).max(50).optional(),

  phone: z
    .string()
    .regex(/^[0-9]{10}$/)
    .optional(),

  age: z.number().min(1).max(120).optional(),

  gender: z
    .enum(["male", "female", "other"])
    .optional(),

  blood_group: z.string().optional(),

  allergies: z.array(z.string()).optional(),

  medical_conditions: z
    .array(z.string())
    .optional(),

  medications: z.array(z.string()).optional(),

  emergency_contacts: z.array(z.any()).optional(),
});

/// ✅ SANITIZE HELPER
const sanitizeString = (value) => {
  if (typeof value !== "string") return value;

  return sanitizeHtml(value.trim(), {
    allowedTags: [],
    allowedAttributes: {},
  });
};

export const handler = async (event) => {
  try {
    /// ✅ SAFE BODY PARSING
    const body = event.body
      ? JSON.parse(event.body)
      : {};

    /// ✅ JWT USER
    const userId =
      event.requestContext?.authorizer
        ?.jwt?.claims?.sub;

    if (!userId) {
      return {
        statusCode: 401,
        body: JSON.stringify({
          message: "Unauthorized",
        }),
      };
    }

    /// ✅ VALIDATE INPUT
    const validatedBody =
      profileSchema.parse(body);

    /// ✅ SANITIZE INPUT
    const sanitizedFields = {
      name: sanitizeString(
        validatedBody.name
      ),

      phone: sanitizeString(
        validatedBody.phone
      ),

      age: validatedBody.age,

      gender: sanitizeString(
        validatedBody.gender
      ),

      blood_group: sanitizeString(
        validatedBody.blood_group
      ),

      allergies:
        validatedBody.allergies?.map(
          sanitizeString
        ),

      medical_conditions:
        validatedBody.medical_conditions?.map(
          sanitizeString
        ),

      medications:
        validatedBody.medications?.map(
          sanitizeString
        ),

      emergency_contacts:
        validatedBody.emergency_contacts,
    };

    /// ✅ BUILD DYNAMIC UPDATE
    let updateExp = "SET ";

    const expAttrNames = {};
    const expAttrValues = {};

    let first = true;

    for (const key in sanitizedFields) {
      if (
        sanitizedFields[key] !== undefined
      ) {
        if (!first) updateExp += ", ";

        first = false;

        updateExp += `#${key} = :${key}`;

        expAttrNames[`#${key}`] = key;

        expAttrValues[`:${key}`] =
          sanitizedFields[key];
      }
    }

    /// ✅ TIMESTAMP
    if (!first) {
      updateExp += ", #updatedAt = :updatedAt";

      expAttrNames["#updatedAt"] =
        "updatedAt";

      expAttrValues[":updatedAt"] =
        new Date().toISOString();
    }

    if (first) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "No fields to update",
        }),
      };
    }

    /// ✅ UPDATE/UPSERT
    const result = await ddb.send(
      new UpdateCommand({
        TableName:
          process.env.USERS_TABLE,

        Key: {
          userId,
        },

        UpdateExpression: updateExp,

        ExpressionAttributeNames:
          expAttrNames,

        ExpressionAttributeValues:
          expAttrValues,

        ReturnValues: "ALL_NEW",
      })
    );

    return {
      statusCode: 200,

      body: JSON.stringify({
        profile: result.Attributes,
      }),
    };
  } catch (error) {
    console.error(
      "SAVE PROFILE ERROR:",
      error
    );

    /// ✅ ZOD VALIDATION ERROR
    if (error.name === "ZodError") {
      return {
        statusCode: 400,

        body: JSON.stringify({
          message: "Validation failed",
          errors: error.errors,
        }),
      };
    }

    return {
      statusCode: 500,

      body: JSON.stringify({
        message:
          "Failed to save profile",

        error: error.message,
      }),
    };
  }
};