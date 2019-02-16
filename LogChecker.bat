@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

REM [Description: check there exists keywords in all the log text files in all sub-directories or not]
REM [Note       : need KEYWORD.txt in the same path]

SET checker="RD_UNC"

SET totalErrorCnt=0
SET totalFileCnt=0
SET currentFileCnt=0
SET errorFileCnt=0

REM step 1. get total log file count
FOR /f "tokens=*" %%G IN ('DIR /s/b/o:gn *log.txt') DO (
    SET /A totalFileCnt+=1
)

FOR /f "tokens=*" %%G IN ('DIR /s/b/o:gn *log.txt') DO (
    REM ECHO %%G
    SET filePath=%%G

    SET /A currentFileCnt+=1
    
    REM step 2. set the process bar on dos window title 
    TITLE Check the log file ... [!currentFileCnt! / !totalFileCnt!]

    REM step 3. remove the specific character (\x00 indicates that "NUL" on Notepad++)
    .\sed-4.2.1-bin\bin\sed.exe -i -e "s/\x00//g" !filePath!
    
    REM step 4. get check times for error interrupt
    REM method 1: command result into variable
    REM for /f "delims=" %%a in ('FINDSTR /R /N "^.*" !filePath! ^| FIND /C !checker!') do set expectedCnt=%%a
    REM method 2: command result into file, then we read file into variable
    FINDSTR /R /N "^.*" !filePath! | FIND /C !checker! > TEMP.txt
    FOR /f "delims=" %%x IN (TEMP.txt) DO (
        SET expectedCnt=%%x
    )
    REM ECHO !expectedCnt!
    
    SET n=0
    SET tempErrorCnt=0

    FOR /f "tokens=*" %%a in (KEYWORD.txt) do (
        SET errorInt=%%a
        REM ECHO [!n!] !errorInt!
        
        REM step 5. get actual pass times (No error) 
        REM method 1: command result into variable
        REM for /f "delims=" %%a in ('FINDSTR /R /N "^.*" !filePath! ^| FIND /C !errorInt!') do set cnt=%%a
        REM method 2. command result into file, then we read file into variable
        FINDSTR /R /N "^.*" !filePath! | FIND /C "!errorInt!" > TEMP.txt
        FOR /f "delims=" %%x IN (TEMP.txt) DO (
            SET cnt=%%x
            REM ECHO CNT: !cnt!
            
            REM step 6. it indicates ERROR when check times != pass times
            IF NOT !cnt! == !expectedCnt! (
                ECHO Exist Error: [!n!] [ACTUAL: !cnt!] [EXPECT: !expectedCnt!] !errorInt! 
                ECHO [!filePath!]

                IF !tempErrorCnt! == 0 (
                    SET /A errorFileCnt+=1
                )
                SET /A totalErrorCnt+=1
                SET /A tempErrorCnt+=1
            )
        )
        SET /A n+=1
    )
)

REM step 7. delete temp file and all backup files of SED
DEL sed* 
DEL TEMP.txt


ECHO.
ECHO.
ECHO Total Files      : !totalFileCnt!
ECHO Error Files      : !errorFileCnt!
ECHO Check Count      : !n!
ECHO Total Error Count: !totalErrorCnt!
ECHO.
ECHO.
ECHO -------- Check End --------
ECHO.

PAUSE

