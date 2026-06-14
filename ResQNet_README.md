# 🚑 ResQNet — AI Powered Emergency Response & Hospital Recommendation Platform

![AWS](https://img.shields.io/badge/AWS-Serverless-orange?logo=amazonaws)
![Lambda](https://img.shields.io/badge/AWS-Lambda-FF9900?logo=awslambda)
![DynamoDB](https://img.shields.io/badge/DynamoDB-NoSQL-4053D6?logo=amazondynamodb)
![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?logo=flutter)
![Node.js](https://img.shields.io/badge/Node.js-Backend-green?logo=node.js)
![AI](https://img.shields.io/badge/AI-Powered-purple)
![Event Driven](https://img.shields.io/badge/Event-Driven-success)
![Observability](https://img.shields.io/badge/CloudWatch-Monitoring-blue)
![License](https://img.shields.io/badge/Status-Production%20Style-success)

> **Cloud-native, AI-powered emergency response platform leveraging AWS Serverless, Event-Driven Architecture, Distributed Systems principles, and intelligent hospital recommendations to reduce response time during critical medical situations.**

---

# 📑 Table of Contents

* Why This Project Matters
* Application Screenshots
* Key Features
* Tech Stack
* System Architecture
* Complete User Journey
* Lambda Functions
* Event-Driven Architecture
* Emergency Creation Flow
* AI Triage Engine
* Hospital Ranking Engine
* DynamoDB Design
* API Documentation
* Observability & Monitoring
* CloudWatch Dashboards
* CloudWatch Alarms
* Security
* Distributed Systems Concepts
* Scalability Considerations
* Architecture Decisions
* Project Achievements
* Repository Structure
* Deployment Guide
* Local Setup
* Future Roadmap
* Author

---

# 🌍 Why This Project Matters

Medical emergencies are inherently time-sensitive, where delays in decision-making can significantly impact patient outcomes. Individuals often struggle to determine the most suitable nearby hospital or understand the urgency of their symptoms under stressful conditions.

**ResQNet** addresses this challenge by combining cloud-native infrastructure with AI-assisted medical triage and intelligent hospital recommendation capabilities.

Key benefits include:

* ⚡ Faster emergency request processing through serverless APIs.
* 🧠 AI-assisted severity classification and condition prediction.
* 🏥 Intelligent hospital recommendations based on context and proximity.
* 🔄 Event-driven asynchronous workflows for improved responsiveness.
* 📈 Production-grade monitoring and observability for operational reliability.

The platform demonstrates practical applications of **AWS Serverless**, **Distributed Systems**, **Cloud Architecture**, **AI Integration**, and **Production Engineering Practices**.

---

# 📱 Application Screenshots

| Authentication                         | Authentication                          | Home                                  |
| -------------------------------------- | --------------------------------------- | ------------------------------------- |
| ![](docs/screenshots/login-screen.png) | ![](docs/screenshots/signup-screen.png) | ![](docs/screenshots/home-screen.png) |

| Splash                                  | Location Selection                           | Emergency Form                           |
| --------------------------------------- | -------------------------------------------- | ---------------------------------------- |
| ![](docs/screenshots/splash-screen.png) | ![](docs/screenshots/location-selection.png) | ![](docs/screenshots/emergency-form.png) |

| Hospital Ranking                           | AI Result                           | Hospital Selection                           |
| ------------------------------------------ | ----------------------------------- | -------------------------------------------- |
| ![](docs/screenshots/hospital-ranking.png) | ![](docs/screenshots/ai-result.png) | ![](docs/screenshots/hospital-selection.png) |

---

# ⭐ Key Features

* 🔐 JWT & Cognito Authentication
* 🚨 Emergency Request Creation
* 🤖 AI Medical Triage & Severity Classification
* 🩺 AI-Based Condition Prediction
* 🏥 Intelligent Hospital Recommendation Engine
* 📍 Current & Manual Location Support
* ✅ Hospital Assignment Workflow
* ⚡ Event-Driven Asynchronous AI Processing
* ☁️ AWS Serverless Architecture
* 📊 CloudWatch Monitoring & Dashboards
* 🔔 SNS-Based Operational Alerting
* 📈 Distributed Systems Design Patterns

---

# 🛠️ Tech Stack

## Frontend

* Flutter
* Dart
* Google Maps
* JWT Authentication
* REST APIs

## Backend

* Node.js
* AWS Lambda
* Amazon API Gateway
* Amazon DynamoDB

## AI Layer

* Ollama
* Qwen Models
* Phi Models
* Severity Classification
* Condition Prediction
* Recommended Actions Generation

## AWS Services

* AWS Lambda
* API Gateway
* DynamoDB
* Amazon Cognito
* IAM
* CloudWatch
* SNS

---

# 🏗️ System Architecture

![System Architecture](docs/diagrams/system-architecture.png)

## Architecture Overview

```text
Flutter App
      │
      ▼
API Gateway
      │
      ▼
EmergencyRequest Lambda
      │
      ├────────────► DynamoDB (Initial Record)
      │
      └────────────► Async Invocation
                          │
                          ▼
                processEmergencyAI Lambda
                          │
                    AI Triage Engine
                          │
                          ▼
          Updates EmergencyRequests Table
                          │
                          ▼
               HospitalRanking Lambda
                          │
                          ▼
              Ranked Hospital Response
                          │
                          ▼
               selectHospital Lambda
```

The architecture follows a **serverless, event-driven design**, enabling independent scaling of compute components while minimizing latency for user-facing operations.

---

# 👤 Complete User Journey

![User Journey](docs/diagrams/user-journey.png)

1. User authenticates using Cognito.
2. User selects current or manual location.
3. Emergency details are submitted through the Flutter application.
4. API Gateway invokes the `EmergencyRequest` Lambda.
5. Emergency data is persisted immediately to DynamoDB.
6. `processEmergencyAI` is invoked asynchronously.
7. AI predicts severity, condition, and recommended actions.
8. Emergency record is updated with AI insights.
9. `HospitalRanking` retrieves the enriched emergency context and nearby hospitals.
10. User reviews ranked hospitals and AI recommendations.
11. User selects a hospital.
12. `selectHospital` updates assignment details in DynamoDB.

---

# ⚙️ Lambda Functions

| Function                | Purpose                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------- |
| **EmergencyRequest**    | Creates emergency records and asynchronously invokes AI processing.                                   |
| **processEmergencyAI**  | Performs AI triage, predicts severity and condition, generates recommendations, and updates DynamoDB. |
| **HospitalRanking**     | Reads emergency context and returns ranked nearby hospitals.                                          |
| **selectHospital**      | Assigns the selected hospital to the emergency request.                                               |
| **saveUserProfile**     | Stores user profile information.                                                                      |
| **getUserProfile**      | Retrieves user profile details.                                                                       |

## EmergencyRequest

* **Purpose:** Create emergency requests.
* **Input:** Patient details, symptoms, location.
* **Output:** Emergency ID.
* **Responsibilities:** Persist initial record and invoke AI asynchronously.

## processEmergencyAI

* **Purpose:** AI-based medical triage.
* **Input:** Emergency identifier.
* **Output:** Severity classification and recommendations.
* **Responsibilities:** Execute LLM inference and update the `EmergencyRequests` table.

## HospitalRanking

* **Purpose:** Rank nearby hospitals.
* **Input:** Emergency ID and patient context.
* **Output:** Ordered hospital list.
* **Responsibilities:** Read DynamoDB state and compute rankings.

## selectHospital

* **Purpose:** Finalize hospital assignment.
* **Input:** Emergency ID and selected hospital.
* **Output:** Updated assignment status.
* **Responsibilities:** Persist assignment metadata.

---

# ⚡ Event-Driven Architecture

## Current Architecture

```text
EmergencyRequest Lambda
        │
        ▼
Asynchronous Lambda Invocation
        │
        ▼
processEmergencyAI Lambda
```

### Benefits

* Non-blocking APIs
* Faster perceived response times
* Independent scaling
* Fault isolation
* Improved user experience
* Reduced frontend waiting time

## Future Architecture

```text
Emergency Created
        │
        ▼
Amazon EventBridge
   ├────────► AI Processing
   ├────────► Hospital Ranking
   ├────────► Notifications
   ├────────► Analytics
   └────────► Audit Pipelines
```

**Future Diagram Placeholder**

```
docs/diagrams/eventbridge-architecture.png
```

---

# 🚨 Emergency Creation Flow

![Emergency Sequence](docs/diagrams/emergency-sequence.png)

1. User submits emergency.
2. API Gateway routes request.
3. EmergencyRequest Lambda validates input.
4. Emergency stored in DynamoDB with:

```json
{
  "severity": "PENDING",
  "severityScore": 0,
  "aiProcessed": false
}
```

5. Asynchronous AI processing begins.
6. API immediately returns the Emergency ID.

---

# 🤖 AI Triage Engine

![AI Triage](docs/diagrams/ai-triage-flow.png)

## Pipeline

* Capture emergency symptoms.
* Construct AI prompt.
* Execute Ollama/Qwen/Phi inference.
* Predict severity.
* Predict likely condition.
* Generate recommended actions.
* Update DynamoDB.

## Example Response

```json
{
  "severity": "HIGH",
  "severityScore": 82,
  "possibleCondition": "Acute cardiac event",
  "recommendedAction": "Proceed to the nearest emergency department immediately.",
  "aiProcessed": true
}
```

---

# 🏥 Hospital Ranking Engine

![Hospital Ranking](docs/diagrams/hospital-ranking-engine.png)

![Ranking Sequence](docs/diagrams/hospital-ranking-sequence.png)

Hospital recommendations consider:

* 📍 Distance factor
* 🚨 Severity factor
* 🏥 Hospital availability
* 🩺 Emergency context
* 📊 AI-generated recommendations

The ranking engine combines these attributes to produce prioritized hospital suggestions for the user.

---

# 🗄️ DynamoDB Design

## Primary Keys

| Key           | Value         |
| ------------- | ------------- |
| Partition Key | `userId`      |
| Sort Key      | `emergencyId` |

## Important Attributes

| Attribute            | Description                                    |
| -------------------- | ---------------------------------------------- |
| userId               | User identifier                                |
| emergencyId          | Emergency identifier                           |
| createdAt            | Timestamp                                      |
| symptoms             | `List<String>`                                 |
| patientType          | `self`, `family`, `other`                      |
| location             | `{ lat, lng }`                                 |
| severity             | AI severity                                    |
| severityScore        | Numeric severity                               |
| possibleCondition    | AI prediction                                  |
| recommendedAction    | AI recommendation                              |
| aiProcessed          | AI completion flag                             |
| ambulancePreference  | String                                         |
| selectedHospitalId   | Assigned hospital                              |
| selectedHospitalName | Assigned hospital                              |
| selectedAt           | Assignment timestamp                           |
| status               | `PENDING`, `ASSIGNED`, `RESOLVED`, `CANCELLED` |

---

# 📚 API Documentation

<details>
<summary><strong>POST /emergency</strong></summary>

Creates a new emergency request.

```json
{
  "symptoms": ["chest pain"],
  "patientType": "self"
}
```

Returns:

```json
{
  "emergencyId": "emergency_123"
}
```

</details>

<details>
<summary><strong>GET /emergency/{id}</strong></summary>

Returns the latest emergency details, including AI-generated insights.

</details>

<details>
<summary><strong>POST /selectHospital</strong></summary>

Assigns a hospital to an emergency request.

</details>

<details>
<summary><strong>GET /emergency/history</strong></summary>

Returns historical emergency records for the authenticated user.

</details>

<details>
<summary><strong>GET /user/profile</strong></summary>

Retrieves the current user profile.

</details>

<details>
<summary><strong>PUT /user/profile</strong></summary>

Updates user profile information.

</details>

---

# 📈 Observability & Monitoring

ResQNet incorporates production-oriented observability practices using CloudWatch.

## CloudWatch Metrics

* Lambda Invocations
* Lambda Duration
* Lambda Errors
* Lambda Throttles

## Business Metrics

Namespace:

```text
ResQNet
```

Examples:

```text
emergency_created
ai_processed
hospital_selected
```

## Custom Metrics

* Emergency creation throughput
* AI processing success rate
* Hospital assignment rate
* AI latency distribution

Metric Filters enable operational dashboards and alerting pipelines.

---

# 📊 CloudWatch Dashboards

| Dashboard           | Screenshot                                       |
| ------------------- | ------------------------------------------------ |
| System Dashboard    | ![](docs/aws/cloudwatch-dashboard-system.png)    |
| AI Dashboard        | ![](docs/aws/cloudwatch-dashboard-ai.png)        |
| Business Dashboard  | ![](docs/aws/cloudwatch-dashboard-business.png)  |
| Executive Dashboard | ![](docs/aws/cloudwatch-dashboard-executive.png) |

### System Dashboard

Monitors Lambda invocations, errors, throttles, and execution duration.

### AI Dashboard

Tracks inference latency, AI failures, severity distribution, and processing volume.

### Business Dashboard

Visualizes:

* Emergencies created
* AI processed
* Hospital selections
* Assignment success rates

### Executive Dashboard

Aggregates platform KPIs including AI success rate, emergency throughput, and hospital assignment metrics.

---

# 🚨 CloudWatch Alarms

![](docs/aws/cloudwatch-alarms.png)

Configured alarms include:

* Emergency API Errors
* AI Processing Failures
* High AI Latency
* Lambda Throttling
* Hospital Ranking Failures

All alarms publish notifications via **Amazon SNS**, enabling rapid operational awareness and email alerts for engineering teams.

---

# 🔐 Security

* Amazon Cognito Authentication
* JWT Validation
* IAM Least Privilege Policies
* HTTPS API Endpoints
* Lambda Execution Isolation
* Principle of Least Privilege
* Secure API Gateway Integration

---

# 🌐 Distributed Systems Concepts

ResQNet demonstrates several core distributed systems principles:

| Concept              | Application in ResQNet                                             |
| -------------------- | ------------------------------------------------------------------ |
| Eventual Consistency | Emergency records are enriched asynchronously after creation.      |
| Async Processing     | AI triage executes independently of synchronous API requests.      |
| Stateless Services   | Lambda functions maintain no session state.                        |
| Fault Isolation      | AI failures do not block emergency creation.                       |
| Independent Scaling  | AI workloads and API workloads scale separately.                   |
| Loose Coupling       | Components communicate through asynchronous invocation boundaries. |

---

# 📈 Scalability Considerations

## Current

* AWS Lambda auto scaling
* DynamoDB managed scaling
* Asynchronous AI processing
* Stateless compute services

## Future Enhancements

* Amazon EventBridge
* AWS Step Functions
* WebSocket updates
* Multi-region deployments
* ML-native severity prediction
* Global failover
* Ambulance dispatch integration

---

# 🧠 Architecture Decisions

## Why AWS Lambda?

* Automatic scaling
* Pay-per-use pricing
* Reduced infrastructure management
* Fast deployment cycles

## Why DynamoDB?

* Low-latency reads and writes
* Horizontally scalable architecture
* Flexible schema evolution

## Why Asynchronous AI Processing?

* Minimizes API latency
* Improves frontend responsiveness
* Enables compute isolation

## Why Event-Driven Design?

* Loose coupling
* Independent services
* Easier extensibility
* Better resilience

## Why CloudWatch?

* Centralized monitoring
* Operational visibility
* Metrics and alarms
* Business observability

---

# 🏆 Project Achievements

* ✅ AI-powered emergency triage workflow
* ✅ Event-driven serverless architecture
* ✅ Intelligent hospital recommendation engine
* ✅ Production-style CloudWatch dashboards
* ✅ SNS-backed alerting strategy
* ✅ Distributed systems design patterns
* ✅ AWS-native backend implementation
* ✅ AI integration with asynchronous processing
* ✅ Fault-isolated cloud architecture
* ✅ Interview-ready system design showcasing scalability and observability

---

# 📂 Repository Structure

```text
resqnet/
│
├── mobile/
├── backend/
├── infrastructure/
├── aws/
│
├── docs/
│   ├── diagrams/
│   │   ├── system-architecture.png
│   │   ├── user-journey.png
│   │   ├── emergency-sequence.png
│   │   ├── ai-triage-flow.png
│   │   ├── hospital-ranking-engine.png
│   │   ├── hospital-ranking-sequence.png
│   │   └── eventbridge-architecture.png
│   │
│   ├── screenshots/
│   │   ├── splash-screen.png
│   │   ├── login-screen.png
│   │   ├── signup-screen.png
│   │   ├── home-screen.png
│   │   ├── location-selection.png
│   │   ├── emergency-form.png
│   │   ├── hospital-ranking.png
│   │   ├── ai-result.png
│   │   └── hospital-selection.png
│   │
│   └── aws/
│       ├── cloudwatch-dashboard-system.png
│       ├── cloudwatch-dashboard-ai.png
│       ├── cloudwatch-dashboard-business.png
│       ├── cloudwatch-dashboard-executive.png
│       └── cloudwatch-alarms.png
│
└── README.md
```

---

# 🚀 Deployment Guide

## AWS SAM

```bash
sam build
sam deploy --guided
```

## Serverless Framework

```bash
serverless deploy
```

---

# 💻 Local Setup

## Backend

```bash
cd backend
npm install
npm run dev
```

## Flutter

```bash
cd mobile
flutter pub get
flutter run
```

---

# 🛣️ Future Roadmap

* Amazon EventBridge integration
* Ambulance dispatch services
* Real-time notifications
* WebSocket support
* AWS Step Functions orchestration
* Multi-region deployment
* ML-based severity prediction
* Advanced analytics pipelines
* Predictive hospital capacity modeling

---

# 👩‍💻 Author

**Pratiksha Andhare**

**Software Engineer**

Specializing in:

* DevOps & Observability
* AWS Serverless
* Cloud Architecture
* Distributed Systems
* AI Integration
* Production-Grade System Design
