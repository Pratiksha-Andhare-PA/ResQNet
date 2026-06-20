# 🚑 ResQNet — AI Powered Emergency Response & Hospital Recommendation Platform

![AWS](https://img.shields.io/badge/AWS-Serverless-orange?logo=amazonaws)
![Lambda](https://img.shields.io/badge/AWS-Lambda-FF9900?logo=awslambda)
![DynamoDB](https://img.shields.io/badge/DynamoDB-NoSQL-4053D6?logo=amazondynamodb)
![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?logo=flutter)
![Node.js](https://img.shields.io/badge/Node.js-Backend-green?logo=node.js)
![AI](https://img.shields.io/badge/AI-Powered-purple)
![Async Processing](https://img.shields.io/badge/Async-Processing-success)
![Observability](https://img.shields.io/badge/CloudWatch-Monitoring-blue)
![License](https://img.shields.io/badge/Status-Production%20Style-success)

> **Cloud-native, AI-powered emergency response platform leveraging AWS Serverless, Asynchronous processing patterns, Distributed Systems principles, and intelligent hospital recommendations to reduce response time during critical medical situations.**

---

# 📑 Table of Contents

- [Why ResQNet](#why-this-project-matters)
- [Application UI](#application-screenshots)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [System Architecture](#system-architecture)
- [Complete User Journey](#complete-user-journey)
- [Lambda Functions](#lambda-functions)
- [Asynchronous Processing Architecture](#asynchronous-processing-architecture)
- [Emergency Creation Flow](#emergency-creation-flow)
- [AI Triage Engine](#ai-triage-engine)
- [Hospital Ranking Engine](#hospital-ranking-engine)
- [DynamoDB Design](#dynamodb-design)
- [API Documentation](#api-documentation)
- [Observability & Monitoring](#observability-monitoring)
- [CloudWatch Dashboards](#cloudwatch-dashboards)
- [CloudWatch Alarms](#cloudwatch-alarms)
- [Security](#security)
- [Distributed Systems Concepts](#distributed-systems-concepts)
- [Scalability Considerations](#scalability-considerations)
- [Architecture Decisions](#architecture-decisions)
- [Project Achievements](#project-achievements)
- [Repository Structure](#repository-structure)
- [Local Setup](#local-setup)
- [Future Roadmap](#future-roadmap)
- [Author](#author)

---

<a id="why-this-project-matters"></a>
# 🌍 Why ResQNet?

Medical emergencies are inherently time-sensitive, where delays in decision-making can significantly impact patient outcomes. Individuals often struggle to determine the most suitable nearby hospital or understand the urgency of their symptoms under stressful conditions.

**ResQNet** addresses this challenge by combining cloud-native infrastructure with AI-assisted medical triage and intelligent hospital recommendation capabilities.

Key benefits include:

* ⚡ Faster emergency request processing through serverless APIs.
* 🧠 AI-assisted severity classification and condition prediction.
* 🏥 Intelligent hospital recommendations based on context and proximity.
* 🔄 Asynchronous workflows for improved responsiveness.
* 📈 Production-grade monitoring and observability for operational reliability.

The platform demonstrates practical applications of **AWS Serverless**, **Distributed Systems**, **Cloud Architecture**, **AI Integration**, and **Production Engineering Practices**.

---

<a id="application-screenshots"></a>

# 📱 Application UI

The following screenshots showcase the complete user journey through **ResQNet**, from authentication and profile setup to AI-assisted emergency reporting and intelligent hospital recommendations.

---

## 🚀 App Launch & Authentication

<table>
<tr>
<td><img src="Images/1_splash_screen.jpeg" width="220"/></td>
<td><img src="Images/2_Login.jpeg" width="220"/></td>
<td><img src="Images/3_OTP.jpeg" width="220"/></td>
<td><img src="Images/4_SOS.jpeg" width="220"/></td>
</tr>
</table>

---

## 👤 Profile Management

<table>
<tr>
<td><img src="Images/5_1_Profile.jpeg" width="280"/></td>
<td><img src="Images/5_2_Profile.jpeg" width="280"/></td>
<td><img src="Images/5_3_Profile_saved.jpeg" width="280"/></td>
</tr>

<tr>
<td><img src="Images/5_4_Profile_view.jpeg" width="220"/></td>
<td><img src="Images/5_5_Profile_view.jpeg" width="220"/></td>
<td><img src="Images/5_6_Profile_edit.jpeg" width="220"/></td>
<td><img src="Images/5_7_Profile_edit.jpeg" width="220"/></td>
</tr>
</table>

---

## 📍 Location Selection

<table>
<tr>
<td><img src="Images/6_1_Location.jpeg" width="220"/></td>
<td><img src="Images/6_2_search_location.jpeg" width="220"/></td>
<td><img src="Images/6_3_select_location.jpeg" width="220"/></td>
<td><img src="Images/6_4_confirm_location.jpeg" width="220"/></td>
</tr>
</table>

---

## 🚨 Emergency Reporting

<table>
<tr>
<td><img src="Images/7_1_emergency_form.jpeg" width="220"/></td>
<td><img src="Images/7_2_emergency_form.jpeg" width="220"/></td>
<td><img src="Images/7_3_Age.jpeg" width="220"/></td>
</tr>

<tr>
<td><img src="Images/7_4_Ambulance.jpeg" width="220"/></td>
<td><img src="Images/7_5_filled form.jpg" width="280"/></td>
</tr>
</table>

---

## 🏥 Nearby Hospital Recommendations

<table>
<tr>
<td><img src="Images/8_1_Nearby Hospitals.jpeg" width="280"/></td>
<td><img src="Images/8_2_Nearby Hospitals.jpeg" width="280"/></td>
<td><img src="Images/8_3_Nearby Hospitals.jpeg" width="280"/></td>
</tr>
</table>

---

## 🤖 AI Assessment & Smart Ranking

<table>
<tr>
<td><img src="Images/9_1_AI assessment.jpeg" width="280"/></td>
<td><img src="Images/9_2_AI assessment.jpeg" width="280"/></td>
<td><img src="Images/9_2_AI Ranking.jpeg" width="280"/></td>
</tr>
</table>

---

## ✅ Hospital Selection & Confirmation

<table>
<tr>
<td><img src="Images/10_select_hospital.jpeg" width="320"/></td>
<td><img src="Images/11_selected_hospital.jpeg" width="320"/></td>
</tr>
</table>

---
### ✨ Highlights

- 🔐 Secure Authentication with OTP Verification
- 👤 User Profile Management
- 📍 Manual & Current Location Selection
- 🚨 Emergency Request Creation
- 🤖 AI-Powered Medical Assessment
- 🏥 Intelligent Hospital Ranking Engine
- 🚑 Smart Hospital Selection Workflow
- ☁️ Real-Time Serverless Backend Integration

---

<a id="key-features"></a>
# ⭐ Key Features

* 🔐 JWT & Cognito Authentication
* 🚨 Emergency Request Creation
* 🤖 AI Medical Triage & Severity Classification
* 🩺 AI-Based Condition Prediction
* 🏥 Intelligent Hospital Recommendation Engine
* 📍 Current & Manual Location Support
* ✅ Hospital Assignment Workflow
* ⚡ Asynchronous AI Processing
* ☁️ AWS Serverless Architecture
* 📊 CloudWatch Monitoring & Dashboards
* 🔔 SNS-Based Operational Alerting
* 📈 Distributed Systems Design Patterns

---

<a id="tech-stack"></a>
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

* Ollama (Qwen Model: qwen2.5:3b)
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

<a id="system-architecture"></a>
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

The architecture follows a **serverless and asynchronous processing model**, enabling independent scaling of compute components while minimizing latency for user-facing operations.
Emergency requests are persisted immediately and AI triage executes asynchronously through Lambda invocation, reducing user-facing latency while enabling independent scaling of AI workloads.

---

<a id="complete-user-journey"></a>
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

<a id="lambda-functions"></a>
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

<a id="asynchronous-processing-architecture"></a>
# ⚡ Asynchronous Processing Architecture

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
---

<a id="emergency-creation-flow"></a>
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

<a id="ai-triage-engine"></a>
# 🤖 AI Triage Engine

![AI Triage](docs/diagrams/ai-triage-flow.png)

## Pipeline

* Capture emergency symptoms.
* Construct AI prompt.
* Execute Ollama inference.
* Predict severity.
* Predict likely condition.
* Generate recommended actions.
* Update DynamoDB.

## Example Response

```json
{
  "severity": "CRITICAL",
  "severityScore": 95,
  "possibleCondition": "Unconscious with potential stroke symptoms",
  "recommendedAction": "Immediate medical attention required, call emergency services.",
  "aiProcessed": true
}
```

---

<a id="hospital-ranking-engine"></a>
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

<a id="dynamodb-design"></a>
# 🗄️ DynamoDB Design

## Primary Keys

| Key           | Value         |
| ------------- | ------------- |
| Partition Key | `userId`      |
| Sort Key      | `emergencyId` |

## Important Attributes

| Attribute            | Description                                    |
| -------------------- | ---------------------------------------------- |
| userId               | User identifier (Partition Key)                |
| emergencyId          | Emergency identifier (Sort Key)                |
| ageGroup             | Patient Age Category                           |
| aiProcessed          | AI Processing Status                           |
| ambulancePreference  | Ambulance Preference                           |
| breathing            | Breathing Status                               |
| conscious            | Conscious State                                |
| createdAt            | Emergency Creation Timestamp                   |
| location             | `{ lat, lng }`                                 |
| patientType          | `self` / `Someone else`                        |
| possibleCondition    | AI prediction Condition                        |
| recommendedAction    | AI recommendation                              |
| selectedAt           | Hospital Assignment timestamp                  |
| selectedHospitalId   | Assigned Hospital ID                           |
| selectedHospitalName | Assigned Hospital Name                         |
| severity             | AI Predicted Severity                          |
| severityScore        | Severity Score (0 - 100)                       |
| status               | `PENDING`, `ASSIGNED`, `RESOLVED`, `CANCELLED` |
| symptoms             | Emergency Symptoms                             |

---

<a id="api-documentation"></a>
# 📚 API Documentation

<details>
<summary><strong>POST /emergency</strong></summary>

Creates a new emergency request and initiates the emergency processing workflow.

### Request

```json
{
  "location": {
    "lat": 18.5204,
    "lng": 73.8567
  },
  "symptoms": [
    "chest pain",
    "shortness of breath"
  ],
  "patientType": "self",
  "ageGroup": "adult",
  "conscious": true,
  "breathing": true,
  "ambulancePreference": true
}
```

### Response

```json
{
  "success": true,
  "emergencyId": "emergency_1781191591061"
}
```

### Processing Flow

1. Emergency record is created in DynamoDB.
2. API returns immediately to the user.
3. `processEmergencyAI` Lambda is invoked asynchronously.
4. AI triage updates the emergency record later.

</details>

<details>
<summary><strong>GET /emergency/{id}</strong></summary>

Returns the latest emergency details, including AI-generated severity assessment and hospital assignment information.

> GET /emergency/{id}

### Example Request

```http
GET /emergency/emergency_1781191591061
```

### Response

```json
{
  "userId": "user5",
  "emergencyId": "emergency_1781191591061",
  "createdAt": "2026-06-11T15:26:31.061Z",
  "symptoms": [
    "chest pain"
  ],
  "severity": "HIGH",
  "severityScore": 82,
  "possibleCondition": "Acute Cardiac Event",
  "recommendedAction": "Proceed to the nearest emergency department immediately.",
  "aiProcessed": true,
  "selectedHospitalId": "H001",
  "selectedHospitalName": "City Hospital"
}
```

</details>

<details>
<summary><strong>GET /hospitals/ranked</strong></summary>

Returns hospitals ranked according to emergency severity, distance, and availability.

### Example Request

```http
GET /hospitals/ranked?emergencyId=emergency_1781191591061
```

### Response

```json
{
  "hospitals": [
    {
      "hospitalId": "H001",
      "hospitalName": "City Hospital",
      "distanceKm": 2.1,
      "score": 94
    },
    {
      "hospitalId": "H002",
      "hospitalName": "Care Hospital",
      "distanceKm": 3.4,
      "score": 89
    }
  ]
}
```

### Ranking Factors

* Distance from emergency location
* AI-generated severity score
* Hospital availability
* Emergency context

</details>

<details>
<summary><strong>POST /selectHospital</strong></summary>

Assigns a hospital to an emergency request.

### Request

```json
{
  "emergencyId": "emergency_1781191591061",
  "hospitalId": "H001",
  "hospitalName": "City Hospital"
}
```

### Response

```json
{
  "success": true,
  "message": "Hospital assigned successfully"
}
```

### DynamoDB Update

```json
{
  "selectedHospitalId": "H001",
  "selectedHospitalName": "City Hospital",
  "selectedAt": "2026-06-15T10:20:00Z",
  "status": "ASSIGNED"
}
```

</details>

---

<a id="observability-monitoring"></a>
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

<a id="cloudwatch-dashboards"></a>
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

<a id="cloudwatch-alarms"></a>
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

<a id="security"></a>
# 🔐 Security

* Amazon Cognito Authentication
* JWT Validation
* IAM Least Privilege Policies
* HTTPS API Endpoints
* Lambda Execution Isolation
* Principle of Least Privilege
* Secure API Gateway Integration

---

<a id="distributed-systems-concepts"></a>
# 🌐 Distributed Systems Concepts

ResQNet demonstrates several core distributed systems principles:

| Concept                 | Application in ResQNet                                             |
| ----------------------- | ------------------------------------------------------------------ |
| Eventual Consistency    | Emergency records are enriched asynchronously after creation.      |
| Async Processing        | AI triage executes independently of synchronous API requests.      |
| Stateless Services      | Lambda functions maintain no session state.                        |
| Fault Isolation         | AI failures do not block emergency creation.                       |
| Independent Scaling     | AI workloads and API workloads scale separately.                   |
| Loose Coupling          | Components communicate through asynchronous invocation boundaries. |
| Async Messaging Pattern | AI processing occurs asynchronously after request creation.        |

---

<a id="scalability-considerations"></a>
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

<a id="architecture-decisions"></a>
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

* Minimizes API response latency
* Improves frontend responsiveness
* Prevents AI workloads from blocking requests
* Enables independent scaling of compute workloads
* Improves fault isolation

## Why CloudWatch?

* Centralized monitoring
* Operational visibility
* Metrics and alarms
* Business observability

---

<a id="project-achievements"></a>
# 🏆 Project Achievements

* ✅ AI-powered emergency triage workflow
* ✅ Asynchronous AI Processing Architecture
* ✅ Serverless Distributed System Design
* ✅ Intelligent hospital recommendation engine
* ✅ Production-style CloudWatch dashboards
* ✅ SNS-backed alerting strategy
* ✅ Distributed systems design patterns
* ✅ AWS-native backend implementation
* ✅ AI integration with asynchronous processing
* ✅ Fault-isolated cloud architecture
* ✅ Interview-ready system design showcasing scalability and observability

---

<a id="repository-structure"></a>
# 📂 Repository Structure

```text
resqnet/
│
├── backend/
│   ├── emergency-service/              # Emergency creation service
│   ├── getUserProfile/                 # User profile retrieval
│   ├── hospital-ranking-service/       # Hospital recommendation engine
│   ├── processEmergencyAI/             # AI triage processing service
│   ├── saveUserProfile/                # User profile management
│   └── selectHospital/                 # Hospital assignment service
│
├── docs/
│   ├── diagrams/
│   │   ├── ai-triage-flow.png
│   │   ├── emergency-sequence.png
│   │   ├── hospital-ranking-engine.png
│   │   ├── hospital-ranking-sequence.png
│   │   ├── system-architecture.png
│   │   └── user-journey.png
│   │
│   └── screenshots/
│       ├── aws-monitoring/
│       └── UI_screens/
│
├── frontend/
│   └── resq_net/                       # Flutter mobile application
│
└── README.md
```

---

<a id="local-setup"></a>
# 💻 Local Setup

## Backend Services

Each Lambda function is maintained as an independent service.

```bash
cd emergency-service
npm install

cd ../processEmergencyAI
npm install

cd ../hospital-ranking-service
npm install
```

## Flutter

```bash
cd mobile
flutter pub get
flutter run
```

---

<a id="future-roadmap"></a>
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

<a id="author"></a>
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

---