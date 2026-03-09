# Methodology

This project analyzes electricity consumption patterns to detect anomalies and generate operational insights for electricity distribution monitoring.

The analysis follows a structured analytical pipeline consisting of several stages.

---

## 1. Data Understanding

The dataset contains electricity meter measurements collected from smart meter load profiles.

Each record represents a consumption measurement for a specific installation and timestamp.

The dataset includes:

- installation identifiers
- province and district information
- subscriber group
- meter brand
- voltage measurements
- current measurements
- active and reactive energy values

---

## 2. Data Cleaning

Data quality checks were performed before analysis.

Main steps include:

- missing value analysis
- duplicate detection
- outlier inspection
- schema validation
- type conversion

Voltage variables were observed to contain significant missing values and were handled carefully during preprocessing.

---

## 3. Feature Engineering

Several analytical features were derived to capture abnormal electricity consumption patterns.

Key engineered features include:

- average current (`avg_current`)
- average voltage (`avg_voltage`)
- phase imbalance indicator (`phase_imbalance`)
- voltage deviation
- reactive energy ratio (`reactive_ratio`)
- consumption difference (`t0_diff`)
- night consumption ratio (`night_ratio`)

Additional temporal features were also created:

- date
- hour
- weekday
- weekend indicator
- time bucket

These features allow the detection of electrical and behavioral anomalies.

---

## 4. Rule-Based Anomaly Detection

The project uses interpretable rule-based anomaly detection.

Example anomaly signals include:

- high current but low consumption
- consumption observed without voltage measurement
- strong phase imbalance
- abnormal reactive energy ratios

Each anomaly contributes to a calculated **risk score** used to prioritize installations for operational investigation.

---

## 5. SQL Analytical Layer

SQL queries were used to generate analytical pivot tables for reporting and visualization.

These include:

- anomaly type distribution
- regional anomaly counts
- subscriber group risk analysis
- meter brand anomaly distribution
- daily anomaly trends
- top risky installations

These summaries are used as inputs for the dashboard layer.

---

## 6. Dashboard Development

A Power BI dashboard was developed to translate analytical findings into operational insights.

The dashboard provides:

- anomaly monitoring
- regional anomaly analysis
- time trend analysis
- technical signal diagnostics
- installation-level investigation

The dashboard enables operational teams to identify installations that require field inspection.
