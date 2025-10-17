# Contributing Guidelines

Thank you for your interest in contributing to Technical Interview Problems & Solutions!

## Ways to Contribute

### 1. Add a New Problem

**Steps:**
1. Fork the repository
2. Use the problem template from `/templates/problem-template/`
3. Create a new directory in the appropriate category
4. Fill in all required files:
   - README.md (problem statement)
   - REQUIREMENTS.md (detailed requirements)
   - ARCHITECTURAL_GUIDE.md (thinking process)
   - IMPLEMENTATION_GUIDE.md (step-by-step solution)
   - solution/ (working code)
   - tests/ (test cases)
5. Ensure solution runs and all tests pass
6. Submit a pull request

**Problem Requirements:**
- Must be based on real interview questions or practical scenarios
- Must include architectural thinking guide
- Must include working solution with tests
- Must be well-documented
- Code must follow style guidelines

### 2. Improve Existing Problems

**Types of improvements welcome:**
- Better explanations
- Additional edge cases
- Performance optimizations
- Alternative implementations
- Better test coverage
- Typo fixes
- Documentation improvements

### 3. Add Resources

**Types of resources:**
- API examples
- Design assets
- Cheatsheets
- Tool recommendations
- Learning materials

## Code Style Guidelines

### JavaScript/TypeScript
- Use TypeScript strict mode
- Follow ESLint rules
- Use meaningful variable names
- Add JSDoc comments for complex functions
- Prefer functional programming patterns
- Use modern ES6+ syntax

### React
- Use functional components
- Use hooks appropriately
- Follow React best practices
- Components should be single-responsibility
- Use proper prop types

### File Naming
- Components: PascalCase (UserCard.tsx)
- Utilities: camelCase (formatDate.ts)
- Constants: UPPER_SNAKE_CASE (API_URL.ts)
- Types: PascalCase (User.ts)

### Documentation
- Use clear, concise language
- Include code examples
- Explain the "why", not just the "what"
- Use diagrams where helpful
- Include links to relevant resources

## Pull Request Process

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/technical-interviews.git
   cd technical-interviews
   ```

2. **Create Branch**
   ```bash
   git checkout -b add-problem-name
   # or
   git checkout -b fix-problem-name
   ```

3. **Make Changes**
   - Follow template structure
   - Write clear commit messages
   - Test your solution

4. **Commit**
   ```bash
   git add .
   git commit -m "Add: User Directory problem with architectural guide"
   # or
   git commit -m "Fix: Typo in React hooks cheatsheet"
   ```

5. **Push**
   ```bash
   git push origin add-problem-name
   ```

6. **Create Pull Request**
   - Use descriptive title
   - Describe what you added/changed
   - Reference any related issues
   - Add screenshots if applicable

## Pull Request Template

```markdown
## Description
Brief description of what this PR adds or fixes.

## Type of Change
- [ ] New problem
- [ ] Bug fix
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Refactoring

## Problem Details (if adding new problem)
- **Category**: React / JavaScript / System Design / etc.
- **Difficulty**: Beginner / Intermediate / Advanced
- **Time Estimate**: X minutes
- **Technologies**: React, TypeScript, etc.

## Checklist
- [ ] Code follows style guidelines
- [ ] Solution runs without errors
- [ ] All tests pass
- [ ] Documentation is complete
- [ ] Self-reviewed the code
- [ ] Added comments for complex logic
- [ ] No console.log statements left
- [ ] Updated relevant README files

## Additional Notes
Any additional context or notes for reviewers.
```

## Review Process

1. Maintainers will review your PR within 3-5 days
2. Feedback will be provided if changes are needed
3. Once approved, your PR will be merged
4. You'll be added to contributors list!

## Community Guidelines

- Be respectful and constructive
- Help others in discussions
- Share knowledge and learn together
- Focus on teaching, not just providing answers
- Encourage architectural thinking

## Questions?

If you have questions, feel free to:
- Open an issue
- Start a discussion
- Ask in pull request comments

Thank you for contributing! 🎉
