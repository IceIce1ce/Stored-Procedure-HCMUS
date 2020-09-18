-- a
CREATE PROC usp_helloworld 
AS
BEGIN
PRINT 'HELLO WORLD'
END
GO
EXEC dbo.usp_helloworld
-- b
GO
CREATE PROC usp_sum2number @a INT, @b INT
AS
BEGIN
	DECLARE @result INT
	SET @result = @a + @b
	PRINT @result
END
GO
EXEC dbo.usp_sum2number 5, 6
-- c
GO
CREATE PROC usp_sum2numberout @a INT, @b INT, @result INT OUT
AS
BEGIN
SET @result = @a + @b
END
GO
DECLARE @result INT
EXEC usp_sum2numberout 4, 5, @result OUT
PRINT @result
-- d
GO
CREATE PROC usp_sum3number @a INT, @b INT, @c INT
AS
DECLARE @result INT
EXEC dbo.usp_sum2numberout @a, @b, @result OUT
SET @result = @result + @c
PRINT @result
GO
EXEC usp_sum3number 2, 3, 5
-- e
GO
CREATE PROC sumMN @m INT, @n INT
AS
DECLARE @sum INT
DECLARE @i INT
SET @sum = 0
SET @i = @m
WHILE(@i < @n)
BEGIN
SET @sum = @sum + @i
SET @i = @i + 1
END
PRINT @sum
GO
EXEC dbo.sumMN 1, 6
-- f
GO
CREATE PROC checkPrime @num INT, @status BIT OUT
AS
DECLARE @bound FLOAT
DECLARE @i INT
SET @bound = SQRT(@num)
SET @i = 2
SET @status = 1
WHILE(@i <= @bound)
BEGIN
IF(@num % @i = 0)
BEGIN
SET @status = 0
BREAK
END
SET @i = @i + 1
END
GO
DECLARE @check BIT
EXEC checkPrime 4, @check OUT
IF(@check = 1)
BEGIN
PRINT 'Prime number'
END
ELSE
BEGIN
PRINT 'Not Prime number'
END
-- g
GO
ALTER PROC sumPrime @m INT, @n INT
AS
DECLARE @sum INT
DECLARE @i INT
DECLARE @status BIT
SET @sum = 0
SET @i = @m
SET @status = 0
WHILE(@i <= @n)
BEGIN
EXEC checkPrime @i, @status OUT
IF(@status = 1)
BEGIN
SET @sum = @sum + @i
END
SET @i = @i + 1
END
PRINT @sum
GO
EXEC sumPrime 1, 4
-- h
GO
CREATE PROC gcd @a INT, @b INT, @result INT OUT
AS
IF(@a = 0 OR @b = 0)
BEGIN 
SET @result = @a + @b
END
ELSE
BEGIN
WHILE(@a != @b)
BEGIN
IF(@a > @b) SET @a = @a - @b
ELSE SET @b = @b - @a
END
END
SET @result = @a
GO
DECLARE @ucln INT
EXEC gcd 7, 20, @ucln OUT
PRINT @ucln
-- i
GO
CREATE PROC lcm @a INT, @b INT, @result INT OUT
AS
DECLARE @tmp INT
EXEC gcd @a, @b, @tmp OUT
SET @result = (@a * @b) / @tmp
GO
DECLARE @bcnn INT
EXEC lcm 7, 10, @bcnn OUT
PRINT @bcnn
-- j
GO
CREATE PROC usp_dsgv
AS
SELECT * FROM dbo.GIAOVIEN
GO
EXEC dbo.usp_dsgv
-- k
GO
CREATE PROC tongSLDetai @magv VARCHAR(10)
AS
DECLARE @sum INT
SET @sum = (SELECT COUNT(DISTINCT DT.MADT) FROM dbo.THAMGIADT DT WHERE DT.MAGV = @magv GROUP BY DT.MAGV)
PRINT @sum
GO
EXEC dbo.tongSLDetai '003'
-- l
GO
CREATE PROC thongtingv @magv VARCHAR(10)
AS
DECLARE @hoten NVARCHAR(50)
SET @hoten = (SELECT GV.HOTEN FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Họ tên: ' + @hoten
DECLARE @luong FLOAT
SET @luong = (SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Lương: ' + CAST(@luong AS VARCHAR(10))
DECLARE @ngaysinh DATE 
SET @ngaysinh = (SELECT GV.NGAYSINH FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Ngày sinh: ' + CAST(@ngaysinh AS VARCHAR(10))
DECLARE @soluongdetai INT
SET @soluongdetai = (SELECT COUNT(DISTINCT DT.MADT) FROM dbo.THAMGIADT DT WHERE DT.MAGV = @magv GROUP BY DT.MAGV)
PRINT N'Số lượng đề tài: ' + CAST(@soluongdetai AS VARCHAR(10))
DECLARE @soluongthannhan INT 
SET @soluongthannhan = (SELECT COUNT(*) FROM dbo.NGUOITHAN NG WHERE NG.MAGV = @magv GROUP BY NG.MAGV)
PRINT N'Số lượng người thân: ' + CAST(@soluongthannhan AS VARCHAR(10))
GO
EXEC dbo.thongtingv '001'
-- m
GO
CREATE PROC ktragv @magv VARCHAR(10), @status BIT OUT
AS
IF(EXISTS(SELECT * FROM GIAOVIEN GV WHERE GV.MAGV = @magv))
BEGIN 
PRINT N'Tồn tại giáo viên'
SET @status = 1
END 
ELSE 
BEGIN 
PRINT N'Không tồn tại giáo viên'
SET @status = 0
END 
GO
DECLARE @check BIT
EXEC ktragv '002', @check OUT 
-- n
GO
CREATE PROC ktraquydinh @magv VARCHAR(10), @madt VARCHAR(5), @check BIT OUT
AS
DECLARE @gvcndt VARCHAR(5)
SET @gvcndt = (SELECT DT.GVCNDT FROM dbo.DETAI DT WHERE DT.MADT = @madt)
IF((SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @magv) = (SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @gvcndt))
BEGIN
PRINT N'Phù hợp quy định'
SET @check = 1
END
ELSE
BEGIN
PRINT N'Sai quy định'
SET @check = 0
END
GO
DECLARE @status BIT 
EXEC ktraquydinh '001', '007', @status OUT 
-- o
GO
CREATE PROC phanconggv @magv VARCHAR(5), @madt VARCHAR(5), @stt INT, @phucap INT , @ketqua NVARCHAR(5)
AS
DECLARE @check BIT 
SET @check = 1
IF(NOT EXISTS(SELECT * FROM GIAOVIEN GV WHERE GV.MAGV = @magv))
BEGIN 
PRINT N'Mã giáo viên không tồn tại'
SET @check = 0
END
IF(NOT EXISTS(SELECT * FROM dbo.CONGVIEC CV WHERE CV.MADT = @madt AND CV.SOTT = @stt))
BEGIN 
PRINT N'Công việc không tồn tại'
SET @check = 0
END 
DECLARE @gvcndt VARCHAR(5)
SET @gvcndt = (SELECT DT.GVCNDT FROM dbo.DETAI DT WHERE DT.MADT = @madt)
IF(@check = 1 AND (SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @magv) != (SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @gvcndt))
BEGIN 
PRINT N'Đề tài này không do bộ môn của giáo viên đó làm chủ nhiệm'
SET @check = 0
END
IF(@check = 1)
BEGIN 
INSERT INTO dbo.THAMGIADT
(
    MAGV,
    MADT,
    STT,
    PHUCAP,
    KETQUA
)
VALUES
(   @magv,  
    @madt,  
    @stt,   
    @phucap, 
    @ketqua  
)
PRINT N'Phân công cho giáo viên thành công'
END
GO
EXEC phanconggv '001', '007', 3, 500, NULL
-- p
GO
CREATE PROC xoagv @magv VARCHAR(5)
AS
DECLARE @check BIT
SET @check = 1
IF(EXISTS (SELECT * FROM dbo.GIAOVIEN GV WHERE GV.MAGV = @magv))
BEGIN
IF(EXISTS (SELECT * FROM dbo.NGUOITHAN NG WHERE NG.MAGV = @magv))
BEGIN
PRINT N'Giáo viên tồn tại người thân không thể xóa'
SET @check = 0
END
IF(EXISTS (SELECT * FROM dbo.THAMGIADT TH WHERE TH.MAGV = @magv))
BEGIN
PRINT N'Giáo viên có tham gia đề tài không thể xóa'
SET @check = 0
END
IF(EXISTS (SELECT * FROM dbo.BOMON BM WHERE BM.TRUONGBM = @magv))
BEGIN 
PRINT N'Giáo viên đang là trưởng bộ môn không thể xóa'
SET @check = 0
END
IF(EXISTS (SELECT * FROM KHOA KH WHERE KH.TRUONGKHOA = @magv))
BEGIN 
PRINT N'Giáo viên đang là trưởng khoa không thể xóa'
SET @check = 0
END
IF(EXISTS (SELECT * FROM dbo.DETAI DT WHERE DT.GVCNDT = @magv))
BEGIN 
PRINT N'Giáo viên đang chủ nhiệm đề tài không thể xóa'
SET @check = 0
END
IF(EXISTS (SELECT * FROM GV_DT WHERE GV_DT.MAGV = @magv))
BEGIN 
PRINT N'Giáo viên có số điện thoại không thể xóa'
SET @check = 0
END
IF(@check = 1)
BEGIN
DELETE FROM GIAOVIEN WHERE MAGV = @magv
PRINT N'Xóa thành công giáo viên'
END 
END
ELSE PRINT N'Mã giáo viên này không tồn tại'
GO
EXEC xoagv '005'
-- q
GO
CREATE PROC dsgvphongban
AS
-- declare cursor
DECLARE dsgv CURSOR FOR (SELECT GV.MAGV FROM GIAOVIEN GV)
-- open cursor for reading data
OPEN dsgv
DECLARE @magv VARCHAR(5)
-- read data
FETCH NEXT FROM dsgv INTO @magv
-- if fetch successfully
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE @hoten NVARCHAR(50)
SET @hoten = (SELECT GV.HOTEN FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Họ tên: ' + @hoten
DECLARE @luong FLOAT
SET @luong = (SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Lương: ' + CAST(@luong AS VARCHAR(10))
DECLARE @ngaysinh DATE
SET @ngaysinh = (SELECT GV.NGAYSINH FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
PRINT N'Ngày sinh: ' + CAST(@ngaysinh AS VARCHAR(10))
DECLARE @soluongdetai INT
SET @soluongdetai = (SELECT COUNT(DISTINCT TH.MADT) FROM dbo.THAMGIADT TH WHERE TH.MAGV = @magv)
PRINT N'Số lượng đề tài: ' + CAST(@soluongdetai AS VARCHAR(10))
DECLARE @sonhanthan INT
SET @sonhanthan = (SELECT COUNT(*) FROM dbo.NGUOITHAN NG WHERE NG.MAGV = @magv GROUP BY NG.MAGV)
PRINT N'Số lượng người thân: ' + CAST(@sonhanthan AS VARCHAR(10))
DECLARE @sogiaovienquanly INT
SET @sogiaovienquanly = (SELECT COUNT(*) FROM GIAOVIEN GV WHERE GV.GVQLCM = @magv)
PRINT N'Số giáo viên mà giáo viên quản lý: ' + CAST(@sogiaovienquanly AS VARCHAR(10))
FETCH NEXT FROM dsgv INTO @magv
END
-- close and deallocate memory cursor
CLOSE dsgv
DEALLOCATE dsgv
GO
EXEC dbo.dsgvphongban
-- r
GO
ALTER PROC ktraquydinh2gv @magvA VARCHAR(10), @magvB VARCHAR(10)
AS
IF((SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @magvA) = (SELECT GV.MABM FROM GIAOVIEN GV WHERE GV.MAGV = @magvB))
IF(EXISTS (SELECT * FROM dbo.BOMON BM WHERE BM.TRUONGBM = @magvA))
IF((SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magvA) < (SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magvB))
BEGIN 
PRINT N'Lỗi, lương của giáo viên B cao hơn lương của giáo viên A đang là trưởng bộ môn'
END
ELSE
BEGIN
PRINT N'Hợp lệ'
END
ELSE
IF(EXISTS (SELECT * FROM dbo.BOMON BM WHERE BM.TRUONGBM = @magvB))
IF((SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magvA) > (SELECT GV.LUONG FROM GIAOVIEN GV WHERE GV.MAGV = @magvB))
BEGIN 
PRINT N'Lỗi, lương của giáo viên A cao hơn lương của giáo viên B đang là trưởng bộ môn'
END
ELSE 
BEGIN
PRINT N'Hợp lệ'
END
ELSE PRINT 'Hợp lệ'
GO
EXEC ktraquydinh2gv '001', '002'
-- s
GO
CREATE PROC addGV @magv CHAR(5), @hoten NVARCHAR(50), @luong FLOAT, @phai NVARCHAR(5), @ngaysinh DATE, @diachi NVARCHAR(100), @gvqlcm CHAR(5), @mabm NVARCHAR(5)
AS
DECLARE @check BIT
SET @check = 1
IF(EXISTS (SELECT * FROM GIAOVIEN GV WHERE GV.MAGV = @magv))
BEGIN 
PRINT N'Trùng tên với giáo viên khác'
SET @check = 0
END
IF(YEAR(GETDATE()) - YEAR(@ngaysinh) < 18)
BEGIN 
PRINT N'Tuổi phải lớn hơn 18'
SET @check = 0
END
IF(@luong <= 0) 
BEGIN
PRINT N'Lương phải lớn hơn 0'
SET @check = 0
END
IF(@check = 1)
BEGIN 
INSERT INTO dbo.GIAOVIEN
(
    MAGV,
    HOTEN,
    LUONG,
    PHAI,
    NGAYSINH,
    DIACHI,
    GVQLCM,
    MABM
)
VALUES
(   @magv,        
    @hoten,      
    @luong,       
    @phai,       
    @ngaysinh, 
    @diachi,       
    @gvqlcm,        
    @mabm       
)
END 
GO
EXEC dbo.addGV '011', N'Trần Đại Chí', 2000, Nam, '10/19/2000', N'193 Phạm Văn Hai, phường 5, quận Tân Bình, TP HCM', NULL, NULL
-- t
-- WHILE 1 = 1 --> infinite loop
GO
CREATE PROC automagv
AS
BEGIN
DECLARE @magv VARCHAR(3) = '001'
DECLARE @i INT 
SET @i = 1
WHILE EXISTS (SELECT GV.MAGV FROM GIAOVIEN GV WHERE GV.MAGV = @magv)
BEGIN
SET @i = @i + 1
SET @magv = REPLICATE('0', 3 - LEN(CAST(@i AS VARCHAR))) + CAST(@i AS VARCHAR)
END
PRINT @magv
END
GO
EXEC automagv