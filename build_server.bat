chcp 65001

@echo compile proto to java

@call protoc.exe  --java_out  ./../BaseDream-Server/game-common/src/main/java/ --grpc-java_out ./../BaseDream-Server/game-common/src/main/java/ --grpc-java_opt="java_package=com.yongyoung.dream.grpc" *.proto

pause