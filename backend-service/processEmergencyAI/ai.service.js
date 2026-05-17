import axios from "axios";

export const getTriageAI =
  async (data) => {
    try {
      const compactData = {
        symptoms:
          data.symptoms || [],

        ageGroup:
          data.ageGroup ||
          "unknown",

        conscious:
          data.conscious,

        breathing:
          data.breathing,

        patientType:
          data.patientType ||
          "unknown",
      };

      const prompt = `
You are an emergency medical triage AI.

Analyze patient symptoms and return ONLY valid JSON.

Severity levels:
LOW = minor
MEDIUM = moderate
HIGH = urgent
CRITICAL = life-threatening

Medical rules:
- Chest pain + sweating + age > 40 => HIGH or CRITICAL
- Breathing difficulty => HIGH or CRITICAL
- Unconscious => CRITICAL
- Stroke symptoms => CRITICAL
- Severe bleeding => CRITICAL

Patient:
${JSON.stringify(compactData)}

Return ONLY this JSON format:
{
  "severity": "LOW|MEDIUM|HIGH|CRITICAL",
  "possibleCondition": "condition",
  "recommendedAction": "action"
}
`;

      const response =
        await axios.post(
          process.env.OLLAMA_URL,

          {
            model: "qwen2.5:3b",

            prompt,

            stream: false,

            options: {
              temperature: 0,
              num_predict: 80,
              top_p: 0.9,
            },
          },

          {
            timeout: 120000,
          }
        );

      console.log(
        "RAW AI:",
        response.data
      );

      let aiText =
        response.data.response || "";

      aiText = aiText
        .replace(/```json/g, "")
        .replace(/```/g, "")
        .trim();

      console.log(
        "CLEANED AI TEXT:",
        aiText
      );

      const parsed =
        JSON.parse(aiText);

      const validSeverities = [
        "LOW",
        "MEDIUM",
        "HIGH",
        "CRITICAL",
      ];

      let severity = "MEDIUM";

      if (
        parsed.severity &&
        validSeverities.includes(
          parsed.severity
        )
      ) {
        severity =
          parsed.severity;
      }

      const severityScoreMap = {
        LOW: 25,
        MEDIUM: 50,
        HIGH: 75,
        CRITICAL: 95,
      };

      return {
        severity,

        severityScore:
          severityScoreMap[
            severity
          ],

        possibleCondition:
          parsed.possibleCondition ||
          "Unknown condition",

        recommendedAction:
          parsed.recommendedAction ||
          "Seek immediate medical attention",
      };
    } catch (err) {
      console.log(
        "AI SERVICE ERROR:",
        err.message
      );

      return {
        severity: "MEDIUM",

        severityScore: 50,

        possibleCondition:
          "Unknown condition",

        recommendedAction:
          "Seek medical attention",
      };
    }
  };