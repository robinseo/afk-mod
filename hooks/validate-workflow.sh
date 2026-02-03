#!/bin/bash

# AFK Workflow Validation Hook
# This script validates that the current workflow stage allows the requested operation

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Project root
PROJECT_ROOT="${CLAUDE_PLUGIN_ROOT}/../.."
AFK_DIR="${PROJECT_ROOT}/.afk-mod"
STATE_FILE="${AFK_DIR}/state.json"

# Check if .afk-mod exists
if [ ! -d "$AFK_DIR" ]; then
    echo -e "${YELLOW}⚠ AFK project not initialized. Run /afk:init first.${NC}"
    exit 0
fi

# Check if state.json exists
if [ ! -f "$STATE_FILE" ]; then
    echo -e "${YELLOW}⚠ State file not found. Run /afk:init first.${NC}"
    exit 0
fi

# Read current workflow stage
WORKFLOW=$(jq -r '.workflow // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unknown")
CURRENT_STAGE=$(jq -r '.currentStage // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unknown")

# Validate workflow stage
case "$WORKFLOW" in
    "initialized")
        # Check if feature-list.csv exists
        if [ ! -f "$AFK_DIR/feature-list.csv" ]; then
            echo -e "${YELLOW}⚠ Workflow stage: initialized${NC}"
            echo -e "${YELLOW}→ Please copy feature-list.csv to .afk-mod/ directory${NC}"
            echo -e "${YELLOW}→ Then run: /afk:feature-decompose${NC}"
            exit 0
        fi
        ;;

    "feature_decompose_in_progress")
        echo -e "${GREEN}✓ Feature decomposition in progress${NC}"
        echo -e "${GREEN}→ Current stage: ${CURRENT_STAGE}${NC}"
        exit 0
        ;;

    "ready_to_develop")
        echo -e "${GREEN}✓ Ready to develop!${NC}"
        echo -e "${GREEN}→ Run: /afk:start <task-id> to begin development${NC}"
        exit 0
        ;;

    "task_in_progress")
        CURRENT_TASK=$(jq -r '.currentTask // "none"' "$STATE_FILE")
        echo -e "${GREEN}✓ Task in progress: ${CURRENT_TASK}${NC}"
        exit 0
        ;;

    "all_tasks_completed")
        echo -e "${GREEN}✓ All tasks completed!${NC}"
        exit 0
        ;;

    *)
        echo -e "${YELLOW}⚠ Unknown workflow stage: ${WORKFLOW}${NC}"
        exit 0
        ;;
esac

exit 0
