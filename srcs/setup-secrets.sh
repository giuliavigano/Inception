#!/bin/bash

SECRETS_DIR="./secrets"
mkdir -p $SECRETS_DIR

if [ ! -f "$SECRETS_DIR/db_root_password.txt" ]; then
	openssl rand -base64 32 > "$SECRETS_DIR/db_root_password.txt"
fi

if [ ! -f "$SECRETS_DIR/db_wordpress_password.txt" ]; then
	openssl rand -base64 32 > "$SECRETS_DIR/db_wordpress_password.txt"
fi

if [ ! -f "$SECRETS_DIR/wp_admin_password.txt" ]; then
	openssl rand -base64 32 > "$SECRETS_DIR/wp_admin_password.txt"
fi

if [ ! -f "$SECRETS_DIR/wp_user2_password.txt" ]; then
	openssl rand -base64 32 > "$SECRETS_DIR/wp_user2_password.txt"
fi

chmod 600 "$SECRETS_DIR"/*