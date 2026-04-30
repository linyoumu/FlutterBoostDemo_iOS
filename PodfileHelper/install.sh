#!/bin/bash

# ==============================================================================
# iOS Simulator Architecture Config Helper - 安装脚本
# ==============================================================================
# 用途: 自动将 PodfileHelper 安装到目标 iOS 项目
# 用法: ./install.sh /path/to/your/ios/project
# ==============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 图标
CHECKMARK="${GREEN}✅${NC}"
CROSS="${RED}❌${NC}"
INFO="${BLUE}ℹ️${NC}"
WARNING="${YELLOW}⚠️${NC}"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  iOS Simulator Architecture Config Helper - 安装器       ║"
echo "║  Version: 1.0.0                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 检查参数
if [ $# -eq 0 ]; then
    echo -e "${INFO} 用法: ./install.sh /path/to/your/ios/project"
    echo ""
    echo "示例:"
    echo "  ./install.sh ~/Projects/MyApp/ios"
    echo "  ./install.sh ../MyiOSApp"
    echo ""
    exit 1
fi

TARGET_DIR="$1"

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${CROSS} 错误: 目标目录不存在: $TARGET_DIR"
    exit 1
fi

# 检查是否有 Podfile
if [ ! -f "$TARGET_DIR/Podfile" ]; then
    echo -e "${WARNING} 警告: 目标目录没有 Podfile，这是一个 iOS CocoaPods 项目吗?"
    read -p "是否继续? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${INFO} 安装已取消"
        exit 1
    fi
fi

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_FILE="$SCRIPT_DIR/simulator_arch_config.rb"

# 检查源文件是否存在
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${CROSS} 错误: 找不到 simulator_arch_config.rb"
    exit 1
fi

# 目标文件路径
TARGET_HELPER_DIR="$TARGET_DIR/PodfileHelper"
TARGET_FILE="$TARGET_HELPER_DIR/simulator_arch_config.rb"

echo -e "${INFO} 安装配置..."
echo "  源目录: $SCRIPT_DIR"
echo "  目标目录: $TARGET_DIR"
echo ""

# 创建目标目录
if [ -d "$TARGET_HELPER_DIR" ]; then
    echo -e "${WARNING} PodfileHelper 目录已存在"
    read -p "是否覆盖? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${INFO} 安装已取消"
        exit 1
    fi
    rm -rf "$TARGET_HELPER_DIR"
fi

mkdir -p "$TARGET_HELPER_DIR"

# 复制文件
echo -e "${INFO} 复制文件..."
cp "$SCRIPT_DIR/simulator_arch_config.rb" "$TARGET_HELPER_DIR/"
echo -e "  ${CHECKMARK} simulator_arch_config.rb"

cp "$SCRIPT_DIR/README.md" "$TARGET_HELPER_DIR/" 2>/dev/null && echo -e "  ${CHECKMARK} README.md" || true
cp "$SCRIPT_DIR/QUICK_START.md" "$TARGET_HELPER_DIR/" 2>/dev/null && echo -e "  ${CHECKMARK} QUICK_START.md" || true
cp "$SCRIPT_DIR/Podfile.example" "$TARGET_HELPER_DIR/" 2>/dev/null && echo -e "  ${CHECKMARK} Podfile.example" || true
cp "$SCRIPT_DIR/LICENSE" "$TARGET_HELPER_DIR/" 2>/dev/null && echo -e "  ${CHECKMARK} LICENSE" || true
cp "$SCRIPT_DIR/VERSION.md" "$TARGET_HELPER_DIR/" 2>/dev/null && echo -e "  ${CHECKMARK} VERSION.md" || true

echo ""
echo -e "${CHECKMARK} 文件复制完成！"
echo ""

# 检查 Podfile 是否已经包含配置
if [ -f "$TARGET_DIR/Podfile" ]; then
    if grep -q "simulator_arch_config.rb" "$TARGET_DIR/Podfile"; then
        echo -e "${INFO} Podfile 中已包含 SimulatorArchConfig 配置"
    else
        echo -e "${WARNING} 需要手动修改 Podfile"
        echo ""
        echo "请在 Podfile 中添加以下内容:"
        echo ""
        echo -e "${BLUE}# 在文件开头添加:${NC}"
        echo "load 'PodfileHelper/simulator_arch_config.rb'"
        echo ""
        echo -e "${BLUE}# 在 post_install 块中添加:${NC}"
        echo "post_install do |installer|"
        echo "  SimulatorArchConfig.apply(installer)"
        echo "end"
        echo ""
    fi
fi

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  ${GREEN}安装成功！${NC}                                              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo -e "${INFO} 下一步:"
echo "  1. 查看快速开始指南: ${BLUE}cat $TARGET_HELPER_DIR/QUICK_START.md${NC}"
echo "  2. 修改你的 Podfile（如果尚未修改）"
echo "  3. 运行: ${BLUE}cd $TARGET_DIR && pod install${NC}"
echo ""
echo -e "${INFO} 文档位置:"
echo "  - 快速开始: $TARGET_HELPER_DIR/QUICK_START.md"
echo "  - 完整文档: $TARGET_HELPER_DIR/README.md"
echo "  - 使用示例: $TARGET_HELPER_DIR/Podfile.example"
echo ""
echo -e "🎉 ${GREEN}Happy Coding!${NC}"
echo ""
