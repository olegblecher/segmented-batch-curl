@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET MB=148576
SET URL="https://website.com/file.zip"
SET DEST="file.zip"
FOR /F "tokens=2 delims= " %%a in ('"curl -sI %URL% | FINDSTR Content-Length"') DO ( SET SIZE=%%a )
ECHO The total file size is %SIZE%
SET /a PARTS=%SIZE% / %MB%
ECHO There will be %PARTS% segments(s)
FOR /L %%a in (0,1,%PARTS%) do (
    SET /a STARTRANGE=%%a*%MB%
    IF %%a LSS %PARTS% (
        SET /a ENDRANGE=%%a*%MB%+%MB%-1
    ) ELSE (SET ENDRANGE=%SIZE%)
    ECHO Downloading segments !STARTRANGE! - !ENDRANGE!
    curl --range !STARTRANGE!-!ENDRANGE! -s -o part%%a %URL%
    TYPE part%%a >> %DEST%
)
del part*
