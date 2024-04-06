MAIN    START   0

OUTLP   TD      OUTDEV
        JEQ     OUTLP
        LDCH    TEXT
        WD      OUTDEV


TEXT    BYTE    C'HELLO WORLDAAAAAA'  // 換行字符
OUTDEV  BYTE    1 
        END     MAIN

