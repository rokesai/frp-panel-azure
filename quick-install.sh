#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 显示欢迎信息
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║        FRP Panel Azure 一键安装脚本                   ║
║        蓝白毛玻璃主题版                               ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# 检测系统
print_info "检测系统环境..."
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"
print_success "系统: $OS, 架构: $ARCH"

# GitHub 仓库信息
GITHUB_USER="rokesai"
GITHUB_REPO="frp-panel-azure"
GITHUB_BRANCH="main"

# 临时目录
TEMP_DIR="/tmp/frp-panel-install-$$"
INSTALL_DIR="/opt/frp-panel"

# 清理函数
cleanup() {
    print_info "清理临时文件..."
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 检查命令
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 安装依赖
install_dependencies() {
    print_info "检查并安装依赖..."
    
    if [[ "$OS" == "linux" ]]; then
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y curl wget git
        elif command_exists yum; then
            sudo yum install -y curl wget git
        fi
    elif [[ "$OS" == "darwin" ]]; then
        if ! command_exists brew; then
            print_error "请先安装 Homebrew: https://brew.sh"
            exit 1
        fi
        brew install curl wget git
    fi
}

# 选择部署方式
echo ""
print_info "请选择部署方式:"
echo "  1) Docker 部署 (推荐)"
echo "  2) 二进制部署 (直接运行)"
read -p "请输入选项 [1-2]: " DEPLOY_METHOD

if [[ "$DEPLOY_METHOD" == "1" ]]; then
    # Docker 部署
    print_info "选择: Docker 部署"
    
    # 检查 Docker
    if ! command_exists docker; then
        print_error "未检测到 Docker"
        print_info "正在安装 Docker..."
        curl -fsSL https://get.docker.com | sh
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    
    print_info "下载项目..."
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    git clone --depth 1 -b "$GITHUB_BRANCH" "https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git"
    cd "$GITHUB_REPO"
    
    # 询问配置
    read -p "是否开放用户注册? [y/N]: " ENABLE_REGISTER
    [[ "$ENABLE_REGISTER" =~ ^[Yy]$ ]] && REGISTER_FLAG="true" || REGISTER_FLAG="false"
    
    read -p "Web 端口 (默认 9000): " WEB_PORT
    WEB_PORT=${WEB_PORT:-9000}
    
    # 创建安装目录
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp -r . "$INSTALL_DIR/"
    cd "$INSTALL_DIR"
    
    # 构建并启动
    print_info "构建 Docker 镜像..."
    sudo docker-compose up -d --build
    
    print_success "Docker 部署完成！"
    
elif [[ "$DEPLOY_METHOD" == "2" ]]; then
    # 二进制部署
    print_info "选择: 二进制部署"
    
    # 下载预编译文件
    print_info "下载预编译文件..."
    RELEASE_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/latest/download/frp-panel-${OS}-${ARCH}"
    
    sudo mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    sudo curl -L -o frp-panel "$RELEASE_URL"
    sudo chmod +x frp-panel
    
    # 询问配置
    read -p "是否开放用户注册? [y/N]: " ENABLE_REGISTER
    [[ "$ENABLE_REGISTER" =~ ^[Yy]$ ]] && REGISTER_FLAG="true" || REGISTER_FLAG="false"
    
    read -p "Web 端口 (默认 9000): " WEB_PORT
    WEB_PORT=${WEB_PORT:-9000}
    
    # 创建配置文件
    sudo tee .env > /dev/null <<EOF
APP_ENABLE_REGISTER=$REGISTER_FLAG
APP_PORT=$WEB_PORT
DB_DSN=./data/data.db?_pragma=journal_mode(WAL)
EOF
    
    # 创建 systemd 服务
    sudo tee /etc/systemd/system/frp-panel.service > /dev/null <<EOF
[Unit]
Description=FRP Panel Azure
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
EnvironmentFile=$INSTALL_DIR/.env
ExecStart=$INSTALL_DIR/frp-panel master
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    # 启动服务
    sudo systemctl daemon-reload
    sudo systemctl enable frp-panel
    sudo systemctl start frp-panel
    
    print_success "二进制部署完成！"
fi

# 显示结果
echo ""
print_success "=========================================="
print_success "🎉 安装完成！"
print_success "=========================================="
echo ""
print_info "访问地址: http://$(hostname -I | awk '{print $1}'):${WEB_PORT:-9000}"
print_info "安装目录: $INSTALL_DIR"
print_info "数据目录: $INSTALL_DIR/data"
echo ""
print_info "管理命令:"
if [[ "$DEPLOY_METHOD" == "1" ]]; then
    echo "  启动: cd $INSTALL_DIR && sudo docker-compose up -d"
    echo "  停止: cd $INSTALL_DIR && sudo docker-compose down"
    echo "  日志: cd $INSTALL_DIR && sudo docker-compose logs -f"
else
    echo "  启动: sudo systemctl start frp-panel"
    echo "  停止: sudo systemctl stop frp-panel"
    echo "  重启: sudo systemctl restart frp-panel"
    echo "  状态: sudo systemctl status frp-panel"
    echo "  日志: sudo journalctl -u frp-panel -f"
fi
echo ""
print_warning "提示: 第一个注册的用户将成为管理员"
