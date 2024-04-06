MAIN    START   0

first         JSUB    clear
              JSUB    printInstr
startInput    TD      stdin
              JEQ     startInput 
              RD      stdin
              COMP    #10
              JEQ     startGame    
              JSUB    first 
inputData     RESB  1


startGame     JSUB     clear
              J        judger   



.---------------- Juger -------------.

judger       LDX    #0
stGameLp     LDCH   startMsg, X
             WD     stdout
             TIX    #22
             JLT    stGameLp
             RD     stdin
             STA    mode          .  judger input the mode. (1) maxinum win (2) mininum win
             RD     stdin         .  read '\r\n' 
             JSUB   clear         .  clear screen
             J      p1



startMsg     BYTE    C'Juger Input: (1 | 2): '
mode         RESW   1

.----------------   P1    -------------.

p1          JSUB    PP1     . print "Player 1 "
            JSUB    PPI     . print rules
            RD      stdin
            STA     p1Num
            RD      stdin   .   read '\r\n'
            JSUB    clear         .  clear screen
            J       p2


p1Num       RESW      1


.----------------   P2    -------------.

p2          JSUB    PP2     . print "Player 2 "
            JSUB    PPI     . print rules
            RD      stdin
            STA     p2Num
            RD      stdin   .   read '\r\n'
            JSUB    clear         .  clear screen
            J       GR    .  get result of the game. 

p2Num       RESW      1

.------------   Get result -------------.


GR          LDX     #0   .  get result
GRLP        LDCH    grMsg, X
            WD      stdout
            TIX     #8
            JLT     GRLP
            LDA     mode
            COMP    #49
            JEQ     mode1
            J       mode2




mode1     LDA     p1Num
          COMP    p2Num
          JGT     p1win
          JLT     p2win
          JEQ     tie

mode2      LDA     p1Num
          COMP    p2Num
          JLT     p1win
          JGT     p2win
          JEQ     tie


p1win     LDX     #0
p1Loop    LDCH    p1Msg, X
          WD      stdout
          TIX     #13
          JLT     p1Loop
          JSUB    endl
          RD      stdin
          J       first


p2win     LDX     #0
p2Loop    LDCH    p2Msg, X
          WD      stdout
          TIX     #13
          JLT     p2Loop
          JSUB    endl
          RD      stdin
          J       first



tie       LDX     #0
tieLoop   LDCH    tieMsg, X
          WD      stdout
          TIX     #3
          JLT     tieLoop
          JSUB    endl
          RD      stdin
          J       first




grMsg       BYTE    C'Result: '
p1Msg       BYTE    C'Player 1 win!'
p2Msg       BYTE    C'Player 2 win!'
tieMsg      BYTE    C'TIE'

.--------------------     Print Play Instruction   --------------------.

. PP1
PP1     LDX     #0
PP1LP   LDCH    pp1Msg, X
        WD      stdout
        TIX     #9
        JLT     PP1LP
        RSUB

. PP2
PP2     LDX     #0
PP2LP   LDCH    pp2Msg, X
        WD      stdout
        TIX     #9
        JLT     PP2LP
        RSUB


pp1Msg    BYTE    C'Player 1 '
pp2Msg    BYTE    C'Player 2 '


. PPI
PPI     LDX     #0
PPILP   LDCH    ppiMsg, X
        WD      stdout
        TIX     #24
        JLT      PPILP
        RSUB

ppiMsg    BYTE    C'Enter a number:(0 - 9): '

. Print instructions for game.
printInstr    TD      stdout
              JEQ     printInstr
              LDX     #0
ploop         LDCH    instr,  X
              WD      stdout
              TIX     #44
              JLT     ploop
              LDA     #10
              WD      stdout
              RSUB



.--------------------  stdout  ------------------------.


clear     LDA     #0
clearLp   STA     tmpLine
          LDA     #10
          WD      stdout
          LDA     tmpLine
          ADD     #1
          COMP    lines
          JLT     clearLp
          RSUB
          

lines     WORD    50
tmpLine   RESW    1


endl      STA     tmp
          LDA     #10
          WD      stdout
          LDA     tmp
          RSUB

tmp       RESW    1


.--------------------- variables -----------------------.

instr         BYTE    C'Welcome to BB Game. Enter to start the game.'
stdin         BYTE    0
stdout        BYTE    1




EXIT          TD      stdout
              JEQ     EXIT 
              LDX     #0
exitPloop     LDCH    exitMsg,  X
              WD      stdout
              TIX     #9
              JLT     exitPloop
              LDA     #10
              WD      stdout
              RSUB

exitMsg     BYTE    C'Thank you'
