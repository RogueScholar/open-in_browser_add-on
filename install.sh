#!/usr/bin/env bash
set -e

typeset APP_DIR="$(dirname "${BASH_SOURCE[0]}")/app"
typeset -g SYSNODE_BIN="$(command -v node 2>/dev/null)"

archTest() {
  typeset ARCH_TYPE="$(uname -m)"
  case ${ARCH_TYPE} in
    x86_64)
      typeset -g INSTALL_NODE="./node/x64/node"
      ;;
    i386 | i686)
      typeset -g INSTALL_NODE="./node/x86/node"
      ;;
    *)
      if [[ -z ${SYSNODE_BIN} ]]; then
        echo "Your system doesn't have a working NodeJS."
        echo "Please install it from https://nodejs.org/download/ and retry."
        exit 1
      fi
      ;;
  esac
}

nodeSelect() {
  typeset -ga INSTALL_ARGS
  if [[ -n ${SYSNODE_BIN} ]]; then
    typeset SYSNODE_VER="$(node -e \
      "console.log(process.version.substr(1).split('.')[0])" 2>/dev/null)"
    if [[ ${SYSNODE_VER} -ge 6 ]]; then
      echo -e "You have NodeJS v${SYSNODE_VER} installed. We'll use that!\\n"
      typeset -g INSTALL_NODE="${SYSNODE_BIN}"
      INSTALL_ARGS=("${SYSNODE_BIN}")
    elif [[ -n ${INSTALL_NODE} ]]; then
      echo -e "Your NodeJS is old, but don't worry, we brought our own! :)\\n"
      INSTALL_ARGS=(--add_node)
    fi
  elif [[ -n ${INSTALL_NODE} ]]; then
    echo -e "You don't have NodeJS but don't worry, we brought our own! :)\\n"
    INSTALL_ARGS=(--add_node)
  else
    echo "Your system doesn't have a working NodeJS."
    echo "Please install it from https://nodejs.org/download/ and try again."
    exit 1
  fi
}

archTest && nodeSelect
echo "Proceeding with installation..."
INSTALL_ARGS+=("${@}")

"${INSTALL_NODE}" "${APP_DIR}/install.js" "${INSTALL_ARGS[@]}"

echo "Installation complete. Enjoy!"
