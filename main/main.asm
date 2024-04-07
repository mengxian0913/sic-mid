MAIN    START   0

first         JSUB	clear		. 清空畫面
              JSUB	printInstr	. 輸出遊戲說明
startInput    TD	stdin		. 讀取輸入裝置
              JEQ	startInput 	. 讀不到則重複讀取
              RD	stdin		. 讀取使用者輸入
              RD	stdin		. 讀取使用者輸入
              COMP	#10		. 與Enter的ASCII code比較
              JEQ	startGame    	. 若使用者點擊Enter則開始遊戲
              JSUB	first 		. 跳回 first

startGame     JSUB	clear		. 清空畫面
              J		judger   	. 強制跳到 judger (選擇比大還是比小)


.---------------- Judger -------------.

. 遊戲判定 .
judger       LDX        #0              . 暫存器 X = 0
stGameLp     LDCH       startMsg, X     . 將 startMsg[X] 存到 A
             WD         stdout		. 將 startMsg[X] 寫在 terminal
             TIX        #22             . X + 1 與 22 比較
             JLT        stGameLp        . < 22 時 跳回 stGameLp 進行迴圈

             LDL        #judger		. L = judger記憶體位址
             STL        func		. func = L = judger記憶體位址
             LDA        #49             . A = 49 (1的ASCII)
             STA        limitL		. limitL = A = 49
             LDA        #50             . A = 50 (2的ASCII)
             STA        limitR		. limitR = A = 50
             JSUB       stdInput        . 跳到stdInput (讀取輸入)
             LDA        inData          . A = inData
             STA        mode          	. 將暫存器A的值存到mode ( 比最大為 1 / 最小 2 / 終止 0)
             JSUB       clear		. 清空畫面
             J          p1		. 強制跳到p1 (輸入1號玩家的數字)

startMsg     BYTE       C'Judger Input (1 | 2): '	.要輸出的文字 (判定輸入: 1或2)
mode         RESW	1				.比較模式

.----------------   Player1    -------------.

p1      LDL     #p1             . L = p1的記憶體位址
        STL     func            . func = L (p1的記憶體位址)
        LDA     #48             . A = 48 (0的ASCII)
        STA     limitL          . limitL = A = 48
        LDA     #57             . A = 57 (9的ASCII)
        STA     limitR          . limitR = A = 57
        JSUB    PP1             . 印出 "Player 1: "
        JSUB    endl            . 換行
        JSUB    PPI             . 印出 "Enter a number (0 - 9): "
        JSUB    stdInput        . 跳到stdInput (讀取輸入)
        LDA     inData          . A = inData
        STA     p1Num           . p1Num = A = inData
        JSUB    clear           . 清空畫面
        J       p2		. 強制跳到p2 (輸入2號玩家的數字)


p1Num       RESW      1         . 用來存1號玩家的數字


.----------------   P2    -------------.

p2      LDL     #p2             . L = p2的記憶體位址
        STL     func            . func = L (p2的記憶體位址)
        LDA     #48             . A = 48 (0的ASCII)
        STA     limitL          . limitL = A = 48
        LDA     #57             . A = 57 (9的ASCII)
        STA     limitR          . limitR = A = 57
        JSUB    PP2             . 印出 "Player 2: "
        JSUB    endl            . 換行
        JSUB    PPI             . 印出 "Enter a number (0 - 9): "
        JSUB    stdInput        . 跳到stdInput (讀取輸入)
        LDA     inData          . A = inData
        STA     p2Num           . p2Num = A = inData
        JSUB    clear           . 清空畫面
        J       GR              . 強制跳到 GR (顯示比較結果)

p2Num       RESW      1         . 用來存2號玩家的數字

.------------   Get result -------------.

. 顯示結果 .
GR          LDX     #0          . X = 0
modeLP      LDCH    modeMsg, X  . A = modeMsg[X]
            WD      stdout	. 將 modeMsg[X] 寫在 terminal
            TIX     #6          . X + 1 與 6 比較
            JLT     modeLP      . < 6 跳回 modeLP 進行迴圈
            LDA     mode        . A = mode
            COMP    #49         . 與 49 (1的ASCII) 比較
            JEQ     PTMAX       . A = 49 跳到 PTMAX (輸出提示訊息顯示要比大)
            J       PTMIN       . A != 49 強制跳到 PTMIN (輸出提示訊息顯示要比小)
GR2         LDA     #10         . A = 10 (Enter的 ASCII)
            WD      stdout      . 在 terminal 輸出 A (換行)
            LDX     #0          . X = 0
GRLP        LDCH    grMsg, X    . A = grMsg[X]
            WD      stdout      . 將 grMsg[X] 寫在 terminal
            TIX     #8          . X + 1 與 8 比較
            JLT     GRLP        . < 8 跳回 GRLP 進行迴圈
            LDA     mode        . A = mode
            COMP    #49         . 與 49 (1的ASCII) 比較
            JEQ     mode1       . A = 49 跳到 mode1 (比大)
            J       mode2       . A != 49 跳到 mode2 (比小)

PTMAX       LDX     #0          . X = 0
maxLP       LDCH    maxMsg, X   . A = maxMsg[X]
            WD      stdout      . 將 maxMsg[X] 寫在 terminal
            TIX     #7          . X + 1 與 7 比較
            JLT     maxLP       . < 7 跳回 maxLP 進行迴圈
            J       GR2         . 強制跳到 GR2 

PTMIN       LDX     #0          . X = 0
minLP       LDCH    minMsg, X   . A = minMsg[X]
            WD      stdout      . 將 minMsg[X] 寫在 terminal
            TIX     #7          . X + 1 與 7 比較
            JLT     minLP       . < 7 跳回 minLP 進行迴圈
            J       GR2         . 強制跳到 GR2

maxMsg      BYTE   C'maxinum'   . 提示訊息為比大
minMsg      BYTE   C'mininum'   . 提示訊息為比小
modeMsg     BYTE   C'mode: '    . 輸出比較模式


mode1   LDA     p1Num   . 將 p1Num 存入 A
        COMP    p2Num   . 讓 p1Num (A) 與 p2Num 比較
        JGT     p1win   . p1Num > p2Num 跳到 p1win (1號玩家贏了)
        JLT     p2win   . p1Num < p2Num 跳到 p2win (2號玩家贏了)
        JEQ     tie     . p1Num = p2Num 跳到 tie (平手)

mode2   LDA     p1Num
        COMP    p2Num
        JLT     p1win   . p1Num < p2Num 跳到 p1win
        JGT     p2win   . p1Num > p2Num 跳到 p2win
        JEQ     tie


p1win           LDX     #0              . X = 0
p1Loop          LDCH    p1Msg, X	. 將 p1Msg[X] 存入 A
                WD      stdout	        . 將 p1Msg[X] 寫在 terminal
                TIX     #13		. 將 X + 1 與 13 比較
                JLT     p1Loop          . < 13 時 跳回 p1Loop 進行迴圈
                JSUB    endl            . 輸出換行
                RD      stdin           . 讀取使用者輸入
                RD      stdin           . 讀取使用者輸入
                J       first		. 強制跳回first (重新開始遊戲)


p2win           LDX     #0              . X = 0
p2Loop          LDCH    p2Msg, X	. 將 p2Msg[X] 存入A
                WD      stdout          . 將 p2Msg[X] 寫在 terminal
                TIX     #13		. 將 X + 1 與 13 比較
                JLT     p2Loop          . < 13 時 跳回 p2Loop 進行迴圈
                JSUB    endl            . 輸出換行
                RD      stdin           . 讀取使用者輸入
                RD      stdin           . 讀取使用者輸入
                J       first		. 強制跳回first (重新開始遊戲)


tie             LDX     #0              . X = 0
tieLoop         LDCH    tieMsg, X	. 將 tieMsg[X] 存入 A
                WD      stdout          . 將 tieMsg[X] 寫在 terminal
                TIX     #9		. 將 X + 1 與 9 比較
                JLT     tieLoop         . < 9 時 跳回 tieLoop 進行迴圈
                JSUB    endl            . 輸出換行
                RD      stdin           . 讀取使用者輸入
                J       first           . 跳回 first (重新開始遊戲)




grMsg   BYTE    C'Result: '		. 輸出結果
p1Msg   BYTE    C'Player 1 win!'	. 輸出1號玩家獲勝
p2Msg   BYTE    C'Player 2 win!'	. 輸出2號玩家獲勝
tieMsg  BYTE    C'Is a TIE!'	        . 輸出平手

.--------------------     Print Play Instruction   --------------------.

. PP1 (print player1 instruction) 印出"Player 1: " .
PP1     LDX     #0              . X = 0
PP1LP   LDCH    pp1Msg, X	. 將 pp1Msg[X] 存入 A
        WD      stdout		. 將 pp1Msg[X] 寫在 terminal
        TIX     #10		. 將 X + 1 與 10 比較
        JLT     PP1LP		. < 10 時 跳回 PP1LP 進行迴圈
        RSUB			. 回到 p1 繼續執行剩下的程式

. PP2 (print player2 instruction) 印出"Player 2: " .
PP2     LDX     #0
PP2LP   LDCH    pp2Msg, X	. 將pp2Msg[X]存入A
        WD      stdout		. 將pp2Msg[X]寫在terminal
        TIX     #10
        JLT     PP2LP		. <10時 跳回PP2LP進行迴圈
        RSUB			. 回到p2繼續執行剩下的程式


pp1Msg  BYTE    C'Player 1: '	. PP1裡要輸出的訊息 
pp2Msg  BYTE    C'Player 2: '	. PP2裡要輸出的訊息


. 印出"Enter a number(0 - 9): " .
PPI     LDX     #0
PPILP   LDCH    ppiMsg, X       . 將ppiMsg[X]存入A
        WD      stdout		. 將ppiMsg[X]寫在terminal
        TIX     #24		. 將X+1與24比較
        JLT     PPILP		. <24時 跳回PPILP進行迴圈
        RSUB			. 回到p1或p2繼續執行剩下的程式

ppiMsg  BYTE    C'Enter a number (0 - 9): '	. 輸出提示訊息請使用者輸入數字

. 印出遊戲說明 .
printInstr      TD      stdout          . 確認輸出裝置是否就緒
                JEQ     printInstr      . 未就緒則跳回 printInstr 持續確認

                LDX     #0              . 暫存器 X = 0
ploop1          LDCH    instr1, X       . 將 instr1[X] 存入 A
                WD      stdout          . 將 instr1[X] 寫在 terminal
                TIX     #19		. 將 X + 1 與 19 比較
                JLT     ploop1		. < 19 時 跳回 ploop 進行迴圈
                JSUB    endl            . 輸出換行

                LDX     #0              . 暫存器 X = 0
ploop2          LDCH    instr2, X       . 將 instr2[X] 存入 A
                WD      stdout          . 將 instr2[X] 寫在 terminal
                TIX     #28		. 將 X + 1 與 28 比較
                JLT     ploop2		. < 28 時 跳回 ploop 進行迴圈
                JSUB    endl            . 輸出換行

                LDX     #0              . 暫存器 X = 0
ploop3          LDCH    instr3, X       . 將 instr3[X] 存入 A
                WD      stdout          . 將 instr3[X] 寫在 terminal
                TIX     #33		. 將 X + 1 與 33 比較
                JLT     ploop3		. < 33 時 跳回 ploop 進行迴圈
                JSUB    endl            . 輸出換行

                LDX     #0              . 暫存器 X = 0
ploop4          LDCH    instr4, X       . 將 instr4[X] 存入 A
                WD      stdout          . 將 instr4[X] 寫在 terminal
                TIX     #20		. 將 X + 1 與 20 比較
                JLT     ploop4		. < 20 時 跳回 ploop 進行迴圈
                JSUB    endl            . 輸出換行
                J       startInput      . 跳回原本的程式繼續執行
instr1   BYTE    C'Welcome to B B See!'                 . 遊戲開場白1
instr2   BYTE    C'Input 1 or 2 to choose mode.'        . 遊戲開場白2
instr3   BYTE    C'And input two numbers to compare.'   . 遊戲開場白3
instr4   BYTE    C'Enter to continue...'                . 遊戲開場白4


.--------------------  stdout  ------------------------.

. 清空畫面 .
clear           LDA     #0      . 將 0 存入 A
clearLp         STA     tmpLine	. tmpLine = A
                LDA     #10     . 將 Enter 存入 A
                WD      stdout	. 輸出換行
                LDA     tmpLine	. A = tmpLine
                ADD     #1      . A + 1
                COMP    lines   . 與 50 比較
                JLT     clearLp	. < 50 跳回 clearLp 進行迴圈
                RSUB

lines           WORD    50	. lines = 50
tmpLine         RESW    1	. tmpLine的大小為 1 WORD

. 換行 .
endl    STA     tmp     . tmp = A
        LDA     #10     . A = 10 (Enter)
        WD      stdout  . 將 A (Enter) 寫入terminal
        LDA     tmp     . A = tmp
        RSUB            . 跳回原本的函式

tmp     RESW    1       . 存 A 原本的值


.--------------------  Stander Input ------------------.


stdInput        RD      stdin           . 讀取使用者輸入
                COMP    #48             . 與 48 (0的ASCII) 比較
                JEQ	close           . A = 48 跳到 close (結束遊戲)
                J       ffST            . 強制跳到ffST (存第一個字元)


endInput        LDA     inData          . A = inData
                COMP    limitL	        . A (inData) 與 limitL 比較
                JLT     reInput         . A < limitL 跳到 reInput (重新輸入)
                COMP    limitR          . A 與 limitL 比較
                JGT     reInput         . A > limitR 跳到 reInput (重新輸入)
                RSUB


ffST            STA     inData          . inData = A
                RD      stdin           . 讀取使用者輸入
        
                RD      stdin           . 讀取使用者輸入
                COMP    #10             . 與 10 (Enter) 比較
                JEQ     endInput        . 跳到endInput (判定輸入是否為1或2)

IPLP            RD      stdin           . 讀取使用者輸入
                RD      stdin           . 讀取使用者輸入
                COMP    #10             . 與 10 (Enter) 比較
                JEQ     reInput         . 跳到 reInput (重新輸入)
                J       IPLP            . 若非 Enter 則繼續讀取


reInput         JSUB         clear          . 清空畫面
                LDL          func           . L = func
                RSUB
inData      RESW        1       . 用來存使用者輸入的值
limitL      RESW        1       . 用來存輸入限制的最小值 (小於此值需重新輸入)
limitR      RESW        1       . 用來存輸入限制的最大值 (大於此值須重新輸入)

. 結束遊戲 .
close   LDX     #0              . 暫存器 X = 0
CLP     LDCH    endMsg, X       . 將 endMsg[X] 存入 A
        WD      stdout          . 將 endMsg[X] 寫在 terminal
        TIX     #27		. 將 X + 1 與 27 比較
        JLT     CLP		. < 27 時 跳回 CLP 進行迴圈
        JSUB    endl            . 輸出換行
        J	bye             . 強制跳到 bye (結束程式)

endMsg  BYTE    C'See you next time! Bye Bye~'
.--------------------- variables -----------------------.

stdin         BYTE      0       . 輸入裝置
stdout        BYTE      1       . 輸出裝置
func          RESW      1       . 存 judger 的記憶體位址

bye        END     first        .結束程式碼
