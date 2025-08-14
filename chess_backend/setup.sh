#!/bin/bash

# Chess Backend Project Setup Script
# Description: Automated setup for chess backend application
# Author: Ayush Jadaun
# Repository: https://github.com/ayush-jadaun/chessBackEnd

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="chessBackEnd"
REPO_URL="https://github.com/ayush-jadaun/chessBackEnd"
NODE_VERSION="18"

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup function
main() {
    print_info "Starting Chess Backend Project Setup..."
    echo "=================================="
    
    # Check prerequisites
    print_info "Checking prerequisites..."
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    if ! command_exists node; then
        print_error "Node.js is not installed. Please install Node.js v${NODE_VERSION} or higher."
        exit 1
    fi
    
    if ! command_exists npm; then
        print_error "npm is not installed. Please install npm."
        exit 1
    fi
    
    # Check Node.js version
    NODE_CURRENT=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_CURRENT" -lt "$NODE_VERSION" ]; then
        print_warning "Node.js version $NODE_CURRENT detected. Recommended: v${NODE_VERSION}+"
    fi
    
    print_success "All prerequisites met!"
    
    # Clone repository
    print_info "Cloning repository..."
    if [ -d "$PROJECT_NAME" ]; then
        print_warning "Directory $PROJECT_NAME already exists. Removing..."
        rm -rf "$PROJECT_NAME"
    fi
    
    if git clone "$REPO_URL"; then
        print_success "Repository cloned successfully!"
    else
        print_error "Failed to clone repository. Check your internet connection and repository URL."
        exit 1
    fi
    
    # Navigate to project directory
    cd "$PROJECT_NAME" || {
        print_error "Failed to navigate to project directory."
        exit 1
    }
    
    # Install dependencies
    print_info "Installing dependencies..."
    if npm install; then
        print_success "Dependencies installed successfully!"
    else
        print_error "Failed to install dependencies."
        exit 1
    fi
    
    # Check available scripts and start application
    print_info "Checking available scripts..."
    
    # Check if package.json exists and has scripts
    if [ -f "package.json" ]; then
        # Extract scripts from package.json
        SCRIPTS=$(node -pe "try { Object.keys(require('./package.json').scripts || {}).join(' ') } catch(e) { '' }")
        
        if echo "$SCRIPTS" | grep -q "start"; then
            print_success "Setup completed successfully!"
            print_info "Starting Chess Backend Server..."
            echo "=================================="
            npm run start
        elif echo "$SCRIPTS" | grep -q "dev"; then
            print_success "Setup completed successfully!"
            print_info "Starting Chess Backend Server in development mode..."
            echo "=================================="
            npm run dev
        else
            print_success "Setup completed successfully!"
            print_warning "No 'start' or 'dev' script found."
            if [ -n "$SCRIPTS" ]; then
                print_info "Available scripts: $SCRIPTS"
                print_info "Please run 'npm run <script-name>' to start the application."
            else
                print_info "No scripts found in package.json"
            fi
        fi
    else
        print_error "package.json not found in project directory"
        exit 1
    fi
}

# Cleanup function for interruption
cleanup() {
    print_warning "Setup interrupted. Cleaning up..."
    exit 1
}

# Trap interruption signals
trap cleanup INT TERM

# Run main function
main "$@"
