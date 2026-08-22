# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

PREFIX ?= /usr/local
_PROJECT=cert-tools
_PROJECT_NPM=$(_PROJECT)
_NAMESPACE=themartiancompany
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
USR_DIR=$(DESTDIR)$(PREFIX)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
LIB_DIR=$(DESTDIR)$(PREFIX)/lib/$(_PROJECT)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
NODE_DIR=$(PREFIX)/lib/node_modules/$(_PROJECT)
BUILD_NPM_DIR=build

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_EXE=\
  install \
    -vDm755
_INSTALL_DIR=\
  install \
    -vdm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)
NPM_FILES=\
  "README.md" \
  "COPYING" \
  "AUTHORS.rst" \
  "cert-gen" \
  "dist" \
  "eslint.config.mjs" \
  "fs-worker.webpack.config.cjs" \
  "libcert-gen" \
  "libcert-gen.webpack.config.cjs" \
  "package.json" \
  "webpack.config.cjs"

all: build-man build-npm

build:

	if [[ "$(_NPM)" == "false" ]]; then \
	  make \
	    build-webpack; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    build-npm; \
	else \
	  echo \
	   "Invalid value for '$(_NPM)'." \
	   1>&2; \
	   exit \
	     1; \
	fi
	make \
	  build-man

build-webpack:

	$(INSTALL_DIR) \
	  "build/dist/crash-js"
	cp \
	  -r \
	  "$(_PROJECT)" \
	  "webpack.config.cjs" \
	  "build"
	_webpack=( \
	  "$$(command \
	        -v \
	        "webpack")"; \
	if [[ "${_webpack}" == "" ]]; then \
	  _webpack=(
	    npx
	      webpack); \
	fi; \
	cd \
	  "build"; \
        "${_webpack[@]}" \
	  --mode \
	    'production' \
	  --config \
	  'fs-worker.webpack.config.cjs' \
	  --stats-error-details; \
	mv \
	  'fs-worker.js' \
	  'dist/crash-js/fs-worker.js'; \
        "${_webpack[@]}" \
	  --mode \
	    'production' \
	  --config \
	    'webpack.config.cjs' \
	  --stats-error-details; \
	mv \
	  "$(_PROJECT).js" \
	  "dist/$(_PROJECT)"



check: eslint

eslint:

	npm \
	  install \
	  --save-dev; \
	npx \
	  eslint \
	    "."

install: install-scripts install-doc install-examples install-man

install-scripts:

install-scripts:

	if [[ "$(_NPM)" == "false" ]]; then \
	  if [[ ! -s "$(BIN_DIR)/$(_PROJECT)" ]]; then \
	    $(_MAKE_EXE) \
	      "$(LIB_DIR)/nodejs/cert-gen"; \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/cert-gen" \
	      "$(BIN_DIR)/cert-gen"; \
	  fi; \
	  $(_INSTALL_DIR) \
	    "$(LIB_DIR)/nodejs"; \
	  rm \
	    "$(LIB_DIR)/node_modules" || \
	    true; \
	  if [[ ! -s "$(LIB_DIR)/node_modules" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/node_modules" \
	      "$(LIB_DIR)/nodejs/node_modules"; \
	  fi; \
	  rm \
	    -rf \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)"; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)"; \
	  fi; \
	  $(_MAKE_LINK) \
	    "$(PREFIX)/lib/$(_PROJECT)/nodejs" \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" || \
	    true; \
	  cp \
	    -r \
	    $$(printf \
	         "$${PWD}/%s " \
	         $$(cat \
	              "$${PWD}/package.json" | \
	              jq \
	                --raw-output \
	                '.files[]')) \
	    "$(LIB_DIR)/nodejs"; \
	  $(_MAKE_EXE) \
	    "$(LIB_DIR)/nodejs/$(_PROJECT)"; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    install-npm; \
	  $(_MAKE_LINK) \
	    "$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
	    "$(LIB_DIR)/nodejs" || \
	  true; \
	fi

	$(_INSTALL_EXE) \
	  "cert-gen" \
	  "$(LIB_DIR)/cert-gen"
	$(_INSTALL_EXE) \
	  "lib$(_PROJECT)" \
	  "$(LIB_DIR)/lib$(_PROJECT)"
	ln \
	  -s \
	  "$(PREFIX)/lib/$(_PROJECT)/$(_PROJECT)" \
	  "$(BIN_DIR)/$(_PROJECT)"

build-man:

	mkdir \
	  -p \
	  "build/man"
	rst2man \
	  "man/cert-gen.1.rst" \
	  "build/man/cert-gen.1"

build-npm:

	make \
	  build-man
	cp \
	  -r \
	  $(NPM_FILES) \
	  "build"; \
	cd \
	  "build"; \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install; \
	npm \
	  run \
	    "build"; \
	npm \
	  pack; \
	mv \
	  "$(_PROJECT)-$${_version}.tgz" \
	  ".."

install-npm:

	_npm_opts=( \
	  -g \
	  --prefix \
	    "$(USR_DIR)" \
	); \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install \
	    "$${_npm_opts[@]}" \
	    "$(_PROJECT)-$${_version}.tgz"; \
	$(_INSTALL_DIR) \
	  "$(DESTDIR)$(PREFIX)/lib"; \
	ln \
	  -s \
	  "$(NODE_DIR)" \
	  "$(LIB_DIR)" || \
	true

publish-npm:

	cd \
	  "build"; \
	npm \
	  publish \
	  --access \
	    "public"

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	rst2man \
	  "man/$(_PROJECT).1.rst" \
	  "$(MAN_DIR)/man1/$(_PROJECT).1"

.PHONY: check build-man build-npm install install-doc install-man install-npm install-scripts shellcheck
