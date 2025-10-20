#!/bin/bash
cd /home/container

# Print startup information
echo "┌──────────────────────────────────────────┐"
echo "│                                          │"
echo "│       N8N Pterodactyl by Eletriom        │"
echo "│                                          │"
echo "└──────────────────────────────────────────┘"
echo "N8N Version: ${N8N_VERSION}"

# Default data directory
export N8N_USER_FOLDER="/home/container/.n8n"
mkdir -p "${N8N_USER_FOLDER}"

# Configure IP/Port via Pterodactyl environment
export N8N_HOST=${SERVER_IP}
export N8N_PORT=${SERVER_PORT}

# Set protocol with environment variable support
if [ -n "${N8N_PROTOCOL}" ]; then
    echo "Using defined protocol: ${N8N_PROTOCOL}"
else
    export N8N_PROTOCOL="http"
    echo "Using default protocol: ${N8N_PROTOCOL}"
fi

# Set secure cookie with environment variable support
if [ -n "${N8N_SECURE_COOKIE}" ]; then
    echo "Using defined secure cookie setting: ${N8N_SECURE_COOKIE}"
else
    export N8N_SECURE_COOKIE="false"
    echo "Using default secure cookie setting: ${N8N_SECURE_COOKIE}"
fi

# Set variables for Webhook URL based on environment
if [ -n "${HOSTNAME}" ] && [ -n "${N8N_PORT}" ]; then
    export N8N_WEBHOOK_URL="${N8N_PROTOCOL}://${HOSTNAME}:${N8N_PORT}/"
    echo "Webhook URL: ${N8N_WEBHOOK_URL}"
else
    echo "Warning: HOSTNAME or N8N_PORT not set. Webhook URL not configured automatically."
fi

# Set VUE_APP_URL_BASE_API for frontend
if [ -n "${VUE_APP_URL_BASE_API}" ]; then
    export VUE_APP_URL_BASE_API="${VUE_APP_URL_BASE_API}"
    echo "VUE_APP_URL_BASE_API: ${VUE_APP_URL_BASE_API}"
fi

# Set WEBHOOK_URL and automatically configure proxy hops
if [ -n "${WEBHOOK_URL}" ]; then
    export WEBHOOK_URL="${WEBHOOK_URL}"
    export N8N_PROXY_HOPS=1
    echo "Webhook URL: ${WEBHOOK_URL}"
    echo "Auto-configured N8N_PROXY_HOPS: ${N8N_PROXY_HOPS}"
fi

# Timezone configuration
if [ -n "${TZ}" ]; then
    export GENERIC_TIMEZONE=${TZ}
    echo "Timezone set to: ${GENERIC_TIMEZONE}"
fi

# Use SQLite if configured
if [ "${N8N_DB_TYPE}" = "sqlite" ]; then
    export N8N_DB_TYPE=sqlite
    export N8N_DB_SQLITE_PATH="${N8N_USER_FOLDER}/database.sqlite"
    echo "Using SQLite: ${N8N_DB_SQLITE_PATH}"
fi

# Check if we should use a custom port
if [ -n "${N8N_PORT}" ]; then
    echo "Custom port: ${N8N_PORT}"
fi

# Configuration for file permissions
if [ -n "${N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS}" ]; then
    echo "File permissions configuration: ${N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS}"
else
    export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS="true"
    echo "Applying secure permissions for configuration files: ${N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS}"
fi

# Configuration to enable task runners
if [ -n "${N8N_RUNNERS_ENABLED}" ]; then
    echo "Task runners configuration: ${N8N_RUNNERS_ENABLED}"
else
    export N8N_RUNNERS_ENABLED="true"
    echo "Enabling task runners: ${N8N_RUNNERS_ENABLED}"
fi

# Run n8n
if [ -z "$@" ] || [ "$1" = "bash" ] || [ "$1" = "/entrypoint.sh" ]; then
    echo "Starting n8n..."
    exec n8n start
else
    # If specific arguments were passed, execute them
    echo "Executing custom command: $@"
    exec $@
fi