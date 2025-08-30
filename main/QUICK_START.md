# Quick Start Guide - Data Glaciers Repository Consolidation

## 🚀 Get Started in 5 Minutes

### ⚠️ IMPORTANT: Data Glaciers Only!
This tool is designed to consolidate ONLY your Data Glaciers internship repositories. 
It will NOT touch any other Git repositories on your system.

### Step 1: Initialize Your Data Glaciers Repository
```bash
./consolidate_repos.sh --init
```

### Step 2: Create Configuration File
```bash
./consolidate_repos.sh --config
```

### Step 3: Edit Configuration
Open `data_glaciers_repos.txt` and add ONLY your Data Glaciers repository URLs:
```
https://github.com/yourusername/data-glaciers-week1.git week1
https://github.com/yourusername/data-glaciers-week2.git week2
https://github.com/yourusername/data-glaciers-week3.git week3
```

### Step 4: Process All Data Glaciers Repositories
```bash
./consolidate_repos.sh --process
```

### Step 5: Push to New Remote (Optional)
```bash
./consolidate_repos.sh --remote
```

## 🎯 One-Command Setup
```bash
./consolidate_repos.sh --all
```
Then edit `data_glaciers_repos.txt` and run:
```bash
./consolidate_repos.sh --process
```

## 📋 What You Need
- Your Data Glaciers internship repository URLs
- A new empty repository on GitHub/GitLab/etc.
- Git installed on your system

## 🔍 Expected Result
After running the script, you'll have:
```
Data-Glaciers/
├── week1/          # Your Data Glaciers Week 1 work
├── week2/          # Your Data Glaciers Week 2 work  
├── week3/          # Your Data Glaciers Week 3 work
├── README.md       # This guide
└── .git/           # Git history
```

## 🛡️ Safety Features
- ✅ Only processes Data Glaciers repositories
- ✅ Validates repository URLs before processing
- ✅ Won't touch other Git repositories
- ✅ Directory safety checks
- ✅ Confirmation prompts for safety

## 📊 Check Status
```bash
./consolidate_repos.sh --status
```

## ❓ Need Help?
- Run `./consolidate_repos.sh --help` for all options
- Check the main README.md for detailed explanations
- All commit history will be preserved!
- Your other repositories will remain untouched!
