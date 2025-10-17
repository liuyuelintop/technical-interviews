# User Directory with Search & Filter

## 📋 Problem Statement

Build a user directory application that fetches user data from an API and allows users to search and filter the results.

## 🎯 Difficulty Level

**Intermediate**

- **Estimated Time:** 90-120 minutes
- **Technologies:** React, TypeScript, TanStack Query, Tailwind CSS, Next.js
- **Concepts:** API integration, state management, filtering, data transformation

## 🏆 Learning Objectives

By completing this problem, you will learn:
- How to integrate with REST APIs using React Query
- Data modeling and TypeScript type design
- Client-side filtering and search implementation
- Custom hooks for business logic
- Component architecture and composition
- localStorage for persistence
- Responsive design with Tailwind CSS

## 🔧 Technologies & Tools

- **Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript
- **State Management:** React Query + useState
- **Styling:** Tailwind CSS
- **API:** Random User API (https://randomuser.me/api/?results=50)

## 📝 Core Requirements

### Must Have (P0)
1. Fetch 50 users from Random User API
2. Display users in a responsive grid
3. Show: profile image, name, email, nationality
4. Search by first OR last name (case-insensitive, real-time)
5. Filter by nationality using dropdown
6. Show loading state while fetching
7. Show error state on failure
8. Show "no results" when filters return empty

### Should Have (P1)
9. Favorites feature with persistence (localStorage)
10. Tab navigation between "All Users" and "Favorites"
11. Responsive design (mobile, tablet, desktop)
12. Proper TypeScript types throughout

### Nice to Have (P2)
13. Debounced search for large datasets
14. Skeleton loaders
15. Animations/transitions
16. Accessibility features

## 🚀 Getting Started

### Approach Options

1. **Interview Simulation** (90 min)
   - Read requirements, try solving yourself
   - Time yourself
   - Review solution after

2. **Guided Learning** (4-6 hours)
   - Follow ARCHITECTURAL_GUIDE.md step by step
   - Deep dive into each decision
   - Build with full understanding

3. **Tutorial Mode** (2-3 hours)
   - Follow IMPLEMENTATION_GUIDE.md
   - Build along with instructions
   - Rebuild from memory after

### Files in This Problem

- `REQUIREMENTS.md` - Detailed requirements breakdown
- `ARCHITECTURAL_GUIDE.md` - How to think about this problem
- `IMPLEMENTATION_GUIDE.md` - Step-by-step build instructions
- `solution/` - Complete working implementation
- `variations/` - Alternative implementations
- `tests/` - Test cases and testing guide
- `resources/` - API samples, designs, etc.

## 📚 Prerequisites

You should be comfortable with:
- React basics (components, hooks, state)
- TypeScript fundamentals
- Basic API integration
- CSS/Tailwind basics

If you're not comfortable yet, consider starting with beginner problems first.

## 💡 Hints

<details>
<summary>Click to reveal hints (try without first!)</summary>

### Hint 1: State Management
- Use React Query for server state (users from API)
- Use useState for client state (search, filter, favorites)
- Use useMemo for derived state (filtered users)

### Hint 2: Component Structure
- Separate smart (container) and dumb (presentational) components
- Extract filtering logic into custom hook
- Keep UserCard component simple and reusable

### Hint 3: Data Modeling
- Create separate types for API response and domain objects
- Transform API data at the boundary
- Use email as unique identifier

### Hint 4: Edge Cases
- Handle API failures gracefully
- Validate localStorage data on load
- Handle empty search and filter states
- Make sure images have alt text
- Test with keyboard navigation

</details>

## ✅ Success Criteria

Your solution should:
- [ ] Meet all P0 requirements
- [ ] Be fully typed with TypeScript (no `any`)
- [ ] Have no console errors or warnings
- [ ] Handle loading and error states
- [ ] Be responsive on all screen sizes
- [ ] Be keyboard accessible
- [ ] Have clean, organized code
- [ ] Follow React best practices

## 🎓 What You'll Learn

### Technical Skills
- API integration with React Query
- TypeScript type modeling
- Custom hooks design
- Component architecture
- State management patterns
- localStorage integration

### Architectural Thinking
- Requirement analysis (explicit vs implicit)
- Data structure design
- State management decisions
- Component responsibility boundaries
- Performance considerations
- Edge case analysis

### Interview Skills
- Problem decomposition
- Systematic implementation
- Communication while coding
- Trade-off analysis
- Time management

## 🔄 Variations to Try

After completing the base problem, try these variations:

1. **State Management:** Rebuild with Zustand or Redux
2. **Styling:** Rebuild with styled-components or CSS modules
3. **Features:** Add sorting, pagination, or detail modal
4. **Performance:** Add virtualization for 1000+ users
5. **Testing:** Add comprehensive test suite

## 📖 Related Problems

- **Easier:** Simple Todo List
- **Similar:** Product Catalog with Filters
- **Harder:** Dashboard with Multiple Data Sources

## 🤔 Reflection Questions

After completing, reflect on:
1. What was the hardest part?
2. What would you do differently?
3. What trade-offs did you make?
4. How would you scale this for 10,000 users?
5. What would you add given more time?

---

**Ready to start?** Choose your approach and dive in!

**Need help?** Check the guides or open a discussion.

**Finished?** Compare with solution and try a variation!
