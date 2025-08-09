#!/bin/sh

echo "🚀 Guiwoo Config - Package Installation Script\nFor Mac"

#Hombrew Install
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew가 설치되어 있지 않습니다. 설치를 진행합니다..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "✅ Homebrew 설치 완료!"
fi

# 설치할 패키지 목록
PACKAGES=(
zsh
devel
tmux
vim
tree-sitter
readline
zstd
bat
fzf-tab
graphviz
yazi
zoxide
fzf
ripgrep
ghostty
)

CASKS=(
rectangle
)

# 패키지 설치 함수
install_package() {
    if brew list "$1" &>/dev/null; then
        echo "✅ $1 이미 설치됨"
    else
        echo "📦 $1 설치 중..."
        brew install "$1"
    fi
}

# Cask 설치 함수 (GUI 애플리케이션)
install_cask() {
    if brew list --cask "$1" &>/dev/null; then
        echo "✅ $1 이미 설치됨"
    else
        echo "🖥️ $1 (GUI 앱) 설치 중..."
        brew install --cask "$1"
    fi
}

# 패키지 설치 루프
echo "📦 패키지 설치 시작..."
for package in "${PACKAGES[@]}"; do
    install_package "$package"
done

# Cask(GUI 앱) 설치 루프
echo "🖥️ GUI 애플리케이션 설치 시작..."
for cask in "${CASKS[@]}"; do
    install_cask "$cask"
done

# Homebrew 정리
echo "🧹 불필요한 패키지 정리..."
brew cleanup
echo "🎉 모든 패키지 설치 완료!"

# Config 복사
CONFIG_PATH="$HOME/.config"
if [ -d "$CONFIG_PATH" ]; then
    echo "✅ CONFIG 설정  시작!"
else
    echo "✅ CONFIG FILE  설종 오류!"
fi

echo "🎉 ZSH 설정!"
ZSHRC_PATH="$HOME/.zshrc"
CUSTOM_ZSHRC_BLOCK="
# Import custom zshrc
ZSH_CUSTOM_DIR=\"\$CONFIG_PATH/zsh\"

if [ -d \"\$ZSH_CUSTOM_DIR\" ]; then
    for config in \"\$ZSH_CUSTOM_DIR\"/zshrc.*; do
        if [ -f \"\$config\" ]; then
            source \"\$config\"
            echo \"🚀 Loaded: \$config\"
        fi
    done
fi


# ~/.zshrc에 추가 (중복 방지)
if ! grep -q "ZSH_CUSTOM_DIR" "$ZSHRC_PATH"; then
    echo "\n$CUSTOM_ZSHRC_BLOCK" >> "$ZSHRC_PATH"
    echo "✅ Custom Zsh 설정이 ~/.zshrc에 추가되었습니다."
else
    echo "⚡ Custom Zsh 설정이 이미 ~/.zshrc에 존재합니다."
fi
"

# ~/.zshrc에 추가 (중복 방지)
if ! grep -q "ZSH_CUSTOM_DIR" "$ZSHRC_PATH"; then
    echo "\n$CUSTOM_ZSHRC_BLOCK" >> "$ZSHRC_PATH"
    echo "✅ Custom Zsh 설정이 ~/.zshrc에 추가되었습니다."
else
    echo "⚡ Custom Zsh 설정이 이미 ~/.zshrc에 존재합니다."
fi

#Vim
VIM_PATH="$CONFIG_PATH/vim/.vimrc"
TARGET_PATH="$HOME/.vimrc"
echo "🎉 VIM 설정!"
if [ -f "$VIM_PATH" ]; then
    cp -rp "$VIM_PATH" "$TARGET_PATH"
    echo "✅ Custom Vim 설정이 ~/.vimrc에 추가되었습니다."
else
   echo "⚠️ VIM 설정 파일이 존재하지 않습니다: $VIM_PATH"
fi

#Git
GIT_PATH="$CONFIG_PATH/git/.gitconfig"
echo "🎉 GitConfig 설정!"
if [ -f "$GIT_PATH" ]; then
    cp -rp "$GIT_PATH" "$HOME/.gitconfig"
    echo "✅ Custom GIT 설정이 ~/.gitconfig에 추가되었습니다."
else
   echo "⚠️ GIT 설정 파일이 존재하지 않습니다: $GIT_PATH"
fi

#TMUX
echo "🎉 TMUX 설정!"
TMUX_PATH="$CONFIG_PATH/tmux/tmux.config"
if [ -f "$TMUX_PATH" ]; then
    tmux source-file "$TMUX_PATH"
    echo "✅ Custom Tmux 설정이 ~/tmux.config에 추가되었습니다."
else
   echo "⚠️ GIT 설정 파일이 존재하지 않습니다: $GIT_PATH"
fi

#FONTS
echo "🎉 FONT 설정!"
FONTS=(
3270
CascadiaCode
NerdFontsSymbolsOnly
)

FONT_SOURCE_DIR="$CONFIG_PATH/fonts"
FONT_DEST_DIR="$HOME/Library/Fonts"

# 폰트 설치 (파일 복사)
for font in "${FONTS[@]}"; do
    FONT_ZIP="${FONT_SOURCE_DIR}/${font}.zip"
    if [ -f "$FONT_ZIP" ]; then
        unzip -o "$FONT_ZIP" -d "$FONT_DEST_IDR" > /dev/null 2>&1
        echo "✅ $font 설치 완료!"
    else
        echo "⚠️ 폰트 파일이 존재하지 않습니다: $FONT_ZIP"
    fi
done
echo "🎉 모든 폰트 설치 완료!"

echo "✅ ALL DONE  HAPPY CODING"
