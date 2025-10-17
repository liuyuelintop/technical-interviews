#!/bin/bash

# Script to create a new problem from template

set -e

echo "🚀 Create New Technical Interview Problem"
echo "========================================"
echo ""

# Get inputs
read -p "Problem category (react/javascript/typescript/system-design/full-stack): " category
read -p "Problem name (kebab-case, e.g., user-directory): " name
read -p "Difficulty (beginner/intermediate/advanced): " difficulty
read -p "Estimated time (in minutes): " time
read -p "Short description: " description

# Validate
if [ -z "$category" ] || [ -z "$name" ]; then
    echo "❌ Category and name are required!"
    exit 1
fi

# Create directory
problem_dir="problems/$category/$name"

if [ -d "$problem_dir" ]; then
    echo "❌ Problem already exists at $problem_dir"
    exit 1
fi

echo ""
echo "Creating problem at: $problem_dir"
echo ""

mkdir -p "$problem_dir"
mkdir -p "$problem_dir/solution"
mkdir -p "$problem_dir/variations"
mkdir -p "$problem_dir/tests"
mkdir -p "$problem_dir/resources"

# Copy templates
cp templates/problem-template/README.md "$problem_dir/README.md"
cp templates/problem-template/REQUIREMENTS.md "$problem_dir/REQUIREMENTS.md"
cp templates/problem-template/ARCHITECTURAL_GUIDE.md "$problem_dir/ARCHITECTURAL_GUIDE.md"
cp templates/problem-template/IMPLEMENTATION_GUIDE.md "$problem_dir/IMPLEMENTATION_GUIDE.md"

# Replace placeholders
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/{{PROBLEM_NAME}}/$name/g" "$problem_dir/README.md"
    sed -i '' "s/{{DIFFICULTY}}/$difficulty/g" "$problem_dir/README.md"
    sed -i '' "s/{{TIME}}/$time/g" "$problem_dir/README.md"
    sed -i '' "s/{{DESCRIPTION}}/$description/g" "$problem_dir/README.md"
else
    # Linux
    sed -i "s/{{PROBLEM_NAME}}/$name/g" "$problem_dir/README.md"
    sed -i "s/{{DIFFICULTY}}/$difficulty/g" "$problem_dir/README.md"
    sed -i "s/{{TIME}}/$time/g" "$problem_dir/README.md"
    sed -i "s/{{DESCRIPTION}}/$description/g" "$problem_dir/README.md"
fi

echo "✅ Problem structure created!"
echo ""
echo "📝 Next steps:"
echo "   1. Edit $problem_dir/README.md"
echo "   2. Fill in $problem_dir/REQUIREMENTS.md"
echo "   3. Write $problem_dir/ARCHITECTURAL_GUIDE.md"
echo "   4. Write $problem_dir/IMPLEMENTATION_GUIDE.md"
echo "   5. Create solution in $problem_dir/solution/"
echo "   6. Add tests in $problem_dir/tests/"
echo ""
echo "🎉 Happy problem creating!"
