#!/bin/bash

# Data Glaciers Repository Consolidation Script
# This script helps consolidate ONLY Data Glaciers internship repositories
# into a single repository while preserving commit history using git subtree

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Function to check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    print_success "Git is installed"
}

# Function to check if we're in the right directory
check_directory() {
    current_dir=$(basename "$PWD")
    if [[ "$current_dir" != "Data Glaciers" ]]; then
        print_warning "You are in directory: $current_dir"
        print_warning "Make sure you're in the 'Data Glaciers' directory"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Aborted. Please navigate to the 'Data Glaciers' directory."
            exit 1
        fi
    fi
}

# Function to initialize the main repository
init_main_repo() {
    print_status "Initializing Data Glaciers main repository..."
    
    if [ -d ".git" ]; then
        print_warning "Git repository already exists. Skipping initialization."
        return
    fi
    
    git init
    git add .
    git commit -m "Initial commit for Data Glaciers consolidated repository"
    print_success "Data Glaciers main repository initialized"
}

# Function to validate repository URL
validate_repo_url() {
    local repo_url=$1
    
    # Check if it's a valid Git URL
    if [[ $repo_url =~ ^(https?://|git@) ]]; then
        # Test if repository is accessible
        if git ls-remote "$repo_url" &> /dev/null; then
            return 0
        else
            print_warning "Cannot access repository: $repo_url"
            return 1
        fi
    else
        print_error "Invalid repository URL format: $repo_url"
        return 1
    fi
}

# Function to add a repository as subtree
add_subtree() {
    local repo_url=$1
    local folder_name=$2
    
    print_status "Adding Data Glaciers $folder_name from $repo_url..."
    
    # Validate the repository URL
    if ! validate_repo_url "$repo_url"; then
        print_error "Skipping $folder_name due to invalid URL"
        return 1
    fi
    
    if [ -d "$folder_name" ]; then
        print_warning "Folder $folder_name already exists. Skipping..."
        return 0
    fi
    

    # Try to add as subtree (without squash to preserve original timestamps)
    if git subtree add --prefix="$folder_name" "$repo_url" main; then
        print_success "Successfully added Data Glaciers $folder_name"
    else
        print_warning "Failed to add $folder_name as subtree. Trying with master branch..."
        if git subtree add --prefix="$folder_name" "$repo_url" master; then
            print_success "Successfully added Data Glaciers $folder_name (master branch)"
        else
            print_error "Failed to add $folder_name. Please check the repository URL and branch name."
            return 1
        fi
    fi
}

# Function to create a sample configuration file
create_config() {
    print_status "Creating Data Glaciers configuration file..."
    
    cat > data_glaciers_repos.txt << EOF
# Data Glaciers Internship Repository Configuration
# Add ONLY your Data Glaciers internship repository URLs here
# Format: REPO_URL FOLDER_NAME
# Example: https://github.com/username/data-glaciers-week1.git week1

# Week 1 Data Glaciers Task
# https://github.com/yourusername/data-glaciers-week1.git week1

# Week 2 Data Glaciers Task
# https://github.com/yourusername/data-glaciers-week2.git week2

# Week 3 Data Glaciers Task
# https://github.com/yourusername/data-glaciers-week3.git week3

# Week 4 Data Glaciers Task
# https://github.com/yourusername/data-glaciers-week4.git week4

# Add more Data Glaciers weeks as needed...
# IMPORTANT: Only include Data Glaciers internship repositories!
EOF
    
    print_success "Configuration file created: data_glaciers_repos.txt"
    print_status "Please edit data_glaciers_repos.txt and add ONLY your Data Glaciers repository URLs"
    print_warning "DO NOT include any other repositories - only Data Glaciers internship work!"
}

# Function to read configuration and process repositories
process_repos_from_config() {
    if [ ! -f "data_glaciers_repos.txt" ]; then
        print_error "Configuration file data_glaciers_repos.txt not found"
        create_config
        return
    fi
    
    print_status "Processing Data Glaciers repositories from configuration file..."
    
    local processed_count=0
    local error_count=0
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ $line =~ ^[[:space:]]*# ]] || [[ -z $line ]]; then
            continue
        fi
        
        # Parse the line
        repo_url=$(echo "$line" | awk '{print $1}')
        folder_name=$(echo "$line" | awk '{print $2}')
        
        if [ -n "$repo_url" ] && [ -n "$folder_name" ]; then
            if add_subtree "$repo_url" "$folder_name"; then
                ((processed_count++))
            else
                ((error_count++))
            fi
        fi
    done < data_glaciers_repos.txt
    
    print_success "Processed $processed_count Data Glaciers repositories successfully"
    if [ $error_count -gt 0 ]; then
        print_warning "$error_count repositories had errors"
    fi
}

# Function to add remote and push
setup_remote() {
    print_status "Setting up remote repository for Data Glaciers..."
    
    read -p "Enter your new Data Glaciers remote repository URL: " remote_url
    
    if [ -n "$remote_url" ]; then
        git remote add origin "$remote_url"
        git push -u origin main
        print_success "Data Glaciers repository pushed to remote: $remote_url"
    else
        print_warning "No remote URL provided. Skipping remote setup."
    fi
}

# Function to show current status
show_status() {
    print_status "Current Data Glaciers Repository Status:"
    echo "============================================="
    
    if [ -d ".git" ]; then
        print_success "✓ Git repository initialized"
    else
        print_warning "✗ Git repository not initialized"
    fi
    
    if [ -f "data_glaciers_repos.txt" ]; then
        print_success "✓ Configuration file exists"
        echo "   Repositories configured:"
        grep -v '^#' data_glaciers_repos.txt | grep -v '^$' | while read -r line; do
            if [ -n "$line" ]; then
                repo_url=$(echo "$line" | awk '{print $1}')
                folder_name=$(echo "$line" | awk '{print $2}')
                if [ -d "$folder_name" ]; then
                    echo "   ✓ $folder_name (added)"
                else
                    echo "   ○ $folder_name (pending)"
                fi
            fi
        done
    else
        print_warning "✗ Configuration file not found"
    fi
    
    if git remote -v | grep -q origin; then
        print_success "✓ Remote repository configured"
        git remote -v | grep origin
    else
        print_warning "✗ Remote repository not configured"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Data Glaciers Repository Consolidation Tool"
    echo "=========================================="
    echo ""
    echo "Options:"
    echo "  --init              Initialize the Data Glaciers repository"
    echo "  --config             Create Data Glaciers configuration file"
    echo "  --process            Process Data Glaciers repositories from config"
    echo "  --remote             Set up remote repository"
    echo "  --status             Show current status"
    echo "  --all                Run all steps (init, config, process, remote)"
    echo "  --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --init            # Initialize the repository"
    echo "  $0 --config          # Create configuration file"
    echo "  $0 --status          # Check current status"
    echo "  $0 --all             # Run complete setup"
    echo ""
    echo "IMPORTANT: This tool is for Data Glaciers internship repositories ONLY!"
}

# Main script logic
main() {
    print_status "Data Glaciers Repository Consolidation Script"
    print_status "============================================="
    print_warning "This tool is for Data Glaciers internship repositories ONLY!"
    echo ""
    
    check_git
    check_directory
    
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    case "$1" in
        --init)
            init_main_repo
            ;;
        --config)
            create_config
            ;;
        --process)
            process_repos_from_config
            ;;
        --remote)
            setup_remote
            ;;
        --status)
            show_status
            ;;
        --all)
            init_main_repo
            create_config
            print_status "Please edit data_glaciers_repos.txt and add your Data Glaciers repository URLs"
            print_status "Then run: $0 --process"
            ;;
        --help)
            show_usage
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
