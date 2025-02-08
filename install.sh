#!/bin/sh

echo "🚀 Guiwoo Develconfig - Package Installation Script"

# ✅ Homebrew 설치 확인
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew가 설치되어 있지 않습니다. 설치를 진행합니다..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ Homebrew 설치 완료!"
else
    echo "✅ Homebrew가 이미 설치되어 있습니다."
fi

# ✅ 설치할 패키지 목록

PACKAGES=(
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
)

CASKS=(
rectangle  # macOS 전용 GUI 앱
)

# ✅ 패키지 설치 함수
install_package() {
    if brew list "$1" &>/dev/null; then
        echo "✅ $1 이미 설치됨"
    else
        echo "📦 $1 설치 중..."
        brew install "$1"
    fi
}

                                                                                                     # ✅ Cask 앱 설치 함수 (GUI 프로그램)
                                                                                                     install_cask() {
                                                                                                         if brew list --cask "$1" &>/dev/null; then
                                                                                                             echo "✅ $1 이미 설치됨" else
                                                                                                             echo "🖥️ $1 (GUI 앱) 설치 중..."
                                                                                                             brew install --cask "$1"
                                                                                                         fi
                                                                                                     }

                                                                                                    # ✅ 패키지 설치 실행
                                                                                                    echo "📦 패키지 설치 시작..."
                                                                                                    for package in "${PACKAGES[@]}"; do
                                                                                                        install_package "$package"
                                                                                                    done

                                                                                                    # ✅ GUI 애플리케이션 (Cask) 설치 실행
                                                                                                    echo "🖥️ GUI 애플리케이션 설치 시작..."
                                                                                                    for cask in "${CASKS[@]}"; do
                                                                                                        install_cask "$cask"
                                                                                                    done
                                                                                                    # ✅ Homebrew 정리
                                                                                                    echo "🧹 불필요한 패키지 정리..."
                                                                                                    brew cleanup
                                                                                                    echo "🎉 모든 패키지 설치 완료!"
