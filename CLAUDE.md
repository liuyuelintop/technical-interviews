# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **technical interview preparation repository** focused on teaching architectural thinking, not just coding. The repository contains interview problems with comprehensive guides that teach how to think like a software architect.

**Core Philosophy:**
- Focus on the "why" and "how to think", not just the "what" and "how to code"
- Teach deep requirement analysis, data modeling, architecture decisions, and edge case thinking
- Provide layered learning approaches (Interview Simulation, Guided Learning, Tutorial Mode)

## Repository Structure

```
problems/                          # Interview problems organized by category
  └── [category]/                  # react, javascript, system-design, etc.
      └── [problem-name]/
          ├── README.md            # Problem statement (read this first)
          ├── REQUIREMENTS.md      # Detailed requirements
          ├── ARCHITECTURAL_GUIDE.md   # HOW TO THINK (deep architectural analysis)
          ├── IMPLEMENTATION_GUIDE.md  # HOW TO BUILD step-by-step
          ├── solution/            # Complete working implementation
          ├── variations/          # Alternative approaches
          ├── tests/               # Test cases
          └── resources/           # API samples, designs, etc.

templates/
  └── problem-template/            # Template for creating new problems

docs/
  ├── architectural-thinking.md    # Core guide teaching architectural mindset
  ├── how-to-use-this-repo.md     # Learning approaches
  ├── learning-path.md            # Recommended progression
  └── interview-strategy.md       # Interview tips

scripts/
  └── new-problem.sh              # Script to create new problem from template

resources/                         # Shared resources
```

## Key Architectural Concepts

This repository teaches a **5-Phase Architectural Thinking Process**:

1. **Requirements Analysis** - Extract explicit and implicit requirements, ask clarifying questions
2. **Data Modeling** - Analyze API responses, design type layers (API, Domain, UI, Utility)
3. **Architecture Design** - Design component trees, state management, data flow
4. **Implementation Planning** - Build in layers (types → data → display → features)
5. **Risk & Edge Case Analysis** - Systematic analysis of what could go wrong

## Creating New Problems

When adding new problems to this repository:

### Use the Template
```bash
./scripts/new-problem.sh
```

### Required Files for Each Problem
1. **README.md** - Problem statement, difficulty, learning objectives
2. **REQUIREMENTS.md** - Detailed requirements breakdown (explicit + implicit)
3. **ARCHITECTURAL_GUIDE.md** - Deep architectural analysis showing HOW TO THINK
   - Must include: requirement analysis, data modeling, architecture decisions, trade-offs
   - Should mirror the 5-phase thinking process from docs/architectural-thinking.md
4. **IMPLEMENTATION_GUIDE.md** - Layer-by-layer build instructions
   - Build order: Types → Data → Display → Features → Polish
5. **solution/** - Complete working implementation
6. **tests/** - Test cases demonstrating edge cases
7. **resources/** - API samples, mock data, designs

### Problem Structure Standards

**Component Structure:**
- Use Smart/Dumb component pattern (containers vs presentational)
- Smart components: Own state, fetch data, contain business logic
- Dumb components: Receive props, render UI, call callbacks

**Type System:**
- Layer types into 4 categories: API types, Domain types, UI types, Utility types
- Transform API data at the boundary (in React Query `select` or dedicated transformer)
- Never use `any` - full TypeScript strict mode

**State Management:**
- Server State: React Query (TanStack Query)
- Client State: useState or custom hooks
- Derived State: useMemo (don't store computed values)
- Persistent State: localStorage + useState, or state management library

**File Organization:**
```
solution/
├── app/                  # Next.js app directory
├── components/           # React components
├── hooks/                # Custom hooks
├── lib/                  # Utilities, API functions
├── types/                # TypeScript types (layered)
└── styles/               # Global styles
```

## Development Standards

### TypeScript
- Use strict mode
- Create layered types: API → Domain → UI → Utility
- No `any` types
- Proper type guards for runtime validation

### React Best Practices
- Functional components only
- Custom hooks for reusable logic
- Proper dependency arrays in useEffect/useMemo/useCallback
- Avoid prop drilling (use custom hooks or context when needed)

### Naming Conventions
- Components: PascalCase (UserCard.tsx)
- Hooks: camelCase with "use" prefix (useUserFilter.ts)
- Utilities: camelCase (transformUser.ts)
- Types: PascalCase (User, ApiResponse)
- Constants: UPPER_SNAKE_CASE

### Code Organization
- One component per file
- Extract business logic into custom hooks
- Keep components focused (Single Responsibility)
- Co-locate related files

## Problem Difficulty Levels

### Beginner (60-90 min)
- Single feature, basic state
- React basics, simple TypeScript
- Examples: Todo app, simple form

### Intermediate (90-120 min)
- Multiple features, complex state, API integration
- React Query, custom hooks, localStorage
- Examples: User directory with filters, shopping cart

### Advanced (120-180 min)
- Complex business logic, performance optimization, multiple data sources
- Advanced patterns, optimization, real-time updates
- Examples: Rich text editor, data visualization

## Documentation Philosophy

When documenting problems or making changes:

### Focus on "Why" over "What"
- Explain architectural decisions and trade-offs
- Document alternatives considered
- Explain when to use different approaches

### Teach Thinking, Not Just Coding
- Show the thought process behind decisions
- Include edge case analysis
- Demonstrate systematic problem-solving

### Avoid Generic Advice
- Don't include obvious instructions like "write good code"
- Don't list every file that can be discovered with file navigation
- Focus on non-obvious insights and decision-making frameworks

## Testing Strategy

**Layer-by-Layer Testing:**
- Test each layer as you build it
- Don't wait until the end to test
- Document test cases for edge cases

**Edge Case Categories:**
1. Empty states (no data, no results, no favorites)
2. Extreme values (very long input, many items, single item)
3. Special characters (unicode, regex special chars)
4. Timing issues (rapid clicks, slow APIs)
5. Browser differences (localStorage disabled)
6. Network conditions (slow, offline, timeout)
7. Data integrity (null, undefined, broken URLs)

## Common Patterns

### Data Fetching with React Query
```typescript
// Custom hook pattern
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
    select: (data) => data.results.map(transformApiUser),
  });
}
```

### Custom Hooks for Business Logic
```typescript
// Encapsulate filtering logic
export function useUserFilter(users: User[]) {
  const [searchTerm, setSearchTerm] = useState('');
  const [nationality, setNationality] = useState('all');

  const filteredUsers = useMemo(
    () => filterUsers(users, searchTerm, nationality),
    [users, searchTerm, nationality]
  );

  return { filteredUsers, searchTerm, setSearchTerm, nationality, setNationality };
}
```

### localStorage with Validation
```typescript
// Always validate data from localStorage
function loadFromStorage<T>(key: string, fallback: T): T {
  try {
    const stored = localStorage.getItem(key);
    if (!stored) return fallback;
    const parsed = JSON.parse(stored);
    // Add validation here
    return parsed;
  } catch {
    return fallback;
  }
}
```

## Performance Guidelines

**For Small Datasets (< 100 items):**
- No optimization needed
- Use simple filtering with useMemo
- Client-side search and filter

**For Medium Datasets (100-1000 items):**
- Consider debouncing search
- Use useMemo for expensive calculations
- Consider React.memo for expensive components

**For Large Datasets (1000+ items):**
- Add virtualization (react-window)
- Consider server-side filtering/pagination
- Implement proper caching strategy

## Contributing Guidelines

When contributing new problems or improvements:

1. **Follow the template structure** - Use templates/problem-template/
2. **Include all required files** - Don't skip the architectural guide
3. **Test your solution** - Ensure it runs without errors
4. **Document decisions** - Explain why, not just what
5. **Add edge case analysis** - Show you've thought about what could go wrong
6. **Review against existing problems** - Maintain consistency in style and depth

## Common Development Tasks

### Create a New Problem
```bash
./scripts/new-problem.sh
# Follow prompts to create problem structure
```

### Update Problem Index
Edit `problems/README.md` to add your problem to the appropriate category table.

### Review Checklist for New Problems
- [ ] All required files present (README, REQUIREMENTS, ARCHITECTURAL_GUIDE, IMPLEMENTATION_GUIDE)
- [ ] Solution runs without errors
- [ ] TypeScript strict mode with no `any`
- [ ] Follows naming conventions
- [ ] Architectural guide explains the "why"
- [ ] Edge cases documented and tested
- [ ] Responsive design
- [ ] Accessibility considered
- [ ] Added to problems/README.md index

## Important Notes

- **No package.json at root** - Each solution has its own dependencies
- **Solutions are self-contained** - Each problem's solution/ directory is a complete Next.js app
- **Focus on learning** - Code should be clear and educational, not necessarily production-optimized
- **Multiple approaches** - Encourage variations and alternative implementations
- **Interview context** - Remember this is for interview prep, so explain communication strategies
