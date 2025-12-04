chcp 65001

@echo compile proto to java

@call protoc.exe  --java_out  ./../BaseDream-Server/game-common/src/main/java/ *.proto

pause