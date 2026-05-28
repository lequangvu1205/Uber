#  Uber Driver Performance & Operational Analysis


##  Giới Thiệu Dự Án
Dự án này tập trung vào việc khai phá, làm sạch và phân tích dữ liệu vận hành của tài xế Uber (Dự án dựa trên tập dữ liệu mô phỏng/thực tế từ Uber Rapido). Mục tiêu chính là đánh giá hiệu suất của tài xế, tỷ lệ hoạt động (Active Rate), và đưa ra các insight giúp tối ưu hóa hệ thống vận hành, giảm tỷ lệ hủy chuyến.

---

## 🛠 Quy Trình Thực Hiện (Data Pipeline)

Dự án được triển khai toàn diện qua 4 bước cấu trúc:

1. **Data Cleaning & Preprocessing (Python):** 
   * Xử lý dữ liệu thô từ file `uber_rapido_driver_dirty.csv`.
   * Sử dụng thư viện `Pandas` trong Jupyter Notebook (`xử lí dữ liệu.ipynb`) để xử lý giá trị khuyết thiếu (Missing values), loại bỏ dữ liệu trùng lặp, chuẩn hóa định dạng ngày tháng và xuất ra file sạch `uber_rapido_driver_clean.csv`.
2. **Database Schema & SQL Querying (SQL):**
   * Thiết kế cấu trúc bảng và nạp dữ liệu sạch vào hệ quản trị cơ sở dữ liệu qua file `create schema.sql`.
   * Viết các câu lệnh truy vấn phức tạp trong `drivers analysis.sql` để tính toán các chỉ số nâng cao trước khi đưa vào Power BI.
3. **Data Modeling & DAX (Power BI):**
   * Xây dựng mô hình dữ liệu chuẩn.
   * Viết các biểu thức DAX để tính toán các chỉ số đo lường hiệu suất (KPIs) quan trọng như `% Active` (Tỷ lệ tài xế đang hoạt động), Tổng số lượng tài xế, v.v.
4. **Data Visualization (Dashboard):**
   * Thiết kế báo cáo tương tác trực quan `uberdash.pbix` nhằm cung cấp cái nhìn toàn diện cho người quản lý hệ thống.

---

## Các Chỉ Số Đo Lường Chính (Key Metrics)

* **Total Drivers:** Tổng số lượng tài xế đăng ký trong hệ thống.
* **Active Rate (% Active):** Tỷ lệ phần trăm tài xế thực tế đang hoạt động dựa trên tổng số tài xế.
* Tổng số chuyến đi, Doanh thu, hoặc Tỷ lệ hủy chuyến) thì liệt kê cụ thể ra giống như hai dòng trên. Nếu không có thì cứ xóa hẳn dòng này đi là sạch đẹp.

---

## Giao Diện Dashboard (Preview)

*(Mẹo: Bạn hãy chụp ảnh màn hình Dashboard Power BI của bạn, lưu vào thư mục dự án này, rồi thay tên file ảnh vào dòng dưới đây nhé)*
![Uber Dashboard Preview](path_to_your_screenshot.png)

---

##  Cấu Trúc Thư Mục Dự Án

```text
├── 📜 .gitignore                   # File cấu hình phớt lờ các file rác và data nặng
├── 📜 README.md                    # File hướng dẫn và giới thiệu dự án (Hiện tại)
├── 📜 create schema.sql            # Script SQL khởi tạo cấu trúc Database
├── 📜 drivers analysis.sql         # Các câu lệnh SQL truy vấn và phân tích dữ liệu
├── 📜 xử lí dữ liệu.ipynb          # Jupyter Notebook xử lý và làm sạch data bằng Python
└── 📜 uberdash.pbix                # File báo cáo/Dashboard hoàn chỉnh trên Power BI