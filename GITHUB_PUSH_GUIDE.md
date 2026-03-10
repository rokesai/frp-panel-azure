# 推送到 GitHub 完整指南

## 📦 准备工作

### 1. 在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 仓库名：`frp-panel-azure`
3. 描述：Modern Azure Glass Theme for FRP Panel
4. 选择 Public（公开）
5. **不要**勾选 "Add a README file"
6. 点击 "Create repository"

---

## 🚀 推送代码到 GitHub

### 方式一：使用 Git 命令行（推荐）

在你的项目目录下执行：

```bash
# 1. 初始化 Git（如果还没有）
git init

# 2. 添加所有文件
git add .

# 3. 提交
git commit -m "feat: FRP Panel Azure - 蓝白毛玻璃主题版"

# 4. 添加远程仓库
git remote add origin https://github.com/rokesai/frp-panel-azure.git

# 5. 推送到 GitHub
git branch -M main
git push -u origin main
```

### 方式二：使用 GitHub Desktop

1. 下载安装 GitHub Desktop
2. 打开项目文件夹
3. 点击 "Publish repository"
4. 选择仓库名：frp-panel-azure
5. 点击 "Publish"

### 方式三：使用 VSCode

1. 在 VSCode 中打开项目
2. 点击左侧 "Source Control" 图标
3. 点击 "Initialize Repository"
4. 输入提交信息
5. 点击 "Publish to GitHub"

---

## ⚠️ 常见问题

### 1. 提示需要登录

```bash
# 配置 Git 用户信息
git config --global user.name "rokesai"
git config --global user.email "你的邮箱@example.com"

# 使用 Personal Access Token 登录
# 在 GitHub 设置中生成 Token: Settings -> Developer settings -> Personal access tokens
```

### 2. 推送被拒绝

```bash
# 强制推送（首次推送时）
git push -u origin main --force
```

### 3. 文件太大

GitHub 单个文件限制 100MB，如果有大文件：

```bash
# 添加到 .gitignore
echo "node_modules/" >> .gitignore
echo "dist/" >> .gitignore
echo "*.log" >> .gitignore
```

---

## 📝 推荐的 .gitignore

创建 `.gitignore` 文件：

```gitignore
# 依赖
node_modules/
www/node_modules/

# 构建产物
dist/
www/.next/
www/out/

# 日志
*.log
npm-debug.log*

# 环境变量
.env
.env.local

# 数据库
*.db
*.db-shm
*.db-wal
data/

# 系统文件
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
```

---

## ✅ 验证推送成功

推送完成后：

1. 访问 https://github.com/rokesai/frp-panel-azure
2. 应该能看到所有文件和文件夹
3. README.md 会自动显示在首页

---

## 🎯 推送后的操作

### 1. 更新 README

确保 README.md 中的安装命令正确：

```bash
curl -fsSL https://raw.githubusercontent.com/rokesai/frp-panel-azure/main/quick-install.sh | bash
```

### 2. 添加 Topics（标签）

在 GitHub 仓库页面：
- 点击右侧 "About" 旁边的齿轮图标
- 添加 Topics：`frp`, `panel`, `glass-ui`, `azure-theme`, `golang`, `nextjs`

### 3. 添加截图

在 README 中添加界面截图：
1. 截取界面图片
2. 上传到 GitHub Issues 或使用图床
3. 在 README 中引用图片链接

### 4. 创建 Release

```bash
# 打标签
git tag -a v1.0.0 -m "首个正式版本"
git push origin v1.0.0
```

然后在 GitHub 上创建 Release。

---

## 🔄 后续更新

修改代码后推送：

```bash
# 1. 查看修改
git status

# 2. 添加修改
git add .

# 3. 提交
git commit -m "fix: 修复某个问题"

# 4. 推送
git push
```

---

## 📞 需要帮助？

如果遇到问题：
1. 检查网络连接
2. 确认 GitHub 账号已登录
3. 查看错误信息
4. 搜索错误信息解决方案

---

## 🎉 完成！

推送成功后，你的一键安装命令就可以使用了：

```bash
curl -fsSL https://raw.githubusercontent.com/rokesai/frp-panel-azure/main/quick-install.sh | bash
```

分享给其他人即可！
