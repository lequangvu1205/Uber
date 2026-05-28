-- Xóa bảng cũ (theo đúng thứ tự vì có FK)
DROP TABLE IF EXISTS fact_drivers_performance;
DROP TABLE IF EXISTS dim_status;
DROP TABLE IF EXISTS dim_vehicle;
DROP TABLE IF EXISTS dim_drivers;

-- Tạo lại 4 bảng
CREATE TABLE dim_drivers (
    driver_sk          INT PRIMARY KEY,
    driver_id          VARCHAR(20),
    driver_name        VARCHAR(100),
    age                INT,
    city               VARCHAR(50),
    phone              VARCHAR(20),
    email              VARCHAR(100),
    experience_level   VARCHAR(20),
    languages_known    VARCHAR(200),
    reason_for_joining VARCHAR(100),
    preferred_shift    VARCHAR(20)
);

CREATE TABLE dim_vehicle (
    driver_sk         INT PRIMARY KEY,
    driver_id         VARCHAR(20),
    platform          VARCHAR(50),
    vehicle_type      VARCHAR(50),
    vehicle_condition VARCHAR(50)
);

CREATE TABLE dim_status (
    driver_sk               INT PRIMARY KEY,
    driver_id               VARCHAR(20),
    is_currently_active     INT,
    background_check_status VARCHAR(50),
    document_verification   VARCHAR(50),
    interview_result        VARCHAR(50),
    rejection_reason        VARCHAR(200),
    interview_date          DATE,
    onboarding_date         DATE,
    peak_hour_availability  INT
);

CREATE TABLE fact_drivers_performance (
    driver_sk                  INT PRIMARY KEY,
    driver_id                  VARCHAR(20),
    overall_driver_rating      FLOAT,
    total_trips_completed      FLOAT,
    trip_completion_rate       FLOAT,
    cancellation_rate          FLOAT,
    avg_daily_earnings_INR     FLOAT,
    total_complaints           FLOAT,
    total_compliments          FLOAT,
    communication_score_10     FLOAT,
    driving_test_score_10      FLOAT,
    route_knowledge_score_10   FLOAT,
    customer_handling_score_10 FLOAT,
    overall_interview_score_10 FLOAT,
    FOREIGN KEY (driver_sk) REFERENCES dim_drivers(driver_sk)
);

-- Nạp dữ liệu
INSERT INTO dim_drivers
SELECT driver_sk, driver_id, driver_name, age, city, phone, email,
       experience_level, languages_known, reason_for_joining, preferred_shift
FROM drivers;

INSERT INTO dim_vehicle
SELECT driver_sk, driver_id, platform, vehicle_type, vehicle_condition
FROM drivers;

INSERT INTO dim_status
SELECT driver_sk, driver_id, is_currently_active, background_check_status,
       document_verification, interview_result, rejection_reason,
       interview_date, onboarding_date, peak_hour_availability
FROM drivers;

INSERT INTO fact_drivers_performance
SELECT driver_sk, driver_id, overall_driver_rating, total_trips_completed,
       [trip_completion_rate_%], [cancellation_rate_%],
       avg_daily_earnings_INR, total_complaints, total_compliments,
       communication_score_10, driving_test_score_10,
       route_knowledge_score_10, customer_handling_score_10,
       overall_interview_score_10
FROM drivers;

-- Thêm FK còn lại
ALTER TABLE dim_vehicle
ADD CONSTRAINT FK_vehicle_drivers
FOREIGN KEY (driver_sk) REFERENCES dim_drivers(driver_sk);

ALTER TABLE dim_status
ADD CONSTRAINT FK_status_drivers
FOREIGN KEY (driver_sk) REFERENCES dim_drivers(driver_sk);

-- Kiểm tra
SELECT COUNT(*) FROM dim_drivers;
SELECT COUNT(*) FROM dim_vehicle;
SELECT COUNT(*) FROM dim_status;
SELECT COUNT(*) FROM fact_drivers_performance;








-- Xóa FK cũ
ALTER TABLE fact_drivers_performance DROP CONSTRAINT FK__fact_driv__drive__339FAB6E;
ALTER TABLE dim_vehicle DROP CONSTRAINT FK_vehicle_drivers;
ALTER TABLE dim_status DROP CONSTRAINT FK_status_drivers;

-- Tạo FK mới: dim trỏ vào fact
ALTER TABLE dim_drivers
ADD CONSTRAINT FK_drivers_fact
FOREIGN KEY (driver_sk) REFERENCES fact_drivers_performance(driver_sk);

ALTER TABLE dim_vehicle
ADD CONSTRAINT FK_vehicle_fact
FOREIGN KEY (driver_sk) REFERENCES fact_drivers_performance(driver_sk);

ALTER TABLE dim_status
ADD CONSTRAINT FK_status_fact
FOREIGN KEY (driver_sk) REFERENCES fact_drivers_performance(driver_sk);

-- Kiểm tra lại
SELECT 
    FK.name AS ForeignKey,
    TP.name AS ParentTable,
    TR.name AS ReferencedTable
FROM sys.foreign_keys FK
JOIN sys.tables TP ON FK.parent_object_id = TP.object_id
JOIN sys.tables TR ON FK.referenced_object_id = TR.object_id;