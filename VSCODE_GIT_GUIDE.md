# VSCode Git 操作详细指南

## 🔍 找到 Source Control（源代码管理）

### 方法一：侧边栏图标
1. 看 VSCode 左侧的图标栏
2. 找到一个**分叉图标**（像树枝分叉的样子）
3. 或者找到有**数字标记**的图标
4. 点击它就是 Source Control

### 方法二：快捷键
- **Windows/Linux**: `Ctrl + Shift + G`
- **macOS**: `Cmd + Shift + G`

### 方法三：命令面板
1. 按 `Ctrl + Shift + P` (macOS: `Cmd + Shift + P`)
2. 输入 `Git: Initialize Repository`
3. 选择当前文件夹

---

## 📸 VSCode Git 界面说明

```
┌─────────────────────────────────────┐
│  VSCode 左侧图标栏                   │
├─────────────────────────────────────┤
│  📁 Explorer (资源管理器)            │
│  🔍 Search (搜索)                    │
│  🌿 Source Control (源代码管理) ← 这个！│
│  🐛 Run and Debug (运行和调试)       │
│  📦 Extensions (扩展)                │
└─────────────────────────────────────┘
```

---

## 🚀 使用 VSCode 推送到 GitHub（完整步骤）

### 步骤 1: 初始化 Git 仓库

1. 点击左侧 **Source Control** 图标（分叉图标）
2. 如果看到 "Initialize Repository" 按钮，点击它
3. 选择当前项目文件夹

### 步骤 2: 暂存文件

1. 在 Source Control 面板中，你会看到所有修改的文件
2. 点击文件旁边的 **+** 号（暂存单个文件）
3. 或点击顶部的 **+** 号（暂存所有文件）

### 步骤 3: 提交

1. 在顶部的消息框中输入提交信息：
   ```
   feat: FRP Panel Azure - 蓝白毛玻璃主题版
   ```
2. 点击 **✓ Commit** 按钮（或按 `Ctrl + Enter`）

### 步骤 4: 发布到 GitHub

1. 点击 **Publish Branch** 或 **Publish to GitHub** 按钮
2. 选择 **Publish to GitHub public repository**
3. 输入仓库名：`frp-panel-azure`
4. 等待上传完成

---

## ⚠️ 如果没有看到 "Publish to GitHub"

### 原因 1: 需要登录 GitHub

1. 点击左下角的**账户图标**
2. 选择 **Sign in to sync settings**
3. 选择 **Sign in with GitHub**
4. 在浏览器中授权 VSCode

### 原因 2: 需要安装 GitHub 扩展

1. 点击左侧 **Extensions** 图标（方块图标）
2. 搜索 **GitHub Pull Requests and Issues**
3. 点击 **Install** 安装
4. 重启 VSCode

### 原因 3: 使用命令面板

1. 按 `Ctrl + Shift + P`
2. 输入 `Git: Add Remote`
3. 输入远程仓库 URL：
   ```
   https://github.com/rokesai/frp-panel-azure.git
   ```
4. 输入名称：`origin`
5. 再按 `Ctrl + Shift + P`
6. 输入 `Git: Push`

---

## 🎯 推荐方案：使用命令行（最简单）

如果 VSCode 的 Git 功能不好用，直接用命令行更简单：

### 在 VSCode 中打开终端

1. 按 `` Ctrl + ` `` (反引号键)
2. 或点击菜单：**Terminal** → **New Terminal**

### 执行命令

```bash
# 1. 初始化
git init

# 2. 添加所有文件
git add .

# 3. 提交
git commit -m "feat: FRP Panel Azure - 蓝白毛玻璃主题版"

# 4. 添加远程仓库
git remote add origin https://github.com/rokesai/frp-panel-azure.git

# 5. 推送
git branch -M main
git push -u origin main
```

---

## 🔐 如果提示需要登录

### 方法一：使用 Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. 勾选 **repo** 权限
4. 生成 Token 并复制
5. 推送时输入：
   - Username: `rokesai`
   - Password: `粘贴你的 Token`

### 方法二：使用 GitHub CLI

```bash
# 安装 GitHub CLI
# Windows: winget install GitHub.cli
# macOS: brew install gh
# Linux: 见 https://cli.github.com/

# 登录
gh auth login

# 推送
git push -u origin main
```

---

## 📝 VSCode Git 常用操作

### 查看更改
- 点击文件查看差异对比
- 绿色 = 新增
- 红色 = 删除
- 蓝色 = 修改

### 撤销更改
- 点击文件旁边的 **↶** 图标

### 查看历史
- 右键文件 → **Open Timeline**

### 切换分支
- 点击左下角的分支名
- 选择或创建新分支

---

## 🆘 常见问题

### 1. 找不到 Source Control 图标

**解决方案：**
- 确保 VSCode 版本 ≥ 1.60
- 更新 VSCode 到最新版本
- 重启 VSCode

### 2. 提示 "Git not found"

**解决方案：**
```bash
# Windows: 下载安装 Git
https://git-scm.com/download/win

# macOS
brew install git

# Linux
sudo apt-get install git
```

### 3. 推送失败

**解决方案：**
```bash
# 查看错误信息
git push -v

# 强制推送（首次）
git push -u origin main --force
```

---

## ✅ 验证推送成功

1. 访问 https://github.com/rokesai/frp-panel-azure
2. 应该能看到所有文件
3. README 会自动显示

---

## 🎉 推送成功后

你的一键安装命令就可以使用了：

```bash
curl -fsSL https://raw.githubusercontent.com/rokesai/frp-panel-azure/main/quick-install.sh | bash
```

分享给其他人即可！
