#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
SELECTED_PROFILE=""
DETECTED_PROFILE=""
MONITOR_COUNT="0"

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] [--help]

Install this repo's Arch Linux Hyprland dotfiles with safe, idempotent steps.

Options:
  --dry-run   Print mutations without changing packages, services, or files.
  --help      Show this help message.
EOF
}

parse_args() {
  while (($#)); do
    case "$1" in
      --dry-run) DRY_RUN=1 ;;
      --help|-h) usage; exit 0 ;;
      *) die "Unknown argument: $1" ;;
    esac
    shift
  done
}

# shellcheck source=scripts/lib/log.sh
source "$REPO_ROOT/scripts/lib/log.sh"
# shellcheck source=scripts/lib/run.sh
source "$REPO_ROOT/scripts/lib/run.sh"
# shellcheck source=scripts/lib/prompt.sh
source "$REPO_ROOT/scripts/lib/prompt.sh"
# shellcheck source=scripts/lib/detect.sh
source "$REPO_ROOT/scripts/lib/detect.sh"
# shellcheck source=scripts/lib/backup.sh
source "$REPO_ROOT/scripts/lib/backup.sh"
# shellcheck source=scripts/lib/link.sh
source "$REPO_ROOT/scripts/lib/link.sh"
# shellcheck source=scripts/lib/system-file.sh
source "$REPO_ROOT/scripts/lib/system-file.sh"
# shellcheck source=scripts/lib/pacman.sh
source "$REPO_ROOT/scripts/lib/pacman.sh"
# shellcheck source=scripts/lib/systemd.sh
source "$REPO_ROOT/scripts/lib/systemd.sh"

# shellcheck source=scripts/stages/00-preflight.sh
source "$REPO_ROOT/scripts/stages/00-preflight.sh"
# shellcheck source=scripts/stages/10-packages.sh
source "$REPO_ROOT/scripts/stages/10-packages.sh"
# shellcheck source=scripts/stages/20-user-configs.sh
source "$REPO_ROOT/scripts/stages/20-user-configs.sh"
# shellcheck source=scripts/stages/25-system-configs.sh
source "$REPO_ROOT/scripts/stages/25-system-configs.sh"
# shellcheck source=scripts/stages/30-services.sh
source "$REPO_ROOT/scripts/stages/30-services.sh"
# shellcheck source=scripts/stages/40-verify.sh
source "$REPO_ROOT/scripts/stages/40-verify.sh"

main() {
  parse_args "$@"

  if [[ "$DRY_RUN" == "1" ]]; then
    log_warn "Dry-run mode: no mutations will be performed."
  fi

  stage_preflight
  stage_packages
  stage_user_configs
  stage_system_configs
  stage_services
  stage_verify

  log_ok "Installer finished for profile: $SELECTED_PROFILE"
}

main "$@"
