# 检查参数数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 <fileName.asm>"
    exit 1
fi

# 運行 Java命令

echo building... 

java -cp ~/Desktop/SicTools/out/make/sictools.jar sic.Asm "$1"
# java -jar out/make/sictools.jar
