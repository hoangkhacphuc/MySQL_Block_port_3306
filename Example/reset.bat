@echo off
REM xóa folder data rồi đổi tên folder data_old thành data
if exist "./data_old" (
    rmdir /s /q ".\data"
    ren ".\data_old" "data"
    rmdir /s /q ".\data2"
)