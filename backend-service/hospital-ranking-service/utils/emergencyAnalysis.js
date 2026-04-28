function analyzeEmergency(context) {
    const symptoms = context.symptoms || [];

    let severity = "LOW";
    let needsICU = false;

    if(symptoms.includes("Chest Pain")) {
        severity = "HIGH";
        needsICU = true;
    }

    if(symptoms.includes("Breathing Problem")) {
        severity = "HIGH";
        needsICU = true;
    }

    if(symptoms.includes("Accident")) {
        severity = "HIGH";
        needsICU = true;
    }

    if (symptoms.includes("Stroke Signs")) {
        severity = "HIGH";
        needsICU = true;
    }

    return { severity, needsICU };

}

module.exports = analyzeEmergency;