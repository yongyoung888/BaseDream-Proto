@echo off
chcp 65001 >nul

echo ================================================
echo  Proto -> Java and gRPC Stub Generator
echo ================================================

:: 输出根目录
set OUT=./../BaseDream-Server/game-common/src/main/java

:: 包名
set MSG_PKG=com.yongyoung.dream
set GRPC_PKG=com.yongyoung.dream.grpc

:: 转换路径（把 . 替换成 \）
set MSG_DIR=%OUT%\%MSG_PKG:.=\%
set GRPC_DIR=%OUT%\%GRPC_PKG:.=\%

echo Message Dir: %MSG_DIR%
echo gRPC Dir:    %GRPC_DIR%
echo.

echo === Step 1: Running protoc ===

protoc --proto_path=. ^
  --java_out=%OUT% ^
  --grpc-java_out=%OUT% ^
  *.proto

if %ERRORLEVEL% NEQ 0 (
  echo [ERROR] protoc failed!
  pause
  exit /b 1
)

echo.
echo === Step 2: Move gRPC classes ===

:: 创建grpc目录
if not exist "%GRPC_DIR%" mkdir "%GRPC_DIR%"

setlocal enabledelayedexpansion

:: 搜索 message 目录下所有 *Grpc.java 文件
for /r "%MSG_DIR%" %%f in (*Grpc.java) do (
    echo Processing %%f

    set SRC=%%~ff
    set NAME=%%~nxf

    :: 拷贝文件到 grpc 目录
    copy /y "%%~ff" "%GRPC_DIR%\!NAME!" >nul

    :: package + import 修改
    powershell -Command ^
      "(Get-Content '%GRPC_DIR%\!NAME!') ^
      -replace '^package %MSG_PKG%;', 'package %GRPC_PKG%;`nimport %MSG_PKG%.*;' ^
      | Set-Content -Encoding UTF8 '%GRPC_DIR%\!NAME!'"


)

endlocal

echo.
echo ================================================
echo  SUCCESS!
echo  Message package => %MSG_PKG%
echo  gRPC package    => %GRPC_PKG%
echo ================================================

pause
