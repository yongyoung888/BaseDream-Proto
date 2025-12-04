chcp 65001

@echo compile proto to java

@call protoc.exe  --java_out  ./../BaseDream-Server/game-message/target/generated-sources/protobuf/java/ *.proto

pause