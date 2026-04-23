const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.USER_TABLE;

async function getUser(userId) {

  const params = {
    TableName: TABLE_NAME,
    Key: {
      userId
    }
  };

  const result = await dynamo.get(params).promise();

  return result.Item;
}

module.exports = {
  getUser
};