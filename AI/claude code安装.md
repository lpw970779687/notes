# Claude Code 安装及 DeepSeek 接入教程（Windows）

本文介绍如何在 Windows 环境下安装 Claude Code，并通过 CC Switch 接入 DeepSeek 模型。

---

# 一、安装 Git

首先打开 **PowerShell**，执行下面命令安装 Git：

```powershell
winget install Git.Git
```

安装过程中：

1. 根据提示输入 **Y** 确认安装；
2. 等待下载完成；
3. 弹出 Git 安装程序后继续按照默认选项安装即可。

安装完成后，关闭当前 PowerShell，重新打开一个新的 PowerShell，执行：

```powershell
git --version
```

如果能够看到类似下面的信息，则说明 Git 已安装成功：

```text
git version 2.xx.x.windows.x
```

---

# 二、安装 Claude Code

## 方法一：使用官方安装脚本（推荐，需要能够访问 Claude 官网）

```powershell
irm https://claude.ai/install.ps1 | iex
```

---

## 方法二：使用 Winget 安装（适用于无法访问官网的情况）

```powershell
winget install Anthropic.ClaudeCode
```

---

## 检查安装是否成功

安装完成后执行：

```powershell
claude --version
```

正常情况下会显示类似：

```text
2.x.x (Claude Code)
```

---

## 如果提示 `claude` 找不到

例如：

```text
claude : 无法将“claude”项识别为 cmdlet...
```

说明 **Claude Code 已安装，但没有加入 PATH 环境变量**。

### 第一步：搜索安装位置

执行：

```powershell
Get-ChildItem C:\ -Filter claude.exe -Recurse -ErrorAction SilentlyContinue
```

例如得到：

```text
目录: C:\Users\用户名\.local\bin

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          xxxx/xx/xx      xx:xx      241591968 claude.exe
```

说明 Claude 安装目录为：

```text
C:\Users\用户名\.local\bin
```

---

### 第二步：添加到 PATH

将上面的目录添加到 **用户环境变量 Path** 中。

然后：

1. 关闭 PowerShell；
2. 重新打开新的终端；

再次执行：

```powershell
claude --version
```

即可正常识别。

---

# 三、安装 CC Switch

项目地址：

```
https://github.com/farion1231/cc-switch
```

安装步骤：

1. 打开 GitHub 页面；
2. 点击右侧 **Releases（发布）**；
3. 下载最新版本；
4. Windows 用户下载 **.msi** 安装版；
5. 双击安装；
6. 安装完成后启动 CC Switch。

---

# 四、获取 DeepSeek API Key

打开 DeepSeek 开放平台：

```
https://platform.deepseek.com
```

操作流程：

1. 注册并登录账号；
2. 完成实名认证（新用户需要）；
3. 充值（建议先充值 10 元即可）；
4. 点击 **API Keys**；
5. 创建新的 API Key。

> **注意：**
>
> API Key 仅在创建时显示一次，请务必妥善保存，否则后续无法再次查看完整内容。

---

# 五、在 CC Switch 中添加 DeepSeek

打开 CC Switch：

1. 点击右上角 **+** 按钮；
2. 选择 **DeepSeek**；
3. 在 **API Key** 中填写刚才创建的 Key；
4. 配置模型映射。

推荐添加两个模型：

| 模型                | 说明               |
| ----------------- | ---------------- |
| deepseek-v4-flash | 响应速度快，成本低，适合日常开发 |
| deepseek-v4-pro   | 推理能力更强，成本较高      |

配置完成后点击 **添加** 即可。

---

# 六、在 Claude Code 中使用 DeepSeek

打开 PowerShell：

```powershell
claude
```

首次启动根据提示一直按 **Enter** 即可。

进入 Claude Code 后，在界面底部即可看到当前使用的模型。

如果 CC Switch 配置正确，此时即可通过 Claude Code 调用 DeepSeek 模型。

---

## 跳过权限确认（可选）

如果希望 Claude Code 在执行文件修改等操作时减少权限确认，可以使用：

```powershell
claude --dangerously-skip-permissions
```

> ⚠️ **注意：**
>
> 该参数会跳过部分安全确认，仅建议在完全信任当前项目和命令的情况下使用。

---

# 七、自定义 Claude 行为规范

Claude Code 支持通过 Markdown 文件定义开发规范。

## 1. 项目级规则

在当前项目根目录创建：

```text
CLAUDE.md
```

Claude 会自动读取该文件，并遵循其中定义的开发规范。

适合存放：

* 项目编码规范
* 命名规则
* 开发流程
* 提交规范
* 回复格式
* 代码风格
* 技术栈要求

该文件仅对当前项目生效。

---

## 2. 全局规则

除了项目级 `CLAUDE.md` 外，还可以配置全局规则。

全局规则会在所有项目中生效，适合存放：

* 通用编码习惯
* 回复语言（例如始终使用中文）
* 注释规范
* 代码风格
* 常用开发约定

这样无论进入哪个项目，Claude Code 都会自动遵循这些规则。

---

# 常见问题

## Claude 命令无法识别

原因：

* Claude Code 未安装完成；
* PATH 环境变量未配置；
* 终端未重新打开。

---

## Git 无法使用

执行：

```powershell
git --version
```

如果提示找不到命令，请重新安装 Git，并确认安装过程中勾选了 **Add Git to PATH**。

---

## DeepSeek 无法调用

请检查：

* API Key 是否正确；
* 账户余额是否充足；
* CC Switch 是否已启动；
* 模型映射是否配置正确。

---

# 总结

整个安装流程如下：

1. 安装 Git
2. 安装 Claude Code
3. 配置 PATH（如有需要）
4. 安装 CC Switch
5. 获取 DeepSeek API Key
6. 配置 DeepSeek 模型
7. 启动 Claude Code
8. 配置 `CLAUDE.md` 开发规范

完成以上步骤后，即可在 Windows 环境下使用 Claude Code，并通过 CC Switch 调用 DeepSeek 模型进行开发。
