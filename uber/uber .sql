USE uber;
SELECT COUNT(*) FROM drivers;
SELECT TOP 10 * FROM drivers;
--===========================
-- Driver Performance Analysis
-- Tổng số tài xế
SELECT COUNT(*) AS total_drivers
FROM drivers;
-- rating trung bình cua các tài xế
SELECT AVG(overall_driver_rating) AS average_rating
FROM drivers;
--Top 10 tài xế có nhiều chuyến nhất
SELECT TOP 100
       driver_id,
       driver_name,
       total_trips_completed
FROM drivers
ORDER BY total_trips_completed DESC;
-- tài xế có complention rate thấp nhất
SELECT driver_name,
       [trip_completion_rate_%]
FROM drivers
WHERE [trip_completion_rate_%] < 80;
--============================
--Thu nhập trung bình theo thành phố
SELECT city,
       ROUND(AVG(avg_daily_earnings_INR),2) AS avg_earnings
FROM drivers
GROUP BY city
ORDER BY avg_earnings DESC;
-- so sánh thu nhập giữa giờ cao điểm và giờ thường
SELECT peak_hour_availability,
       ROUND(AVG(avg_daily_earnings_INR),2) AS avg_income
FROM drivers
GROUP BY peak_hour_availability;
-- top 100 tài xế kiếm nhiều tiền nhát
SELECT TOP 100 driver_name,
       avg_daily_earnings_INR
FROM drivers
ORDER BY avg_daily_earnings_INR DESC    ;
--===========================
-- Complaint & Customer Satisfaction
SELECT driver_name,
       total_complaints
FROM drivers
ORDER BY total_complaints DESC
-- tỷ lệ complaint theo vehicle condition
SELECT vehicle_condition,
       ROUND(AVG(total_complaints),2) AS avg_complaints
       FROM drivers
       GROUP BY vehicle_condition
       ORDER BY avg_complaints DESC;
--Driver rating theo customer handling score
SELECT customer_handling_score_10,
       ROUND(AVG(overall_driver_rating),2) AS avg_rating
FROM drivers
GROUP BY customer_handling_score_10
ORDER BY customer_handling_score_10;
--===========================
--Recruitment Analysis
-- tỷ lệ đậu phỏng vấn 
SELECT interview_result,
       COUNT(*) AS total_candidates
FROM drivers
GROUP BY interview_result;
-- lý do bị từ chối nhiều nhất
SELECT rejection_reason,
       COUNT(*) AS total_rejections
       FROM drivers
       WHERE interview_result = 'Rejected'
       group BY rejection_reason
       ORDER BY total_rejections DESC;
-- điểm trung bình của người được nhận và bị từ chối
 select interview_result,
       ROUND(AVG(overall_interview_score_10),2) AS avg_interview_score
       from drivers
       group BY interview_result;
--===========================
--Retention Analysis
-- số tài xế hiện tại đang hoạt động
SELECT COUNT(*) AS active_drivers
FROM drivers
WHERE is_currently_active = 1;
-- tài xế k hoạt động có đánh giá cao hơn tài xế đang hoạt động không
select is_currently_active,
       ROUND(AVG(overall_driver_rating),2) AS avg_rating
       from drivers
       group BY is_currently_active;
-- tỉ lệ đánh giá của hiện tại đang hoạt động và không hoạt động
SELECT is_currently_active,
       ROUND(AVG(overall_driver_rating),2) AS avg_rating
       from drivers
       group BY is_currently_active;
       
--Những tài xế nào được coi là chất lượng cao, tức có đánh giá tổng thể từ 4.5 trở lên và tỷ lệ hoàn thành chuyến ≥ 90%?
WITH high_quality_drivers AS (
    SELECT driver_name,
           overall_driver_rating,
           avg_daily_earnings_INR,
           [trip_completion_rate_%]
    FROM drivers
    WHERE overall_driver_rating >= 4.5
      AND [trip_completion_rate_%] >= 90
)

SELECT *
FROM high_quality_drivers;
-- top 5 tài xế mỗi thành phố
WITH ranked_drivers AS (
    SELECT driver_name,
           city,
           avg_daily_earnings_INR,
           RANK() OVER(
               PARTITION BY city
               ORDER BY avg_daily_earnings_INR DESC
           ) AS rn
    FROM drivers
)

SELECT *
FROM ranked_drivers
WHERE rn <= 5;
--Phân loại driver quality
SELECT driver_name,
       overall_driver_rating,
       CASE
           WHEN overall_driver_rating >= 4.5 THEN 'Excellent'
           WHEN overall_driver_rating >= 4 THEN 'Good'
           WHEN overall_driver_rating >= 3 THEN 'Average'
           ELSE 'Poor'
       END AS driver_category
FROM drivers;
