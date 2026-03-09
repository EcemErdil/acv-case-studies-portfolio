# Data Dictionary

This document describes the variables used in the electricity consumption anomaly analysis dataset.

| Column Name | Description |
|-------------|-------------|
| tesisat_no_id | Unique installation identifier |
| load_profile_date | Measurement date |
| il | Province |
| ilce | District |
| abone_grubu | Subscriber group |
| sayac_marka | Meter brand |
| gerilim_seviyesi | Voltage level |
| avg_current | Average current value |
| avg_voltage | Average voltage value |
| reactive_ratio | Reactive energy ratio |
| t0_diff | Consumption difference |
| phase_imbalance | Phase imbalance indicator |
| night_ratio | Night consumption ratio |
| steady_consumption_flag | Indicates steady consumption pattern |
| voltage_missing_consumption_flag | Consumption observed when voltage missing |
| phase_zero_flag | Phase zero anomaly indicator |
| dq_flag_negative_t0 | Negative consumption indicator |
| risk_score | Calculated anomaly risk score |
| anomaly_type | Anomaly classification |
