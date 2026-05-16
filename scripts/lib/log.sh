#!/usr/bin/env bash

# Small logging helpers shared by installer stages.

log_info() {
  printf '\033[1;34m[info]\033[0m %s\n' "$*" >&2
}

log_ok() {
  printf '\033[1;32m[ ok ]\033[0m %s\n' "$*" >&2
}

log_warn() {
  printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2
}

log_error() {
  printf '\033[1;31m[err ]\033[0m %s\n' "$*" >&2
}

die() {
  log_error "$*"
  exit 1
}
