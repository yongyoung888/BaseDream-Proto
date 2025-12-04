chcp 65001

@echo compile proto to C#

@call protoc.exe  --csharp_out=./../BaseDream/Assets/Scripts/Protos/ *.proto

pause