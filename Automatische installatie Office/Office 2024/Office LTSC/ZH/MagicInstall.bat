@echo off
setlocal
:: =========================================================
:: 重要：切換到腳本所在的資料夾
:: 這能解決 "找不到 xml" 或路徑錯誤的問題
:: =========================================================
cd /d "%~dp0"

:MENU
CLS
ECHO ========================================================
ECHO    Office 2024 LTSC (Standard) - Automation Tool
ECHO ========================================================
ECHO.
ECHO    [1] Install Office 2024 (Word, Excel, PPT Only)
ECHO    [2] Uninstall Office 2024 (Clean Remove)
ECHO    [3] Exit
ECHO.
ECHO ========================================================
SET /P M="> Please select an option (1-3): "

IF %M%==1 GOTO INSTALL
IF %M%==2 GOTO UNINSTALL
IF %M%==3 GOTO EOF

:INSTALL
CLS
ECHO [*] Generating Installation Config for Standard 2024...

:: 產生安裝設定檔 (已寫入 PIDKEY 和 Standard 版本)
(
echo ^<Configuration^>
echo   ^<Add OfficeClientEdition="64" Channel="PerpetualVL2024"^>
echo     ^<!-- 指定 Standard 版本與金鑰 --^>
echo     ^<Product ID="Standard2024Volume" PIDKEY="V28N4-JG22K-W66P8-VTMGK-H6HGR"^>
echo       ^<Language ID="zh-tw" /^>
echo       ^<!-- 排除不需要的軟體，只留 Word/Excel/PPT --^>
echo       ^<ExcludeApp ID="Access" /^>
echo       ^<ExcludeApp ID="Lync" /^>
echo       ^<ExcludeApp ID="Outlook" /^>
echo       ^<ExcludeApp ID="OneNote" /^>
echo       ^<ExcludeApp ID="Publisher" /^>
echo       ^<ExcludeApp ID="OneDrive" /^>
echo       ^<ExcludeApp ID="Visio" /^>
echo       ^<ExcludeApp ID="Project" /^>
echo       ^<ExcludeApp ID="Teams" /^>
echo     ^</Product^>
echo   ^</Add^>
echo   ^<Display Level="Full" AcceptEULA="TRUE" /^>
echo   ^<Property Name="AUTOACTIVATE" Value="1" /^>
echo   ^<Property Name="FORCEAPPSHUTDOWN" Value="TRUE" /^>
echo ^</Configuration^>
) > install_config.xml

:: 稍微等待 2 秒確保檔案寫入完成
timeout /t 2 /nobreak >nul

ECHO [*] Config generated. Starting Installation...
IF EXIST "setup.exe" (
    :: 使用絕對路徑 "%~dp0" 確保 setup.exe 找得到檔案
    setup.exe /configure "%~dp0install_config.xml"
) ELSE (
    ECHO [Error] setup.exe not found! Please download ODT first.
    PAUSE
    GOTO MENU
)
GOTO DONE

:UNINSTALL
CLS
ECHO [*] Generating Removal Config...

:: 產生移除專用的 XML
(
echo ^<Configuration^>
echo   ^<Remove All="TRUE" /^>
echo   ^<Display Level="Full" AcceptEULA="TRUE" /^>
echo   ^<Property Name="FORCEAPPSHUTDOWN" Value="TRUE" /^>
echo ^</Configuration^>
) > remove_config.xml

:: 稍微等待 2 秒確保檔案寫入完成 (這是修復 "找不到檔案" 的關鍵)
timeout /t 2 /nobreak >nul

ECHO [*] Removal Config generated.
ECHO [!] WARNING: This will remove ALL Office products.
PAUSE

ECHO [*] Starting Uninstallation...
IF EXIST "remove_config.xml" (
    :: 使用絕對路徑 "%~dp0" 確保 setup.exe 找得到檔案
    setup.exe /configure "%~dp0remove_config.xml"
) ELSE (
    ECHO [Error] remove_config.xml generation failed!
    PAUSE
    GOTO MENU
)
GOTO DONE

:DONE
ECHO.
ECHO ========================================================
ECHO    Operation Completed!
ECHO ========================================================
PAUSE
GOTO MENU

:EOF
EXIT
