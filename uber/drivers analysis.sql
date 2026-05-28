use uber
-- đếm số tài xế theo từng platform
SELECT platform, COUNT(*) AS SoTaiXe
from drivers
GROUP BY platform
-- đếm số tài xế theo từng thành phố, chỉ lấy top 5 thành phố có số tài xế nhiều nhất
select top 5 city, count(*) as SoTaiXe
from drivers
group by city
order by SoTaiXe desc
-- đếm số tài xế theo từng experience_level(trình độ kinh nghiệm)
select  experience_level, 
		count(*) as SoTaiXe
from drivers
group by experience_level
-- đếm số tài xế is_currently_active =1 và =0, tính thêm tỉ lệ phần trăm của mỗi nhóm trên tổng tài xế
select is_currently_active, 
		count(*) as SoTaiXe,
		CAST(count(*) AS FLOAT) / (SELECT COUNT(*) FROM drivers) * 100 AS TyLePhanTram
from drivers
group by is_currently_active
-- thành phố nào có avg_daily_earnings_INR trung bình cao nhất, chỉ lấy top 5
select top	5 city, 
			AVG(avg_daily_earnings_INR) as TrungBinhEarnings
from drivers
group by city
order by TrungBinhEarnings desc
-- Mỗi platform có trip_completion_rate_% trung bình là bao nhiêu sắp xếp theo từ cao đến thấp
select platform, 
		AVG([trip_completion_rate_%]) as TrungBinhCompletionRate
from drivers
group by platform
order by TrungBinhCompletionRate desc
-- Mỗi experrience_level có overall_driver_rating trung bình là bao nhiêu sắp xếp theo từ cao đến thấp
select experience_level, 
		AVG(overall_driver_rating) as TrungBinhRating
		from drivers
		group by experience_level
		order by TrungBinhRating desc
-- thành phố nào có cancellation_rate_% trung bình thấp nhất, chỉ lấy những thành phố có ít nhất 1000 tài xế, sắp xếp theo từ thấp đến cao
SELECT city,
       AVG([cancellation_rate_%]) AS TrungBinhCancellationRate,
       COUNT(*) AS SoTaiXe
FROM drivers
GROUP BY city
HAVING COUNT(*) >= 1000
ORDER BY TrungBinhCancellationRate ASC

-- đếm số tài xế theo từng interview_result, tính thêm tỉ lệ phần trăm trên tổng tài xế
select interview_result, 
		count(*) as SoTaiXe,
		CAST(count(*) AS FLOAT) / (SELECT COUNT(*) FROM drivers) * 100 AS TyLePhanTram
from drivers
group by interview_result
order by TyLePhanTram desc
--những rejection_reason nào phổ biến nhất, chỉ lấy top 5 lý do bị từ chối(lọc bỏ null)
select top 5 rejection_reason, 
		count(*) as SoTaiXe
from drivers
where rejection_reason is not null
group by rejection_reason
order by SoTaiXe desc
--so sánh điểm overall_interview_score_10 trung bình giữa các nhóm interview_result
select interview_result, 
		AVG(overall_interview_score_10) as TrungBinhInterviewScore
		from drivers
		group by interview_result
		order by TrungBinhInterviewScore desc
-- với mỗi kết hợp document_verification và interview_suilt, đếm số tài xế - kết quả sẽ cho thấy document có ảnh hưởng đến kết quả phỏng vấn hay không
select document_verification, 
		interview_result, 
		count(*) as SoTaiXe
		from drivers
		group by document_verification, interview_result
		order by SoTaiXe desc
