#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 显示欢迎信息
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║        FRP Panel 一键安装脚本                         ║
║        蓝白毛玻璃主题版                               ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# 检查操作系统
print_info "检测操作系统..."
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi

print_success "操作系统: $OS, 架构: $ARCH"

# 选择部署方式
echo ""
print_info "请选择部署方式:"
echo "  1) Docker 部署 (推荐，需要 Docker)"
echo "  2) 源码编译部署 (需要 Node.js 和 Go)"
echo "  3) 仅构建前端 (已有后端二进制文件)"
read -p "请输入选项 [1-3]: " DEPLOY_METHOD

case $DEPLOY_METHOD in
    1)
        print_info "选择: Docker 部署"
        DEPLOY_TYPE="docker"
        ;;
    2)
        print_info "选择: 源码编译部署"
        DEPLOY_TYPE="source"
        ;;
    3)
        print_info "选择: 仅构建前端"
        DEPLOY_TYPE="frontend"
        ;;
    *)
        print_error "无效选项"
        exit 1
        ;;
esac

echo ""

# Docker 部署
if [[ "$DEPLOY_TYPE" == "docker" ]]; then
    # 检查 Docker
    if ! command_exists docker; then
        print_error "未检测到 Docker，请先安装 Docker"
        print_info "安装指南: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # 检查 pnpm
    if ! command_exists pnpm; then
        print_warning "未检测到 pnpm，正在安装..."
        npm install -g pnpm
    fi
    
    print_info "步骤 1/4: 构建前端..."
    cd www
    pnpm install --no-frozen-lockfile
    pnpm build
    cd ..
    print_success "前端构建完成"
    
    print_info "步骤 2/4: 构建后端..."
    ./build.sh --platform linux --arch $ARCH --bintype full --skip-frontend
    print_success "后端构建完成"
    
    print_info "步骤 3/4: 构建 Docker 镜像..."
    docker build -t my-frp-panel:latest --build-arg ARCH=linux-$ARCH .
    print_success "Docker 镜像构建完成"
    
    print_info "步骤 4/4: 启动容器..."
    
    # 询问是否开放注册
    read -p "是否开放用户注册? [y/N]: " ENABLE_REGISTER
    if [[ "$ENABLE_REGISTER" =~ ^[Yy]$ ]]; then
        REGISTER_FLAG="true"
    else
        REGISTER_FLAG="false"
    fi
    
    # 询问端口
    read -p "Web 端口 (默认 9000): " WEB_PORT
    WEB_PORT=${WEB_PORT:-9000}
    
    # 创建数据目录
    mkdir -p ./data
    
    # 停止旧容器
    docker stop frp-panel 2>/dev/null || true
    docker rm frp-panel 2>/dev/null || true
    
    # 启动新容器
    docker run -d \
        --name frp-panel \
        --restart unless-stopped \
        --network host \
        -e APP_ENABLE_REGISTER=$REGISTER_FLAG \
        -e APP_PORT=$WEB_PORT \
        -v $(pwd)/data:/data \
        my-frp-panel:latest
    
    print_success "容器启动成功！"
    echo ""
    print_success "=========================================="
    print_success "部署完成！"
    print_success "访问地址: http://localhost:$WEB_PORT"
    print_success "数据目录: $(pwd)/data"
    print_success "=========================================="
    echo ""
    print_info "提示: 第一个注册的用户将成为管理员"
    
# 源码编译部署
elif [[ "$DEPLOY_TYPE" == "source" ]]; then
    # 检查 Node.js
    if ! command_exists node; then
        print_error "未检测到 Node.js，请先安装 Node.js 18+"
        exit 1
    fi
    
    # 检查 pnpm
    if ! command_exists pnpm; then
        print_warning "未检测到 pnpm，正在安装..."
        npm install -g pnpm
    fi
    
    # 检查 Go
    if ! command_exists go; then
        print_error "未检测到 Go，请先安装 Go 1.24+"
        exit 1
    fi
    
    print_info "步骤 1/3: 构建前端..."
    cd www
    pnpm install --no-frozen-lockfile
    pnpm build
    cd ..
    print_success "前端构建完成"
    
    print_info "步骤 2/3: 构建后端..."
    ./build.sh --current
    print_success "后端构建完成"
    
    print_info "步骤 3/3: 配置启动..."
    
    # 询问是否开放注册
    read -p "是否开放用户注册? [y/N]: " ENABLE_REGISTER
    if [[ "$ENABLE_REGISTER" =~ ^[Yy]$ ]]; then
        export APP_ENABLE_REGISTER=true
    else
        export APP_ENABLE_REGISTER=false
    fi
    
    # 询问端口
    read -p "Web 端口 (默认 9000): " WEB_PORT
    WEB_PORT=${WEB_PORT:-9000}
    export APP_PORT=$WEB_PORT
    
    # 创建数据目录
    mkdir -p ./data
    
    print_success "=========================================="
    print_success "构建完成！"
    print_success "=========================================="
    echo ""
    print_info "启动命令: ./frp-panel master"
    print_info "访问地址: http://localhost:$WEB_PORT"
    print_info "数据目录: $(pwd)/data"
    echo ""
    
    # 询问是否立即启动
    read -p "是否立即启动服务? [Y/n]: " START_NOW
    if [[ ! "$START_NOW" =~ ^[Nn]$ ]]; then
        print_info "正在启动服务..."
        ./frp-panel master &
        sleep 2
        print_success "服务已在后台启动！"
        print_info "查看日志: tail -f frp-panel.log"
        print_info "停止服务: pkill frp-panel"
    fi
    
# 仅构建前端
elif [[ "$DEPLOY_TYPE" == "frontend" ]]; then
    # 检查 pnpm
    if ! command_exists pnpm; then
        print_warning "未检测到 pnpm，正在安装..."
        npm install -g pnpm
    fi
    
    print_info "构建前端..."
    cd www
    pnpm install --no-frozen-lockfile
    pnpm build
    cd ..
    print_success "前端构建完成！"
    echo ""
    print_info "前端文件位置: www/out/"
    print_info "后端需要将前端文件复制到: cmd/frpp/out/"
    echo ""
    read -p "是否自动复制到后端目录? [Y/n]: " COPY_FILES
    if [[ ! "$COPY_FILES" =~ ^[Nn]$ ]]; then
        rm -rf cmd/frpp/out
        cp -r www/out cmd/frpp/
        print_success "已复制到 cmd/frpp/out/"
    fi
fi

echo ""
print_success "=========================================="
print_success "🎉 安装完成！"
print_success "=========================================="
