## macOS Setup

새 맥 세팅 자동화 및 현재 환경 백업 레포지토리.

### 구조

```
.
├── dotfiles/               # 홈 디렉토리 설정 파일
│   ├── .zshrc              # zsh 설정 (Oh My Zsh, 플러그인, alias)
│   ├── .zprofile           # Homebrew PATH 등 로그인 설정
│   ├── .p10k.zsh           # Powerlevel10k 프롬프트 테마
│   └── .gitconfig          # git 사용자 설정
│
├── config/
│   ├── git/ignore          # 글로벌 gitignore
│   ├── karabiner/          # Karabiner-Elements 키 리매핑
│   ├── iterm2/             # iTerm2 설정 (XML plist)
│   ├── gh/                 # GitHub CLI 설정 및 alias
│   ├── claude/             # Claude Code 설정 (model, theme 등)
│   └── antigravity/        # Antigravity IDE 익스텐션 목록
│
├── vscode/
│   ├── settings.json       # VSCode 설정
│   └── extensions.txt      # 설치된 익스텐션 목록
│
├── Brewfile                # Homebrew 패키지 목록
├── install.sh              # 새 맥 세팅 자동화 스크립트
├── backup.sh               # 현재 설정 → 레포 백업 스크립트
├── macos.sh                # macOS 시스템 설정 적용 스크립트
└── userkeymapping.md       # 키 리매핑 설명 문서
```

### 새 맥 세팅

```bash
git clone https://github.com/DaeHwanZZang/personal_MacOS_Setup.git
cd personal_MacOS_Setup
./install.sh
```

순서대로 자동 처리됩니다:

1. Homebrew 설치
2. `Brewfile` 기반으로 패키지 전체 설치 (bat, git, gh, fastfetch, powerlevel10k, iTerm2 등)
3. Oh My Zsh 설치
4. dotfiles 심볼릭 링크 연결 (`~/.zshrc`, `~/.p10k.zsh` 등)
5. config 파일 심볼릭 링크 연결 (karabiner, git, gh)
6. VSCode 설정 연결
7. Claude Code 설정 복원
8. Antigravity 익스텐션 설치
9. iTerm2 설정 복원
10. macOS Dock 설정 적용

> 기존 dotfile이 있으면 `.bak`으로 백업 후 덮어씁니다.

### 설정 백업

설정을 변경한 뒤 레포에 반영할 때:

```bash
./backup.sh
git diff          # 변경 내용 확인
git add -A && git commit -m "update configs"
git push
```

### 설치된 주요 도구

| 도구 | 설명 |
|------|------|
| [Homebrew](https://brew.sh) | 맥 패키지 매니저 |
| [Oh My Zsh](https://ohmyz.sh) | zsh 프레임워크 |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | zsh 프롬프트 테마 |
| [bat](https://github.com/sharkdp/bat) | `cat` 대체 (syntax highlighting) |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | 터미널 시스템 정보 표시 |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org) | 키보드 리매핑 |
| [iTerm2](https://iterm2.com) | 터미널 에뮬레이터 |
| [gh](https://cli.github.com) | GitHub CLI |

### 키 리매핑

자세한 내용은 [userkeymapping.md](./userkeymapping.md) 참고.
