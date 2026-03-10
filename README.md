# FRP Panel - 蓝白毛玻璃主题版 ✨

基于 [FRP](https://github.com/fatedier/frp) 的现代化 Web 管理面板，采用蓝白色调 + 毛玻璃效果设计。

## 🎨 界面特性

- 💎 **毛玻璃效果** - 现代化半透明设计
- 🎨 **蓝白色调** - 清爽大气的配色方案
- ✨ **渐变动画** - 流畅的交互体验
- 📊 **数据可视化** - 优化的统计卡片展示
- 🌓 **深色模式** - 完整的暗色主题支持

## 🚀 一键安装

### 方式一：在线安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/rokesai/frp-panel-azure/main/quick-install.sh | bash
```

或使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/rokesai/frp-panel-azure/main/quick-install.sh | bash
```

### 方式二：克隆安装

```bash
git clone https://github.com/rokesai/frp-panel-azure.git
cd frp-panel-azure
chmod +x install-frp-panel.sh
./install-frp-panel.sh
```

安装脚本会自动：
- ✅ 检测系统环境
- ✅ 安装必要依赖
- ✅ 下载并配置服务
- ✅ 启动服务

访问 `http://你的服务器IP:9000` 开始使用！

## 📦 部署方式

### 方式一：Docker（推荐）

```bash
# 使用安装脚本选择选项 1
./install-frp-panel.sh
```

### 方式二：源码编译

```bash
# 使用安装脚本选择选项 2
./install-frp-panel.sh
```

### 方式三：手动部署

详见 [部署指南](DEPLOY.md)

## 📖 文档

- [📘 安装指南](INSTALL_GUIDE.md) - 详细的安装和使用说明
- [📗 部署指南](DEPLOY.md) - 多种部署方式详解
- [📕 配置说明](docs/all-configs.md) - 完整的配置参数

## 🏗️ 技术栈

**前端**
- Next.js 14 + React 18
- TypeScript
- Tailwind CSS + 毛玻璃效果
- Radix UI 组件库

**后端**
- Go 1.24
- Gin Web 框架
- GORM + SQLite/MySQL/PostgreSQL
- gRPC + WebSocket

## 🌟 核心功能

- 🎛️ Web 可视化管理 FRP 服务
- 👥 多用户 + RBAC 权限控制
- 📊 实时监控和统计
- 🖥️ 远程终端控制
- 🔐 WireGuard VPN 集成
- 📝 配置文件可视化编辑

## 📸 界面预览

> 添加你的截图到这里

## ⚙️ 配置

首次访问时注册的第一个用户将自动成为管理员。

常用环境变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `APP_PORT` | Web 端口 | 9000 |
| `RPC_PORT` | RPC 端口 | 9001 |
| `APP_ENABLE_REGISTER` | 开放注册 | false |
| `DB_DSN` | 数据库路径 | ./data.db |

## 🔄 更新

```bash
# 拉取最新代码
git pull

# 重新运行安装脚本
./install-frp-panel.sh
```

## 🆘 故障排查

### 端口被占用
```bash
netstat -tulpn | grep 9000
```

### 前端样式未生效
```bash
cd www
rm -rf .next out node_modules
pnpm install && pnpm build
```

更多问题请查看 [安装指南](INSTALL_GUIDE.md)

## 📄 开源协议

基于原项目 [VaalaCat/frp-panel](https://github.com/VaalaCat/frp-panel) 修改

## 🙏 致谢

- [FRP](https://github.com/fatedier/frp) - 核心内网穿透功能
- [VaalaCat/frp-panel](https://github.com/VaalaCat/frp-panel) - 原始项目

---

⭐ 如果这个项目对你有帮助，请给个 Star！
