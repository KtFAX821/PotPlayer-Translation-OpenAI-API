# PotPlayer Translation OpenAI API

### [English](https://github.com/KtFAX821/PotPlayer-Translation-OpenAI-API/blob/main/README.md)/[简体中文](https://github.com/KtFAX821/PotPlayer-Translation-OpenAI-API/blob/main/README-cn.md)
### [免责声明](https://github.com/KtFAX821/PotPlayer-Translation-OpenAI-API/blob/main/Disclaimer.md)
## 项目介绍

本项目已由作者开源



本实现方案通过调用 **OpenAI API 兼容** 的大语言模型，为 PotPlayer 提供**字幕翻译**功能

支持集成以下服务：
- 官方部署模型（如 ChatGPT、深度求索、通义千问）
- 通过 Ollama 本地部署的模型
- 其他任意 **OpenAI API 兼容** 服务

## API 文档

[OpenAI API 文档](https://platform.openai.com/docs/api-reference)

[Ollama API 文档](https://ollama.com/blog/openai-compatibility)

## 使用方法
### 下载
将文件复制至：  
`C:\Program Files\DAUM\PotPlayer\Extension\Subtitle\Translate`

### 参数配置
**模型及API地址:** `Model&API URL`

**API密钥:** `API Key`

## 运行要求

- [PotPlayer 播放器](https://potplayer.tv/)
- 任意 OpenAI API 兼容服务的 URL 地址及 API 密钥

## 注意事项
- API 调用可能存在网络延迟
- API 使用可能产生费用，建议设置用量提醒

## 关于
本项目为修改版本，原项目：[PotPlayer Translation OpenAI API](https://github.com/Fung-2025/potplayer-translation-openaiapi)

## 更新日志
- 修复 URL 解析问题，将分隔符从 `&` 改为 `|` 以避免与查询参数冲突；使用 `HostSaveString`/`HostLoadString` 实现配置持久化；API URL 缺少 `/chat/completions` 时自动补全。

## 故障排除
重启软件可解决部分异常情况
