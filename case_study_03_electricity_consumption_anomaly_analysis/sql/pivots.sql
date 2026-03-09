-- YEDAŞ Proje 3 — Pivot Sorguları
-- final_dataset tablosu üzerinden çalışır

-- === pvt_anomaly_type ===
SELECT
            anomaly_type,
            COUNT(*) AS kayit_sayisi,
            ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS oran_pct,
            ROUND(AVG(risk_score), 2) AS ort_risk_score
        FROM final_dataset
        GROUP BY anomaly_type
        ORDER BY kayit_sayisi DESC;

-- === pvt_il_ilce ===
SELECT
            il, ilce,
            COUNT(*) AS toplam_kayit,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS anomali_kayit,
            ROUND(SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS anomali_oran_pct,
            ROUND(AVG(risk_score), 2) AS ort_risk_score,
            SUM(CASE WHEN anomaly_type='kacak' THEN 1 ELSE 0 END) AS kacak_sayisi,
            SUM(CASE WHEN anomaly_type='ekipman_ariza' THEN 1 ELSE 0 END) AS ekipman_sayisi,
            SUM(CASE WHEN anomaly_type='sayac_hatasi' THEN 1 ELSE 0 END) AS sayac_sayisi,
            SUM(CASE WHEN anomaly_type='suspicious' THEN 1 ELSE 0 END) AS sup_sayisi
        FROM final_dataset
        GROUP BY il, ilce
        ORDER BY ort_risk_score DESC;

-- === pvt_daily_trend ===
SELECT
            DATE(load_profile_date) AS date_only,
            COUNT(*) AS toplam_kayit,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS anomali_sayisi,
            ROUND(AVG(risk_score), 2) AS ort_risk_score,
            SUM(CASE WHEN anomaly_type='kacak' THEN 1 ELSE 0 END) AS kacak,
            SUM(CASE WHEN anomaly_type='ekipman_ariza' THEN 1 ELSE 0 END) AS ekipman,
            SUM(CASE WHEN anomaly_type='sayac_hatasi' THEN 1 ELSE 0 END) AS sayac,
            SUM(CASE WHEN anomaly_type='suspicious' THEN 1 ELSE 0 END) AS suspicious
        FROM final_dataset
        GROUP BY DATE(load_profile_date)
        ORDER BY DATE(load_profile_date);

-- === pvt_top10 ===
SELECT
            tesisat_no_id,
            MAX(il) AS il,
            MAX(ilce) AS ilce,
            anomaly_type,
            ROUND(MAX(risk_score), 2) AS max_risk_score,
            ROUND(AVG(risk_score), 2) AS ort_risk_score,
            COUNT(*) AS anomali_kayit_sayisi,
            MAX(risk_reason) AS risk_reason,
            MAX(abone_grubu) AS abone_grubu,
            MAX(marka) AS marka,
            MAX(model) AS model
        FROM final_dataset
        WHERE anomaly_type NOT IN ('normal')
        GROUP BY tesisat_no_id, anomaly_type
        ORDER BY ort_risk_score DESC
        LIMIT 10;

-- === pvt_abone_grubu ===
SELECT
            abone_grubu,
            COUNT(*) AS toplam_kayit,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS anomali_kayit,
            ROUND(AVG(risk_score), 2) AS ort_risk_score,
            SUM(CASE WHEN anomaly_type='kacak' THEN 1 ELSE 0 END) AS kacak_sayisi,
            SUM(CASE WHEN risk_bucket='High' THEN 1 ELSE 0 END) AS yuksek_risk_sayisi
        FROM final_dataset
        GROUP BY abone_grubu
        ORDER BY ort_risk_score DESC;

-- === pvt_sayac_marka ===
SELECT
            marka, model,
            COUNT(*) AS toplam_kayit,
            ROUND(AVG(risk_score), 2) AS ort_risk_score,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS anomali_kayit,
            ROUND(SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS anomali_oran_pct
        FROM final_dataset
        GROUP BY marka, model
        ORDER BY anomali_oran_pct DESC;

-- === pvt_gece_anomali ===
SELECT
            tesisat_no_id, il, ilce,
            COUNT(*) AS gece_kayit,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS gece_anomali,
            ROUND(AVG(t0_diff), 4) AS ort_gece_tuketim,
            ROUND(AVG(risk_score), 2) AS ort_risk
        FROM final_dataset
        WHERE time_bucket = 'Gece'
        GROUP BY tesisat_no_id, il, ilce
        HAVING gece_anomali > 0
        ORDER BY gece_anomali DESC
        LIMIT 50;

-- === pvt_sabit_tuketim ===
SELECT
            tesisat_no_id, il, ilce, abone_grubu,
            COUNT(*) AS sabit_tuketim_kayit,
            ROUND(AVG(t0_diff), 4) AS ort_tuketim,
            ROUND(AVG(risk_score), 2) AS ort_risk
        FROM final_dataset
        WHERE steady_consumption_flag = 1
        GROUP BY tesisat_no_id, il, ilce, abone_grubu
        ORDER BY sabit_tuketim_kayit DESC
        LIMIT 50;

-- === pvt_faz_sifir ===
SELECT
            tesisat_no_id, il, ilce, marka, model, abone_grubu,
            SUM(phase_zero_flag) AS faz_sifir_kayit,
            COUNT(*) AS toplam_kayit,
            ROUND(SUM(phase_zero_flag) * 100.0 / COUNT(*), 2) AS faz_sifir_oran_pct
        FROM final_dataset
        GROUP BY tesisat_no_id, il, ilce, marka, model, abone_grubu
        HAVING faz_sifir_kayit > 0
        ORDER BY faz_sifir_kayit DESC
        LIMIT 50;

-- === pvt_voltaj_eksik_tuketim ===
SELECT
            tesisat_no_id, il, ilce,
            SUM(voltage_missing_consumption_flag) AS voltaj_eksik_tuketim_kayit,
            ROUND(AVG(t0_diff), 4) AS ort_tuketim,
            ROUND(AVG(risk_score), 2) AS ort_risk
        FROM final_dataset
        WHERE voltage_missing_consumption_flag = 1
        GROUP BY tesisat_no_id, il, ilce
        ORDER BY voltaj_eksik_tuketim_kayit DESC
        LIMIT 50;

-- === pvt_negatif_sifir ===
SELECT
            il, ilce,
            SUM(dq_flag_negative_t0) AS negatif_t0_sayisi,
            SUM(dq_flag_zero_t0) AS sifir_t0_sayisi,
            COUNT(*) AS toplam_kayit
        FROM final_dataset
        GROUP BY il, ilce
        HAVING negatif_t0_sayisi + sifir_t0_sayisi > 0
        ORDER BY negatif_t0_sayisi DESC;

-- === pvt_reaktif_oran ===
SELECT
            tesisat_no_id, il, ilce, abone_grubu,
            ROUND(AVG(reactive_ratio), 4) AS ort_reaktif_oran,
            ROUND(AVG(t0_diff), 4) AS ort_tuketim,
            COUNT(*) AS kayit_sayisi
        FROM final_dataset
        GROUP BY tesisat_no_id, il, ilce, abone_grubu
        ORDER BY ort_reaktif_oran DESC
        LIMIT 30;

-- === pvt_hafta_karsilastirma ===
SELECT
            CASE WHEN is_weekend = 1 THEN 'Hafta Sonu' ELSE 'Hafta Ici' END AS gun_tipi,
            COUNT(*) AS toplam_kayit,
            ROUND(AVG(t0_diff), 4) AS ort_tuketim,
            ROUND(AVG(avg_current), 4) AS ort_akim,
            SUM(CASE WHEN anomaly_type NOT IN ('normal') THEN 1 ELSE 0 END) AS anomali_sayisi
        FROM final_dataset
        GROUP BY is_weekend;

