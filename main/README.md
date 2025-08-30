# Data Glaciers Repository Consolidation Guide

This guide will help you consolidate multiple separate Git repositories into a single repository while preserving all commit history.

## Overview
You have multiple repositories from your Data Glaciers internship work, and you want to combine them into a single repository for easier job applications.

## Prerequisites
- Git installed on your system
- Access to all your original repositories
- Basic Git knowledge

## Method 1: Git Subtree (Recommended)

### Step 1: Create the Main Repository
```bash
# Navigate to your Data Glaciers folder
cd "/Users/nazrin/Desktop/Data Glaciers"

# Initialize a new Git repository
git init
git add .
git commit -m "Initial commit for Data Glaciers consolidated repository"
```

### Step 2: Add Each Repository as a Subtree
For each of your separate repositories, you'll use the `git subtree add` command:

```bash
# Example for Week 1 repository
git subtree add --prefix=week1 <week1-repo-url> main --squash

# Example for Week 2 repository  
git subtree add --prefix=week2 <week2-repo-url> main --squash

# Continue for each week...
```

### Step 3: Push to a New Remote Repository
```bash
# Add your new remote repository
git remote add origin <your-new-repo-url>
git push -u origin main
```

## Method 2: Git Submodules

### Step 1: Create Main Repository
```bash
git init
git add .
git commit -m "Initial commit"
```

### Step 2: Add Each Repository as a Submodule
```bash
# Add each repository as a submodule
git submodule add <week1-repo-url> week1
git submodule add <week2-repo-url> week2
# Continue for each week...

git commit -m "Add submodules for all weeks"
```

## Method 3: Manual Merge with History Preservation

### Step 1: Clone Each Repository Locally
```bash
# Clone each repository to a temporary location
git clone <week1-repo-url> temp-week1
git clone <week2-repo-url> temp-week2
# Continue for each week...
```

### Step 2: Use Git Filter-Branch to Move Files
```bash
# For each repository, move files to a subdirectory
cd temp-week1
git filter-branch --tree-filter 'mkdir -p week1 && git mv -k * week1/' HEAD
cd ../temp-week2
git filter-branch --tree-filter 'mkdir -p week2 && git mv -k * week2/' HEAD
# Continue for each week...
```

### Step 3: Merge All Repositories
```bash
# Start with the first repository
cd temp-week1
git remote add week2 ../temp-week2
git fetch week2
git merge week2/main --allow-unrelated-histories

# Continue merging other repositories...
```

## Next Steps

1. **Identify Your Repositories**: List all the separate repositories you want to consolidate
2. **Choose a Method**: Decide which approach works best for your situation
3. **Execute the Plan**: Follow the steps for your chosen method
4. **Test the Result**: Ensure all files and history are preserved correctly

## Repository Structure After Consolidation
```
Data-Glaciers/
├── week1/
│   ├── [week 1 files]
│   └── .git/ (if using submodules)
├── week2/
│   ├── [week 2 files]
│   └── .git/ (if using submodules)
├── week3/
│   ├── [week 3 files]
│   └── .git/ (if using submodules)
├── README.md
└── .git/
```

## Important Notes

- **Backup First**: Always backup your original repositories before starting
- **Test Locally**: Test the consolidation process on a copy first
- **Documentation**: Update your README to explain the structure
- **Clean Up**: Remove temporary files and repositories after successful consolidation

## Getting Started

To begin the consolidation process:

1. List all your repository URLs
2. Choose your preferred method
3. Follow the step-by-step instructions
4. Test the final result

Would you like me to help you with any specific step or create a script to automate this process?
