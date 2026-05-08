# AGENT.md

## 项目定位

这是一个协议仓库，核心内容是根目录下的 `.proto` 文件，用于为客户端和服务端生成通信协议代码。

- 客户端输出：C#，默认生成到 `../BaseDream/Assets/Scripts/Protos/`
- 服务端输出：Java，默认生成到 `../BaseDream-Server/game-common/src/main/java/`
- gRPC：服务端可额外生成 Java gRPC 存根代码，并按脚本逻辑移动到 `com.yongyoung.dream.grpc`

这个仓库本身不是完整应用，主要职责是维护协议定义和协议代码生成入口。

## 仓库结构

- 根目录 `.proto` 文件是实际业务协议定义，例如 `Account.proto`、`Player.proto`、`Map.proto`
- `build.bat` 串行执行客户端和服务端生成
- `build_client.bat` 生成 C# 协议代码
- `build_server.bat` 生成 Java 协议代码
- `build_server_with_grpc.bat` 生成 Java 协议代码和 gRPC 存根代码，并对生成后的 gRPC 文件做包名迁移
- `include/` 是 protobuf 官方 include 目录
- `protobuf-26.1/` 是 protobuf 源码/发行包内容，默认视为第三方目录
- `protoc.exe`、`protoc-gen-grpc-java.exe` 是本仓库自带的生成工具

## 关键约定

- 业务修改应优先集中在根目录 `.proto` 文件，不要随意修改 `include/` 或 `protobuf-26.1/`
- 现有 proto 普遍声明：
  - `package ProtoMessage;`
  - `option java_package = "com.yongyoung.dream";`
  - `option go_package = "message";`
- 多个文件之间有导入依赖，例如 `Player.proto` 依赖 `Map.proto`
- 仓库内存在中文注释乱码现象，当前文件编码和终端编码可能不一致；除非任务明确要求，不要顺手批量“修复编码”
- 当前工作区可能有用户未提交修改，尤其是 `Common.proto`、`MessageId.proto`、`Player.proto`；修改前先阅读并保留现有变更
- 根目录出现了一个 `NUL` 文件，这在 Windows 下较异常；如果任务未明确要求，不要主动处理它

## 推荐工作方式

1. 先阅读将要修改的 `.proto` 以及其直接导入的文件，确认消息结构和编号影响面。
2. 如果新增消息：
   - 保持命名风格一致，通常使用 `XxxRequest` / `XxxResponse`
   - 检查是否需要同步更新 `MessageId.proto` 中的 `MID` 枚举
   - 检查客户端和服务端是否依赖生成后的类名或包名
3. 如果调整字段：
   - 优先追加新字段，避免复用或改写已有字段编号
   - 非必要不要删除既有字段编号
   - 注意 proto3 兼容性，避免破坏旧客户端或服务端的反序列化
4. 修改后按需执行生成脚本验证，不要假设外部兄弟仓库一定存在

## 常用命令

在仓库根目录执行：

```powershell
.\build_client.bat
.\build_server.bat
.\build.bat
.\build_server_with_grpc.bat
```

如果只想直接调用 protoc，可参考现有脚本：

```powershell
.\protoc.exe --csharp_out=./../BaseDream/Assets/Scripts/Protos/ *.proto
.\protoc.exe --java_out ./../BaseDream-Server/game-common/src/main/java/ *.proto
```

## 编辑原则

- 只在任务需要时修改根目录业务 `.proto`
- 不要编辑生成产物，除非任务明确要求处理外部生成目录
- 不要把格式化、重排、注释改写和协议变更混在一起
- 修改 `MessageId.proto` 时，保持编号段语义和已有范围约定
- 新增服务或远程调用时，保持现有 Java 包约定与 `build_server_with_grpc.bat` 的迁移逻辑兼容

## 验证原则

- 能运行脚本时，至少验证对应脚本是否成功执行
- 如果外部输出目录不存在，明确说明无法完成完整生成验证
- 若只做静态修改，至少检查：
  - proto 语法是否闭合
  - 导入是否正确
  - 消息字段编号是否冲突
  - `MessageId.proto` 是否与新增请求和响应保持一致

## 给后续智能体的提醒

- 这是协议仓库，不要用应用仓库的思路进行“大重构”
- 首先保护协议兼容性，其次才是命名和样式一致性
- 用户很可能同时维护客户端/服务端兄弟仓库，任何输出路径变更都属于高风险改动
- 默认不要碰 `protobuf-26.1/`、`include/`、`protoc*.exe`
