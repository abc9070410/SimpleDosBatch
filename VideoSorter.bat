@ECHO OFF
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

REM [create the specific folders and move files into them]

SET counter=0

FOR /r %%f IN (*.*) DO (

    REM get filename from whole filepath
    SET fileName=%%~nxf 
    
    IF EXIST .\!fileName! (
        SET /A counter=counter+1
    
        REM ex. filename is XX-001
        SET dash2=!fileName:~2,1! 
        REM ex. filename is XXX-001
        SET dash3=!fileName:~3,1! 
        REM ex. filename is XXXX-001
        SET dash4=!fileName:~4,1!
        REM ex. filename is XXXXX-001
        SET dash5=!fileName:~5,1!
        REM ex. filename is XXXXXX-001
        SET dash6=!fileName:~6,1!
        
        REM trim the whitespace in single character
        set dash2=!dash2: =!
        set dash3=!dash3: =!
        set dash4=!dash4: =!
        set dash5=!dash5: =!
        set dash6=!dash6: =!

        ECHO [!counter!]: !fileName!
        
        IF !dash2! == - (
            ECHO "2"
            SET corp=!fileName:~0,2!
        ) ELSE (
            IF !dash3! == - (
                ECHO "3"
                SET corp=!fileName:~0,3!
            ) ELSE (
                IF !dash4! == - (
                    ECHO "4"
                    SET corp=!fileName:~0,4!
                ) ELSE (
                    IF !dash5! == - (
                        ECHO "5"
                        SET corp=!fileName:~0,5!
                    ) ELSE (
                        IF !dash6! == - (
                            ECHO "6"
                            SET corp=!fileName:~0,6!
                        ) ELSE (
                            ECHO "!dash2!"
                            ECHO "!dash3!"
                            ECHO "!dash4!"
                            ECHO "!dash5!"
                            ECHO "!dash6!"
                            
                            ECHO NOT_FOUND
                            SET corp="NOT_FOUND"
                        )
                    )
                )
            )
        )
        
        IF NOT !corp! == "NOT_FOUND" (
            ECHO !corp!
            
            IF NOT EXIST ".\!corp!\" (
                ECHO New FolderREM ".\!corp!"
                MKDIR .\!corp!
            )
            MOVE ".\!fileName!" ".\!corp!\!fileName!"
        )
    )
)


PAUSE

