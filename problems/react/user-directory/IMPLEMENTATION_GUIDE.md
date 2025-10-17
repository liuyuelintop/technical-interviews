# React Technical Interview Preparation Guide

## Your Situation Analysis

**Previous Interview Issues:**
- Failed to add favorites feature
- Couldn't debug AI-generated code
- Lacked solid foundation to work independently

**Root Cause:** Insufficient understanding of the tech stack fundamentals

**Tech Stack:** TypeScript, React, TanStack Query, Tailwind CSS, Next.js

---

## 6-Week Comprehensive Preparation Plan

### Phase 1: Foundation (Week 1-2)
**Goal: Master each technology independently before combining them**

#### 1.1 TypeScript Fundamentals (Days 1-3)

**Core Concepts to Master:**
- Type definitions and interfaces
- Generic types
- Type guards and type narrowing
- Utility types (Pick, Omit, Partial, Record)
- Union and intersection types

**Practice Exercise 1: User Data Type Modeling**
```typescript
// Exercise: Create types for the Random User API response
// API endpoint: https://randomuser.me/api/?results=50

// Step 1: Define the User interface
interface User {
  // TODO: Add properties based on API response
  // - name (with first and last)
  // - email
  // - picture (with large, medium, thumbnail)
  // - nat (nationality)
}

// Step 2: Define the API response structure
interface ApiResponse {
  // TODO: results array, info object
}

// Step 3: Create utility types
type UserCard = Pick<User, 'name' | 'email' | 'picture' | 'nat'>;
type UserSearchFields = Pick<User, 'name'>;
```

**Practice Exercise 2: Type-Safe Filter Functions**
```typescript
// Create a generic filter function with proper types
function filterByProperty<T, K extends keyof T>(
  items: T[],
  key: K,
  value: T[K]
): T[] {
  // TODO: Implement
}

// Usage example:
// const usersFromUS = filterByProperty(users, 'nat', 'US');
```

**Learning Resources:**
- TypeScript Handbook (official docs)
- Execute Type (interactive exercises)
- Practice on TypeScript Playground

**Success Criteria:**
- Write types without looking at references
- Understand error messages and fix them
- Use generics confidently

---

#### 1.2 React Core Concepts (Days 4-6)

**Core Concepts to Master:**
- useState: When and how state updates
- useEffect: Dependencies and cleanup
- Custom hooks: Extracting reusable logic
- Component composition
- Controlled inputs
- Re-render behavior

**Practice Exercise 1: Build a Simple Filtered List**
```typescript
// Build WITHOUT API first - use mock data
// This isolates React logic from data fetching

const mockUsers = [
  { id: 1, name: 'John Doe', country: 'US' },
  { id: 2, name: 'Jane Smith', country: 'UK' },
  // ... more mock data
];

// TODO: Create a component that:
// 1. Displays the list
// 2. Has a search input that filters by name
// 3. Has a dropdown that filters by country
// 4. Shows filtered count
```

**Practice Exercise 2: Custom Hook Pattern**
```typescript
// Extract the filter logic into a custom hook
function useFilteredUsers(users, searchTerm, selectedCountry) {
  // TODO: Implement the filtering logic
  // Return filtered users
}

// Why custom hooks?
// - Reusability
// - Testability
// - Separation of concerns
```

**Practice Exercise 3: Understanding Re-renders**
```typescript
// Experiment: When does a component re-render?
// 1. Add console.log to see render count
// 2. Test with different state updates
// 3. Use React DevTools Profiler
```

**Common Pitfalls to Understand:**
```typescript
// Pitfall 1: State updates are asynchronous
const [count, setCount] = useState(0);
const handleClick = () => {
  setCount(count + 1);
  console.log(count); // Still old value! Why?
};

// Pitfall 2: Object/array state updates
const [user, setUser] = useState({ name: 'John', age: 30 });
// Wrong:
user.age = 31; // Doesn't trigger re-render
// Right:
setUser({ ...user, age: 31 }); // Creates new object

// Pitfall 3: useEffect dependencies
useEffect(() => {
  // If you use 'searchTerm' here, it MUST be in dependencies
  filterUsers(searchTerm);
}, []); // Missing dependency!
```

**Success Criteria:**
- Explain why and when re-renders happen
- Write custom hooks from scratch
- Debug state update issues independently

---

#### 1.3 TanStack Query / React Query (Days 7-9)

**Core Concepts to Master:**
- Query basics: useQuery hook
- Query keys and caching
- Loading, error, and success states
- Stale time and cache time
- Query invalidation and refetching
- Optimistic updates

**Practice Exercise 1: Basic Data Fetching**
```typescript
// Setup QueryClient
import { QueryClient, QueryClientProvider, useQuery } from '@tanstack/react-query';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Understanding these options is CRITICAL
      staleTime: 1000 * 60 * 5, // 5 minutes
      cacheTime: 1000 * 60 * 10, // 10 minutes
      retry: 1,
    },
  },
});

// Create a custom hook for fetching users
function useUsers() {
  return useQuery({
    queryKey: ['users'], // IMPORTANT: Understand query keys
    queryFn: async () => {
      const response = await fetch('https://randomuser.me/api/?results=50');
      if (!response.ok) throw new Error('Failed to fetch');
      return response.json();
    },
  });
}

// Usage in component
function UserList() {
  const { data, isLoading, isError, error } = useUsers();

  // TODO: Handle all three states properly
  if (isLoading) return <div>Loading...</div>;
  if (isError) return <div>Error: {error.message}</div>;

  return <div>{/* Render users */}</div>;
}
```

**Practice Exercise 2: Understanding Query States**
```typescript
// React Query has many states - understand each one:
const query = useQuery(...);

// States to understand:
// - isLoading: First time fetching (no cached data)
// - isFetching: Any fetch (including background refetch)
// - isError: Query failed
// - isSuccess: Query succeeded
// - data: The actual data
// - error: Error object if failed

// When does it refetch?
// - Component remounts
// - Window refocuses
// - Network reconnects
// - Stale time expires
// - Manual invalidation
```

**Practice Exercise 3: Query DevTools**
```typescript
// Install React Query DevTools
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <YourApp />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}

// TODO: Open DevTools and observe:
// - Query keys
// - Cache contents
// - Stale/Fresh states
// - Refetch behavior
```

**Common Mistakes:**
```typescript
// Mistake 1: Not handling loading state
function UserList() {
  const { data } = useUsers();
  return <div>{data.results.map(...)}</div>; // Crashes! data is undefined while loading
}

// Mistake 2: Wrong query key
useQuery(['users']); // Different from:
useQuery(['users', filters]); // These are DIFFERENT queries!

// Mistake 3: Fetching in useEffect instead of useQuery
// Don't do this:
useEffect(() => {
  fetch('...')
    .then(res => res.json())
    .then(data => setState(data));
}, []);
// Use useQuery instead - you get caching, loading states, etc. for free!
```

**Success Criteria:**
- Explain the difference between isLoading and isFetching
- Understand when queries refetch
- Use query keys correctly
- Handle all query states properly

---

#### 1.4 Tailwind CSS (Days 10-11)

**Core Concepts to Master:**
- Utility-first approach
- Responsive design (sm:, md:, lg:, xl:)
- Flexbox and Grid utilities
- Spacing system (p-, m-, gap-)
- Hover and focus states
- Dark mode (optional but good to know)

**Practice Exercise 1: User Card Component**
```typescript
// Design a user card using ONLY Tailwind utilities
function UserCard({ user }) {
  return (
    <div className="
      // TODO: Add Tailwind classes for:
      // - White background
      // - Rounded corners
      // - Shadow
      // - Padding
      // - Hover effect
      // - Responsive width
    ">
      <img
        src={user.picture.large}
        className="
          // TODO: Add classes for:
          // - Rounded full (circle)
          // - Fixed size
          // - Centered
        "
      />
      <h3 className="
        // TODO: Typography classes
      ">
        {user.name.first} {user.name.last}
      </h3>
      {/* More content */}
    </div>
  );
}
```

**Practice Exercise 2: Responsive Grid Layout**
```typescript
// Create a responsive grid for user cards
<div className="
  grid
  grid-cols-1      // 1 column on mobile
  sm:grid-cols-2   // 2 columns on small screens
  md:grid-cols-3   // 3 columns on medium screens
  lg:grid-cols-4   // 4 columns on large screens
  gap-4            // Space between cards
  p-4              // Padding around grid
">
  {users.map(user => <UserCard key={user.id} user={user} />)}
</div>
```

**Practice Exercise 3: Form Inputs**
```typescript
// Style search input and dropdown
<input
  type="text"
  placeholder="Search by name..."
  className="
    w-full           // Full width
    px-4 py-2        // Padding inside
    border           // Border
    border-gray-300  // Border color
    rounded-lg       // Rounded corners
    focus:outline-none        // Remove default outline
    focus:ring-2              // Custom focus ring
    focus:ring-blue-500       // Ring color
    focus:border-transparent  // Hide border on focus
  "
/>
```

**Common Patterns:**
```css
/* Centering */
.flex.items-center.justify-center

/* Card style */
.bg-white.rounded-lg.shadow-md.p-6

/* Button */
.px-4.py-2.bg-blue-500.text-white.rounded.hover:bg-blue-600

/* Responsive container */
.container.mx-auto.px-4.max-w-7xl
```

**Success Criteria:**
- Build UI without writing custom CSS
- Understand spacing scale (4 = 1rem)
- Make responsive layouts
- Use hover/focus states

---

#### 1.5 Next.js Basics (Days 12-14)

**Core Concepts to Master:**
- App Router vs Pages Router
- File-based routing
- Client vs Server Components
- API routes (optional for this project)
- Layout components

**Project Setup Practice:**
```bash
# Create new Next.js project with TypeScript
npx create-next-app@latest user-directory --typescript --tailwind --app

# What this creates:
# - app/ directory (App Router)
# - public/ for static files
# - next.config.js
# - tsconfig.json
# - tailwind.config.js

# Install TanStack Query
npm install @tanstack/react-query
```

**Practice Exercise 1: File Structure**
```
app/
  layout.tsx       # Root layout (wraps all pages)
  page.tsx         # Home page (main user directory)
  providers.tsx    # Client component for React Query

components/
  UserCard.tsx
  SearchInput.tsx
  NationalityFilter.tsx
  UserDirectory.tsx

hooks/
  useUsers.ts      # TanStack Query hook
  useUserFilter.ts # Custom filter logic

types/
  user.ts          # TypeScript interfaces

lib/
  queryClient.ts   # React Query configuration
```

**Practice Exercise 2: Client vs Server Components**
```typescript
// Server Component (default in Next.js App Router)
// Can fetch data directly, but no hooks or interactivity
export default async function UsersPage() {
  const data = await fetch('https://randomuser.me/api/?results=50');
  const users = await data.json();
  return <UserList users={users} />;
}

// Client Component (needs 'use client' directive)
// Can use hooks, state, and browser APIs
'use client';

import { useState } from 'react';

export function UserDirectory() {
  const [search, setSearch] = useState('');
  // ... rest of component
}
```

**For This Interview, Recommendation:**
- Use Client Components ('use client') for everything
- Don't worry about Server Components optimization
- Focus on React Query for data fetching
- Keep it simple

**Success Criteria:**
- Setup new Next.js project quickly
- Understand basic file structure
- Know when to use 'use client'

---

### Phase 2: Integration (Week 3)
**Goal: Build the complete project from scratch multiple times**

#### Build Iteration Strategy

**Build #1: Tutorial Mode (4-6 hours)**
- Follow documentation closely
- Look up every concept you don't understand
- Add detailed comments explaining each part
- Take notes on confusing parts

**Build #2: Reference Mode (2-4 hours)**
- Start from scratch (new project)
- Use your Build #1 as reference
- Try to write from memory first
- Check reference when stuck
- Notice what you remembered vs forgot

**Build #3: Memory Mode (1.5-3 hours)**
- Start from scratch again
- NO references (except TypeScript errors)
- Focus on understanding, not perfection
- This reveals your true understanding

---

#### 2.1 Complete Implementation Guide

**Step 1: Project Initialization (15 min)**

```bash
# Create project
npx create-next-app@latest user-directory --typescript --tailwind --app

cd user-directory

# Install dependencies
npm install @tanstack/react-query

# Start dev server
npm run dev
```

---

**Step 2: Type Definitions (20 min)**

Create `types/user.ts`:

```typescript
// Based on Random User API response structure
// Visit https://randomuser.me/api/?results=1 to see full response

export interface User {
  gender: string;
  name: {
    title: string;
    first: string;
    last: string;
  };
  email: string;
  picture: {
    large: string;
    medium: string;
    thumbnail: string;
  };
  nat: string; // Nationality code (e.g., 'US', 'GB', 'FR')
  // Add other fields as needed
}

export interface RandomUserApiResponse {
  results: User[];
  info: {
    seed: string;
    results: number;
    page: number;
    version: string;
  };
}

// Utility types for components
export type UserCardProps = {
  user: User;
  onFavorite?: (user: User) => void;
  isFavorite?: boolean;
};

export type NationalityOption = {
  value: string;
  label: string;
};
```

**WHY THIS MATTERS:**
- Types catch bugs at compile time
- Autocomplete makes coding faster
- Documents API structure
- Makes refactoring safer

---

**Step 3: React Query Setup (15 min)**

Create `lib/queryClient.ts`:

```typescript
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Data is considered fresh for 5 minutes
      staleTime: 1000 * 60 * 5,

      // Cache persists for 10 minutes
      cacheTime: 1000 * 60 * 10,

      // Retry failed requests once
      retry: 1,

      // Don't refetch on window focus (for this simple app)
      refetchOnWindowFocus: false,
    },
  },
});
```

Create `app/providers.tsx`:

```typescript
'use client';

import { QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { queryClient } from '@/lib/queryClient';

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

Update `app/layout.tsx`:

```typescript
import { Providers } from './providers';
import './globals.css';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

**WHY THIS MATTERS:**
- QueryClient configured ONCE
- All queries share this configuration
- DevTools help debug data fetching issues

---

**Step 4: Data Fetching Hook (20 min)**

Create `hooks/useUsers.ts`:

```typescript
import { useQuery } from '@tanstack/react-query';
import { RandomUserApiResponse } from '@/types/user';

const RANDOM_USER_API = 'https://randomuser.me/api/?results=50';

async function fetchUsers(): Promise<RandomUserApiResponse> {
  const response = await fetch(RANDOM_USER_API);

  if (!response.ok) {
    throw new Error('Failed to fetch users');
  }

  return response.json();
}

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,

    // Optional: Transform data
    select: (data) => data.results,
  });
}
```

**CRITICAL UNDERSTANDING:**
```typescript
// What happens when you call useUsers()?

const { data, isLoading, isError, error } = useUsers();

// First render:
// - isLoading: true
// - data: undefined

// After fetch succeeds:
// - isLoading: false
// - isSuccess: true
// - data: User[]

// If fetch fails:
// - isLoading: false
// - isError: true
// - error: Error object

// Component re-renders automatically when states change!
```

---

**Step 5: Filter Logic Hook (30 min)**

Create `hooks/useUserFilter.ts`:

```typescript
import { useMemo, useState } from 'react';
import { User } from '@/types/user';

export function useUserFilter(users: User[] | undefined) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedNationality, setSelectedNationality] = useState('all');

  // Get unique nationalities for dropdown
  const nationalities = useMemo(() => {
    if (!users) return [];

    const uniqueNats = Array.from(new Set(users.map(user => user.nat)));
    return uniqueNats.sort();
  }, [users]);

  // Filter users based on search and nationality
  const filteredUsers = useMemo(() => {
    if (!users) return [];

    return users.filter(user => {
      // Search filter (first name OR last name)
      const matchesSearch = searchTerm === '' ||
        user.name.first.toLowerCase().includes(searchTerm.toLowerCase()) ||
        user.name.last.toLowerCase().includes(searchTerm.toLowerCase());

      // Nationality filter
      const matchesNationality = selectedNationality === 'all' ||
        user.nat === selectedNationality;

      return matchesSearch && matchesNationality;
    });
  }, [users, searchTerm, selectedNationality]);

  return {
    searchTerm,
    setSearchTerm,
    selectedNationality,
    setSelectedNationality,
    nationalities,
    filteredUsers,
  };
}
```

**WHY useMemo?**
```typescript
// Without useMemo:
const filteredUsers = users.filter(...); // Runs on EVERY render

// With useMemo:
const filteredUsers = useMemo(() => {
  return users.filter(...);
}, [users, searchTerm, selectedNationality]); // Only runs when dependencies change

// Performance tip: Use for expensive calculations
// Not critical for 50 users, but good practice
```

**DEBUGGING TIP:**
```typescript
// Add logging to understand when filters run
const filteredUsers = useMemo(() => {
  console.log('Filtering users:', { searchTerm, selectedNationality });
  return users.filter(...);
}, [users, searchTerm, selectedNationality]);

// If you see this logging too much, check dependencies!
```

---

**Step 6: UI Components (60 min)**

Create `components/SearchInput.tsx`:

```typescript
'use client';

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
}

export function SearchInput({ value, onChange }: SearchInputProps) {
  return (
    <div className="w-full">
      <label htmlFor="search" className="block text-sm font-medium text-gray-700 mb-2">
        Search Users
      </label>
      <input
        id="search"
        type="text"
        placeholder="Search by first or last name..."
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="
          w-full
          px-4 py-2
          border border-gray-300
          rounded-lg
          focus:outline-none
          focus:ring-2
          focus:ring-blue-500
          focus:border-transparent
        "
      />
    </div>
  );
}
```

**CONTROLLED INPUT PATTERN:**
```typescript
// The input value is CONTROLLED by React state
// value={value} - Input shows this value
// onChange={(e) => onChange(e.target.value)} - Updates state when user types

// Flow:
// 1. User types in input
// 2. onChange fires
// 3. Parent component updates state
// 4. Component re-renders
// 5. Input shows new value

// This is the React way - single source of truth
```

Create `components/NationalityFilter.tsx`:

```typescript
'use client';

interface NationalityFilterProps {
  value: string;
  options: string[];
  onChange: (value: string) => void;
}

export function NationalityFilter({ value, options, onChange }: NationalityFilterProps) {
  return (
    <div className="w-full">
      <label htmlFor="nationality" className="block text-sm font-medium text-gray-700 mb-2">
        Filter by Nationality
      </label>
      <select
        id="nationality"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="
          w-full
          px-4 py-2
          border border-gray-300
          rounded-lg
          focus:outline-none
          focus:ring-2
          focus:ring-blue-500
          focus:border-transparent
          bg-white
        "
      >
        <option value="all">All Nationalities</option>
        {options.map(nat => (
          <option key={nat} value={nat}>
            {nat}
          </option>
        ))}
      </select>
    </div>
  );
}
```

Create `components/UserCard.tsx`:

```typescript
'use client';

import { User } from '@/types/user';

interface UserCardProps {
  user: User;
}

export function UserCard({ user }: UserCardProps) {
  return (
    <div className="
      bg-white
      rounded-lg
      shadow-md
      p-6
      hover:shadow-lg
      transition-shadow
      duration-200
    ">
      <div className="flex flex-col items-center">
        <img
          src={user.picture.large}
          alt={`${user.name.first} ${user.name.last}`}
          className="w-24 h-24 rounded-full mb-4"
        />

        <h3 className="text-xl font-semibold text-gray-900 mb-1">
          {user.name.first} {user.name.last}
        </h3>

        <p className="text-sm text-gray-500 mb-2">
          {user.email}
        </p>

        <span className="
          inline-block
          px-3 py-1
          bg-blue-100
          text-blue-800
          rounded-full
          text-xs
          font-medium
        ">
          {user.nat}
        </span>
      </div>
    </div>
  );
}
```

**COMPONENT DESIGN PRINCIPLES:**
```typescript
// 1. Single Responsibility
// Each component does ONE thing well

// 2. Props Interface
// Always define TypeScript interface for props

// 3. Composition over Complexity
// Small, reusable components

// 4. Accessibility
// Use semantic HTML (labels, alt text, etc.)
```

---

**Step 7: Main Directory Component (30 min)**

Create `components/UserDirectory.tsx`:

```typescript
'use client';

import { useUsers } from '@/hooks/useUsers';
import { useUserFilter } from '@/hooks/useUserFilter';
import { SearchInput } from './SearchInput';
import { NationalityFilter } from './NationalityFilter';
import { UserCard } from './UserCard';

export function UserDirectory() {
  // Fetch users
  const { data: users, isLoading, isError, error } = useUsers();

  // Filter logic
  const {
    searchTerm,
    setSearchTerm,
    selectedNationality,
    setSelectedNationality,
    nationalities,
    filteredUsers,
  } = useUserFilter(users);

  // Loading state
  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl text-gray-600">Loading users...</div>
      </div>
    );
  }

  // Error state
  if (isError) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl text-red-600">
          Error: {error instanceof Error ? error.message : 'Failed to load users'}
        </div>
      </div>
    );
  }

  // Main UI
  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl">
      <h1 className="text-4xl font-bold text-gray-900 mb-8 text-center">
        User Directory
      </h1>

      {/* Filters */}
      <div className="mb-8 grid grid-cols-1 md:grid-cols-2 gap-4">
        <SearchInput
          value={searchTerm}
          onChange={setSearchTerm}
        />
        <NationalityFilter
          value={selectedNationality}
          options={nationalities}
          onChange={setSelectedNationality}
        />
      </div>

      {/* Results count */}
      <div className="mb-4 text-gray-600">
        Showing {filteredUsers.length} of {users?.length || 0} users
      </div>

      {/* User grid */}
      {filteredUsers.length === 0 ? (
        <div className="text-center text-gray-500 py-12">
          No users found matching your criteria
        </div>
      ) : (
        <div className="
          grid
          grid-cols-1
          sm:grid-cols-2
          md:grid-cols-3
          lg:grid-cols-4
          gap-6
        ">
          {filteredUsers.map(user => (
            <UserCard
              key={`${user.email}-${user.nat}`}
              user={user}
            />
          ))}
        </div>
      )}
    </div>
  );
}
```

**DATA FLOW UNDERSTANDING:**
```
1. useUsers() fetches data from API
   ↓
2. users passed to useUserFilter()
   ↓
3. useUserFilter() combines users + searchTerm + selectedNationality
   ↓
4. Returns filteredUsers
   ↓
5. filteredUsers.map() renders UserCard components

When user types in search:
setSearchTerm → state updates → useUserFilter re-runs → filteredUsers updates → UI re-renders
```

---

**Step 8: Main Page (10 min)**

Update `app/page.tsx`:

```typescript
import { UserDirectory } from '@/components/UserDirectory';

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <UserDirectory />
    </main>
  );
}
```

**That's it! Run the app:**
```bash
npm run dev
# Visit http://localhost:3000
```

---

#### 2.2 Testing Your Implementation

**Manual Testing Checklist:**

- [ ] Page loads without errors
- [ ] Loading state shows while fetching
- [ ] 50 users display in grid
- [ ] Search input filters by first name (case-insensitive)
- [ ] Search input filters by last name (case-insensitive)
- [ ] Nationality dropdown shows unique nationalities (sorted)
- [ ] "All Nationalities" option works
- [ ] Filtering by nationality works
- [ ] Search + nationality filters work together
- [ ] Results count is accurate
- [ ] "No users found" shows when no matches
- [ ] Responsive layout works (mobile, tablet, desktop)
- [ ] Images load correctly
- [ ] Hover effects work

**Common Issues to Debug:**

```typescript
// Issue 1: "Cannot read property 'map' of undefined"
// Cause: Not checking if data exists before mapping
// Fix: Add loading/error checks OR optional chaining
{users?.map(...)}

// Issue 2: Filters not working
// Cause: Case-sensitive comparison
// Fix: Use .toLowerCase() on both sides
user.name.first.toLowerCase().includes(searchTerm.toLowerCase())

// Issue 3: Infinite re-renders
// Cause: Creating new objects/arrays in render
// Fix: Use useMemo for computed values

// Issue 4: Type errors
// Cause: Wrong interface definition
// Fix: Check actual API response, update types
```

---

### Phase 3: Advanced Features (Week 4)
**Goal: Add new features independently (especially favorites)**

#### 3.1 Favorites Feature - Deep Dive

**This is the feature you struggled with in the interview. Let's master it.**

**Requirements Analysis:**
1. User can mark/unmark users as favorites
2. Favorites persist across page reloads (localStorage)
3. Show a "Favorites" view/tab
4. Search/filter should work in favorites view too
5. Show count of favorites

**Step-by-Step Implementation:**

---

**Step 1: Planning (CRITICAL STEP)**

Before coding, answer these questions:
1. Where will favorite state live?
2. How to identify unique users? (email is unique)
3. How to persist to localStorage?
4. What components need to change?
5. What new components needed?

**Architecture Decision:**
```
Option A: Store full User objects in state
  Pros: Easy to use
  Cons: Duplicates data, sync issues

Option B: Store only user IDs (emails) in state ✅
  Pros: Single source of truth, efficient
  Cons: Need to filter users to get favorites

We'll use Option B.
```

---

**Step 2: Favorites Hook (30 min)**

Create `hooks/useFavorites.ts`:

```typescript
import { useState, useEffect } from 'react';
import { User } from '@/types/user';

const FAVORITES_STORAGE_KEY = 'user-directory-favorites';

export function useFavorites() {
  // State: array of user emails
  const [favoriteIds, setFavoriteIds] = useState<string[]>([]);

  // Load from localStorage on mount
  useEffect(() => {
    try {
      const stored = localStorage.getItem(FAVORITES_STORAGE_KEY);
      if (stored) {
        setFavoriteIds(JSON.parse(stored));
      }
    } catch (error) {
      console.error('Failed to load favorites:', error);
    }
  }, []);

  // Save to localStorage whenever favorites change
  useEffect(() => {
    try {
      localStorage.setItem(FAVORITES_STORAGE_KEY, JSON.stringify(favoriteIds));
    } catch (error) {
      console.error('Failed to save favorites:', error);
    }
  }, [favoriteIds]);

  // Check if a user is favorited
  const isFavorite = (user: User) => {
    return favoriteIds.includes(user.email);
  };

  // Toggle favorite status
  const toggleFavorite = (user: User) => {
    setFavoriteIds(prev => {
      if (prev.includes(user.email)) {
        // Remove from favorites
        return prev.filter(id => id !== user.email);
      } else {
        // Add to favorites
        return [...prev, user.email];
      }
    });
  };

  // Get actual favorite users from all users
  const getFavoriteUsers = (allUsers: User[] | undefined) => {
    if (!allUsers) return [];
    return allUsers.filter(user => favoriteIds.includes(user.email));
  };

  return {
    favoriteIds,
    isFavorite,
    toggleFavorite,
    getFavoriteUsers,
    favoriteCount: favoriteIds.length,
  };
}
```

**UNDERSTANDING THIS CODE:**

```typescript
// Why two useEffects?

// useEffect #1: Load from localStorage ONCE on mount
useEffect(() => {
  const stored = localStorage.getItem(...);
  setFavoriteIds(JSON.parse(stored));
}, []); // Empty deps = run once on mount

// useEffect #2: Save to localStorage WHENEVER favoriteIds changes
useEffect(() => {
  localStorage.setItem(..., JSON.stringify(favoriteIds));
}, [favoriteIds]); // Re-runs when favoriteIds changes

// Why this works:
// 1. Component mounts → Load from localStorage
// 2. User clicks favorite → toggleFavorite → setFavoriteIds → state updates
// 3. favoriteIds changed → useEffect #2 runs → saves to localStorage
// 4. Page reloads → useEffect #1 loads saved favorites

// Common mistake:
// Trying to save in toggleFavorite directly:
const toggleFavorite = (user: User) => {
  const newIds = [...favoriteIds, user.email];
  setFavoriteIds(newIds);
  localStorage.setItem(..., JSON.stringify(newIds)); // This works BUT...
  // State updates are async, so you might save old state
  // useEffect pattern is more reliable
};
```

---

**Step 3: Update UserCard Component (15 min)**

Modify `components/UserCard.tsx`:

```typescript
'use client';

import { User } from '@/types/user';

interface UserCardProps {
  user: User;
  isFavorite?: boolean;
  onToggleFavorite?: (user: User) => void;
}

export function UserCard({ user, isFavorite = false, onToggleFavorite }: UserCardProps) {
  return (
    <div className="
      bg-white
      rounded-lg
      shadow-md
      p-6
      hover:shadow-lg
      transition-shadow
      duration-200
      relative
    ">
      {/* Favorite button */}
      {onToggleFavorite && (
        <button
          onClick={() => onToggleFavorite(user)}
          className="
            absolute
            top-4
            right-4
            text-2xl
            transition-transform
            hover:scale-110
          "
          aria-label={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
        >
          {isFavorite ? '❤️' : '🤍'}
        </button>
      )}

      <div className="flex flex-col items-center">
        <img
          src={user.picture.large}
          alt={`${user.name.first} ${user.name.last}`}
          className="w-24 h-24 rounded-full mb-4"
        />

        <h3 className="text-xl font-semibold text-gray-900 mb-1">
          {user.name.first} {user.name.last}
        </h3>

        <p className="text-sm text-gray-500 mb-2">
          {user.email}
        </p>

        <span className="
          inline-block
          px-3 py-1
          bg-blue-100
          text-blue-800
          rounded-full
          text-xs
          font-medium
        ">
          {user.nat}
        </span>
      </div>
    </div>
  );
}
```

**DESIGN PATTERN: Optional Props**

```typescript
// The component can work with OR without favorites functionality

// Without favorites:
<UserCard user={user} />

// With favorites:
<UserCard
  user={user}
  isFavorite={isFavorite(user)}
  onToggleFavorite={toggleFavorite}
/>

// This is called "component flexibility"
// Same component, different use cases
```

---

**Step 4: Tab Navigation Component (20 min)**

Create `components/TabNavigation.tsx`:

```typescript
'use client';

type Tab = 'all' | 'favorites';

interface TabNavigationProps {
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
  favoriteCount: number;
}

export function TabNavigation({ activeTab, onTabChange, favoriteCount }: TabNavigationProps) {
  const tabs = [
    { id: 'all' as Tab, label: 'All Users' },
    { id: 'favorites' as Tab, label: `Favorites (${favoriteCount})` },
  ];

  return (
    <div className="flex space-x-4 mb-8 border-b border-gray-200">
      {tabs.map(tab => (
        <button
          key={tab.id}
          onClick={() => onTabChange(tab.id)}
          className={`
            px-4 py-2
            font-medium
            border-b-2
            transition-colors
            ${activeTab === tab.id
              ? 'border-blue-500 text-blue-600'
              : 'border-transparent text-gray-600 hover:text-gray-900'
            }
          `}
        >
          {tab.label}
        </button>
      ))}
    </div>
  );
}
```

---

**Step 5: Update UserDirectory Component (30 min)**

Major refactor of `components/UserDirectory.tsx`:

```typescript
'use client';

import { useState } from 'react';
import { useUsers } from '@/hooks/useUsers';
import { useUserFilter } from '@/hooks/useUserFilter';
import { useFavorites } from '@/hooks/useFavorites';
import { SearchInput } from './SearchInput';
import { NationalityFilter } from './NationalityFilter';
import { UserCard } from './UserCard';
import { TabNavigation } from './TabNavigation';

type Tab = 'all' | 'favorites';

export function UserDirectory() {
  const [activeTab, setActiveTab] = useState<Tab>('all');

  // Fetch users
  const { data: users, isLoading, isError, error } = useUsers();

  // Favorites
  const {
    isFavorite,
    toggleFavorite,
    getFavoriteUsers,
    favoriteCount,
  } = useFavorites();

  // Determine which users to show based on active tab
  const displayUsers = activeTab === 'all'
    ? users
    : getFavoriteUsers(users);

  // Filter logic (works on displayUsers)
  const {
    searchTerm,
    setSearchTerm,
    selectedNationality,
    setSelectedNationality,
    nationalities,
    filteredUsers,
  } = useUserFilter(displayUsers);

  // Loading state
  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl text-gray-600">Loading users...</div>
      </div>
    );
  }

  // Error state
  if (isError) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl text-red-600">
          Error: {error instanceof Error ? error.message : 'Failed to load users'}
        </div>
      </div>
    );
  }

  // Main UI
  return (
    <div className="container mx-auto px-4 py-8 max-w-7xl">
      <h1 className="text-4xl font-bold text-gray-900 mb-8 text-center">
        User Directory
      </h1>

      {/* Tab navigation */}
      <TabNavigation
        activeTab={activeTab}
        onTabChange={setActiveTab}
        favoriteCount={favoriteCount}
      />

      {/* Filters */}
      <div className="mb-8 grid grid-cols-1 md:grid-cols-2 gap-4">
        <SearchInput
          value={searchTerm}
          onChange={setSearchTerm}
        />
        <NationalityFilter
          value={selectedNationality}
          options={nationalities}
          onChange={setSelectedNationality}
        />
      </div>

      {/* Results count */}
      <div className="mb-4 text-gray-600">
        Showing {filteredUsers.length} of {displayUsers?.length || 0} users
      </div>

      {/* Empty states */}
      {activeTab === 'favorites' && favoriteCount === 0 ? (
        <div className="text-center text-gray-500 py-12">
          <p className="text-xl mb-2">No favorites yet</p>
          <p>Click the 🤍 icon on any user card to add them to your favorites</p>
        </div>
      ) : filteredUsers.length === 0 ? (
        <div className="text-center text-gray-500 py-12">
          No users found matching your criteria
        </div>
      ) : (
        // User grid
        <div className="
          grid
          grid-cols-1
          sm:grid-cols-2
          md:grid-cols-3
          lg:grid-cols-4
          gap-6
        ">
          {filteredUsers.map(user => (
            <UserCard
              key={user.email}
              user={user}
              isFavorite={isFavorite(user)}
              onToggleFavorite={toggleFavorite}
            />
          ))}
        </div>
      )}
    </div>
  );
}
```

**UNDERSTANDING THE FLOW:**

```typescript
// The key insight: displayUsers changes based on tab

// When activeTab === 'all':
displayUsers = users (all 50 users from API)

// When activeTab === 'favorites':
displayUsers = getFavoriteUsers(users) (only favorited users)

// Then useUserFilter works on displayUsers
// So search/filter work in BOTH tabs!

// Data flow:
1. User clicks "Favorites" tab
   ↓
2. setActiveTab('favorites')
   ↓
3. Component re-renders
   ↓
4. displayUsers = getFavoriteUsers(users)
   ↓
5. useUserFilter(displayUsers) filters favorites
   ↓
6. UI shows filtered favorites
```

---

**Step 6: Testing Favorites Feature**

**Test Checklist:**

- [ ] Click favorite button (🤍 → ❤️)
- [ ] Click again (❤️ → 🤍)
- [ ] Multiple favorites work
- [ ] Favorite count updates in tab label
- [ ] Switch to Favorites tab
- [ ] Only favorited users show
- [ ] Search works in Favorites tab
- [ ] Filter works in Favorites tab
- [ ] Reload page - favorites persist
- [ ] Clear localStorage - favorites clear

**How to test localStorage:**
```javascript
// Open browser console
// View favorites:
localStorage.getItem('user-directory-favorites')

// Clear favorites:
localStorage.removeItem('user-directory-favorites')

// Manually set favorites:
localStorage.setItem('user-directory-favorites', JSON.stringify(['email1@example.com', 'email2@example.com']))
```

---

**Debugging Favorites - Common Issues:**

```typescript
// Issue 1: Favorites don't persist after reload
// Cause: Not reading from localStorage on mount
// Debug: Check if useEffect with [] deps exists

// Issue 2: Favorites disappear when changing tabs
// Cause: State is lost because component unmounts
// Solution: State should be in parent or custom hook (✅ we did this)

// Issue 3: Can't unfavorite
// Cause: Wrong logic in toggleFavorite
// Debug: console.log in toggleFavorite to see state changes

// Issue 4: Favorites show on All Users tab too
// Cause: Not filtering by tab
// Debug: Check displayUsers logic

// Issue 5: Search doesn't work in Favorites
// Cause: useUserFilter is using wrong data
// Solution: Pass displayUsers, not users
```

---

#### 3.2 Bonus: Mock API Search (Optional)

**Requirement:** Simulate calling an API for search instead of client-side filtering

**Concept:**
```typescript
// Instead of:
const filtered = users.filter(u => u.name.first.includes(searchTerm));

// Simulate:
const filtered = await fetch(`/api/users/search?q=${searchTerm}`);
```

**Implementation with Debouncing:**

Create `hooks/useUserSearch.ts`:

```typescript
import { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';
import { User } from '@/types/user';

// Mock API function (simulates network delay)
async function searchUsers(query: string, nationality: string): Promise<User[]> {
  // Simulate network delay
  await new Promise(resolve => setTimeout(resolve, 300));

  // In real world, this would be:
  // const response = await fetch(`/api/users/search?q=${query}&nat=${nationality}`);
  // return response.json();

  // For now, we'd do client-side filtering
  // (In interview, you can explain this is where API call would go)

  return []; // Placeholder
}

export function useUserSearch(allUsers: User[] | undefined) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedNationality, setSelectedNationality] = useState('all');
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState('');

  // Debounce search term (wait 300ms after user stops typing)
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearchTerm(searchTerm);
    }, 300);

    return () => clearTimeout(timer);
  }, [searchTerm]);

  // Query for search results
  const { data: searchResults, isLoading: isSearching } = useQuery({
    queryKey: ['userSearch', debouncedSearchTerm, selectedNationality],
    queryFn: () => searchUsers(debouncedSearchTerm, selectedNationality),
    enabled: debouncedSearchTerm.length > 0, // Only search if there's a term
  });

  // Return all users if no search term, otherwise search results
  const displayUsers = debouncedSearchTerm.length > 0
    ? searchResults
    : allUsers;

  return {
    searchTerm,
    setSearchTerm,
    selectedNationality,
    setSelectedNationality,
    displayUsers,
    isSearching,
  };
}
```

**Key Concepts:**

1. **Debouncing**: Wait for user to stop typing before searching
2. **Loading state**: Show loading while searching
3. **Query key includes search params**: Different searches = different cache entries
4. **Enabled option**: Don't search if query is empty

**In Interview, You Can Explain:**

"In a real application, I would:
1. Create an API endpoint that accepts search parameters
2. Use debouncing to avoid too many API calls
3. Show loading state while searching
4. Cache results with React Query
5. Handle errors appropriately
6. Maybe implement server-side pagination for large datasets"

---

### Phase 4: Debugging Skills (Week 5)
**Goal: Understand and debug code confidently**

#### 4.1 Debugging Toolkit

**Tool 1: React DevTools**

```bash
# Install React DevTools browser extension
# Chrome: https://chrome.google.com/webstore/detail/react-developer-tools/
# Firefox: https://addons.mozilla.org/en-US/firefox/addon/react-devtools/
```

**How to use:**
1. Open DevTools (F12)
2. Click "Components" tab
3. Inspect component tree
4. View props and state in real-time
5. Click on component to find it in code

**Debugging with React DevTools:**
```
Problem: "Why isn't my search working?"

Steps:
1. Open React DevTools
2. Find UserDirectory component
3. Check state:
   - searchTerm: "john" ✓
   - filteredUsers: [50 users] ✗ (should be filtered!)
4. Ah! Filter logic isn't running
5. Check useUserFilter dependencies
```

---

**Tool 2: TanStack Query DevTools**

Already installed when you added:
```typescript
<ReactQueryDevtools initialIsOpen={false} />
```

**How to use:**
1. Look for flower icon in bottom corner of page
2. Click to open
3. See all queries, their status, and data

**Debugging with Query DevTools:**
```
Problem: "Users aren't loading"

Steps:
1. Open Query DevTools
2. Find ['users'] query
3. Check status:
   - Status: error ✗
   - Error: "Failed to fetch"
4. Ah! Network error
5. Check if API is accessible
```

---

**Tool 3: Strategic console.log**

**Good logging strategy:**

```typescript
// Bad: Random logs everywhere
console.log('here');
console.log('data', data);

// Good: Structured, informative logs
console.log('[UserDirectory] Rendering with:', {
  searchTerm,
  selectedNationality,
  userCount: users?.length,
  filteredCount: filteredUsers.length,
});

// Even better: Use labels
console.group('Filter Update');
console.log('Search term:', searchTerm);
console.log('Nationality:', selectedNationality);
console.log('Filtered users:', filteredUsers);
console.groupEnd();
```

**Tracing data flow:**
```typescript
// Add logs at each step of the flow
export function useUserFilter(users: User[] | undefined) {
  console.log('[useUserFilter] Input users:', users?.length);

  const filteredUsers = useMemo(() => {
    console.log('[useUserFilter] Running filter with:', { searchTerm, selectedNationality });
    const result = users?.filter(...);
    console.log('[useUserFilter] Filtered result:', result.length);
    return result;
  }, [users, searchTerm, selectedNationality]);

  return { filteredUsers };
}

// Now you can trace: Input → Filter Logic → Output
```

---

**Tool 4: Breakpoint Debugging**

**In VS Code:**
1. Click in gutter next to line number (red dot appears)
2. Start debugging (F5)
3. Code pauses at breakpoint
4. Hover over variables to see values
5. Step through code line by line

**When to use:**
- Complex logic you need to step through
- Inspecting object structures
- Understanding async behavior

---

#### 4.2 Common Issues & How to Debug Them

**Issue 1: Component not re-rendering**

```typescript
// Symptom: Change state, but UI doesn't update

// Debugging steps:
1. Add console.log to see if component re-renders
   console.log('[UserCard] Rendering');

2. Check if state is actually changing
   console.log('State updated:', newState);

3. Check if you're mutating state directly (DON'T DO THIS)
   // Wrong:
   users.push(newUser); // Mutates array!
   setUsers(users); // React sees same reference, no re-render

   // Right:
   setUsers([...users, newUser]); // New array reference

// Common cause: Mutating objects/arrays instead of creating new ones
```

---

**Issue 2: Infinite re-renders**

```typescript
// Symptom: Browser freezes, "Maximum update depth exceeded" error

// Cause 1: setState in render body
function Component() {
  const [count, setCount] = useState(0);
  setCount(count + 1); // ❌ Runs on every render → causes re-render → infinite loop
  return <div>{count}</div>;
}

// Fix: Move to event handler or useEffect
function Component() {
  const [count, setCount] = useState(0);
  const handleClick = () => setCount(count + 1); // ✅
  return <button onClick={handleClick}>{count}</button>;
}

// Cause 2: Missing dependencies in useMemo/useCallback
const filteredUsers = useMemo(() => {
  return users.filter(/* uses searchTerm */);
}, []); // ❌ Missing searchTerm dependency

// Fix:
const filteredUsers = useMemo(() => {
  return users.filter(/* uses searchTerm */);
}, [users, searchTerm]); // ✅

// Debugging:
1. Check browser console for error
2. Look for setState calls in render
3. Check useEffect/useMemo dependencies
4. Add console.log to see render count
```

---

**Issue 3: TypeScript errors**

```typescript
// Error: "Property 'name' does not exist on type 'User'"

// Debugging steps:
1. Check the actual API response
   console.log('API response:', data);

2. Compare with your type definition
   interface User {
     name: string; // ❌ Actually an object!
   }

3. Fix the type
   interface User {
     name: {
       first: string;
       last: string;
     };
   }

// Error: "Argument of type 'User | undefined' is not assignable..."

// Cause: Didn't check if value exists
function displayUser(user: User | undefined) {
  return <div>{user.name.first}</div>; // ❌ user might be undefined
}

// Fix: Add check
function displayUser(user: User | undefined) {
  if (!user) return null; // ✅
  return <div>{user.name.first}</div>;
}

// Or use optional chaining:
return <div>{user?.name.first}</div>; // ✅
```

---

**Issue 4: useEffect running too often**

```typescript
// Symptom: API called repeatedly, performance issues

// Cause: Wrong dependencies
useEffect(() => {
  fetchUsers();
}, [filters]); // ❌ If filters is an object created in render, it's new every time

// Debugging:
1. Add log to see how often it runs
   useEffect(() => {
     console.log('Effect running');
     fetchUsers();
   }, [filters]);

2. Check dependencies - are they stable?
   // Problem:
   const filters = { search: searchTerm, nat: nationality }; // New object every render!
   useEffect(() => {
     fetchUsers(filters);
   }, [filters]); // Runs every render

   // Fix: Depend on primitive values
   useEffect(() => {
     fetchUsers({ search: searchTerm, nat: nationality });
   }, [searchTerm, nationality]); // ✅
```

---

**Issue 5: State not updating**

```typescript
// Symptom: Click button, nothing happens

// Debugging:
1. Check if event handler is called
   const handleClick = () => {
     console.log('Button clicked'); // Add this
     setCount(count + 1);
   };

2. Check if setState is called
   const handleClick = () => {
     console.log('Before:', count);
     setCount(count + 1);
     console.log('After:', count); // Still old value! (state updates are async)
   };

3. Check if state value is actually changing
   const handleClick = () => {
     const newValue = count + 1;
     console.log('Setting to:', newValue);
     setCount(newValue);
   };

// Common cause: State closure issue
users.map(user => (
  <button onClick={() => setSelected(user)}>
    {/* ❌ If user changes, closure holds old value */}
  </button>
));

// Fix: Use functional update
<button onClick={() => setSelected(prevUser => user)}>
```

---

#### 4.3 Reading & Understanding Code

**Exercise: Read someone else's implementation**

1. Find another implementation of this project on GitHub
2. For each file, answer:
   - What is this component's responsibility?
   - What props does it receive?
   - What state does it manage?
   - How does data flow through it?

**Code Reading Checklist:**

```typescript
// When reading a component:

1. Read the interface/props first
   interface UserCardProps { ... }

2. Identify state
   const [search, setSearch] = useState('');

3. Identify effects
   useEffect(() => { ... }, [deps]);

4. Trace data flow
   props → state → computed values → render

5. Find event handlers
   const handleClick = () => { ... }

6. Understand return/JSX
   What UI does this render?
```

**Practice: Explain this code line by line**

```typescript
const { data: users, isLoading } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
});

const filteredUsers = useMemo(() => {
  return users?.filter(u =>
    u.name.first.toLowerCase().includes(searchTerm.toLowerCase())
  ) || [];
}, [users, searchTerm]);

return (
  <div>
    {isLoading ? (
      <div>Loading...</div>
    ) : (
      filteredUsers.map(user => <UserCard key={user.email} user={user} />)
    )}
  </div>
);
```

**Explanation practice:**
1. Line 1: Destructuring useQuery result, renaming 'data' to 'users'
2. Line 2: Query key for caching
3. Line 3: Function to fetch data
4. Line 6-10: Memoized computation that filters users by search term
5. ... (continue for each line)

---

### Phase 5: Speed & Confidence (Week 6)
**Goal: Build fast under interview pressure**

#### 5.1 Timed Builds

**Build Challenge 1: Basic Version (60 minutes)**

Timer starts NOW:
- [ ] Create Next.js project (5 min)
- [ ] Install dependencies (2 min)
- [ ] Setup types (8 min)
- [ ] Setup React Query (8 min)
- [ ] Create useUsers hook (7 min)
- [ ] Create UserCard component (10 min)
- [ ] Create basic UserDirectory (10 min)
- [ ] Test and fix bugs (10 min)

**What you should have:**
- Users fetching and displaying
- Basic grid layout
- No search/filter yet

---

**Build Challenge 2: With Search & Filter (90 minutes)**

Start from Challenge 1 result:
- [ ] Create SearchInput component (10 min)
- [ ] Create NationalityFilter component (10 min)
- [ ] Create useUserFilter hook (15 min)
- [ ] Integrate into UserDirectory (10 min)
- [ ] Style everything nicely (15 min)
- [ ] Test thoroughly (15 min)
- [ ] Fix any bugs (15 min)

**What you should have:**
- Everything from Challenge 1
- Search by name working
- Filter by nationality working
- Responsive design

---

**Build Challenge 3: Add Favorites (120 minutes)**

Start from Challenge 2 result:
- [ ] Create useFavorites hook (20 min)
- [ ] Add favorite button to UserCard (10 min)
- [ ] Create TabNavigation component (15 min)
- [ ] Integrate favorites into UserDirectory (20 min)
- [ ] Test localStorage persistence (10 min)
- [ ] Test all features together (15 min)
- [ ] Polish UI and fix bugs (30 min)

**What you should have:**
- Complete application
- All features working
- Clean, understandable code

---

#### 5.2 Interview Simulation

**Setup:**
1. Find a friend or use a rubber duck
2. Set timer for 90 minutes
3. Explain your code out loud as you write
4. Don't use AI assistance

**Scenario:**
"Build a user directory that fetches 50 users from randomuser.me API and allows searching by name and filtering by nationality."

**Evaluation criteria:**
- [ ] Completes basic requirements in time
- [ ] Code is clean and organized
- [ ] Can explain decisions
- [ ] Handles errors gracefully
- [ ] Types are correct
- [ ] UI is functional (doesn't need to be beautiful)

---

**Add: Deliberate Bugs Exercise**

Take your working code and introduce bugs:

```typescript
// Bug 1: Remove type
const users = useUsers(); // Remove type annotation
// Can you fix the downstream errors?

// Bug 2: Mutate state
const handleAdd = () => {
  users.push(newUser); // Direct mutation
  setUsers(users);
};
// Why doesn't this work? How to fix?

// Bug 3: Missing dependency
useEffect(() => {
  filterUsers(searchTerm);
}, []); // Missing dependency
// What happens? How to fix?

// Bug 4: Wrong comparison
if (user.nat == 'US') { // == instead of ===
// When does this break?

// Bug 5: Async state
const handleClick = () => {
  setCount(count + 1);
  console.log(count); // Prints old value
};
// Why? How to see new value?
```

Practice finding and fixing each bug in under 5 minutes.

---

#### 5.3 Code Review Practice

**Review your own code:**

```typescript
// Questions to ask:

1. Readability
   - Are variable names clear?
   - Is the code self-documenting?
   - Do I need comments?

2. Type Safety
   - Are all functions properly typed?
   - Am I using 'any' anywhere? (avoid!)
   - Are props interfaces complete?

3. Performance
   - Am I filtering on every render? (use useMemo)
   - Am I creating functions in render? (use useCallback if passed to children)
   - Are there unnecessary re-renders?

4. Error Handling
   - What if the API fails?
   - What if there's no data?
   - What if user input is unexpected?

5. Accessibility
   - Do buttons have aria-labels?
   - Do images have alt text?
   - Can I navigate with keyboard?

6. Code Organization
   - Are components single-responsibility?
   - Is logic extracted into hooks?
   - Is the file structure clear?
```

**Refactoring checklist:**

- [ ] Extract magic numbers to constants
- [ ] Extract repeated JSX to components
- [ ] Extract complex logic to functions
- [ ] Add loading and error states
- [ ] Add TypeScript to all functions
- [ ] Remove unused imports
- [ ] Remove console.logs
- [ ] Add comments to complex parts

---

### Phase 6: Study Plan & Daily Routine

#### Week-by-Week Breakdown

**Week 1-2: Foundations**
- Day 1-2: TypeScript (2-3 hours)
- Day 3-4: React fundamentals (2-3 hours)
- Day 5-6: TanStack Query (2-3 hours)
- Day 7-8: Tailwind CSS (2-3 hours)
- Day 9-10: Next.js setup (2-3 hours)
- Day 11-12: Build simple practice projects
- Day 13-14: Review and solidify understanding

**Week 3: Integration**
- Day 15: Build #1 (follow tutorial, 4-6 hours)
- Day 16: Review Build #1, understand every line
- Day 17: Build #2 (with reference, 3-4 hours)
- Day 18: Review Build #2, note differences
- Day 19: Build #3 (from memory, 2-3 hours)
- Day 20: Compare all three builds
- Day 21: Rest day, review notes

**Week 4: Advanced Features**
- Day 22-23: Plan favorites feature (2 hours)
- Day 24-25: Implement favorites (4 hours)
- Day 26: Test and debug favorites
- Day 27: Add mock API search (bonus)
- Day 28: Code review and refactor

**Week 5: Debugging Skills**
- Day 29: Setup and learn DevTools (2 hours)
- Day 30-31: Introduce bugs and fix them (3 hours)
- Day 32: Read others' code (2 hours)
- Day 33-34: Debug without AI help (3 hours)
- Day 35: Review common issues

**Week 6: Speed & Confidence**
- Day 36: Timed Build #1 - 60 min basic
- Day 37: Timed Build #2 - 90 min with search
- Day 38: Timed Build #3 - 120 min with favorites
- Day 39: Mock interview with friend
- Day 40: Full build with explanations
- Day 41: Final review and practice
- Day 42: Rest and mental preparation

---

#### Daily Routine (60 minutes)

**Daily Micro-Practice (when short on time):**

**Option A: Speed Drill (20 min)**
```
1. Set timer for 15 minutes
2. Build one component from scratch
   - Day 1: UserCard
   - Day 2: SearchInput
   - Day 3: NationalityFilter
   - Day 4: UserDirectory
   - Day 5: Full integration
3. Reset, do it again faster
```

**Option B: Concept Deep-Dive (30 min)**
```
Pick one concept each day:
- Monday: useState and re-renders
- Tuesday: useEffect dependencies
- Wednesday: useMemo and useCallback
- Thursday: React Query states
- Friday: TypeScript generics
- Saturday: Custom hooks
- Sunday: Review week
```

**Option C: Debug Practice (20 min)**
```
1. Take working code
2. Introduce 3 deliberate bugs
3. Set timer for 15 minutes
4. Fix all bugs
5. Analyze what took longest
```

---

### Understanding AI-Generated Code

**Why you struggled with AI code in the interview:**

1. **No mental model**: AI gives you code, but not understanding
2. **Can't debug**: If it breaks, you don't know why
3. **Can't modify**: Hard to add features to code you don't understand
4. **Interview pressure**: No time to figure it out

**How to use AI as a learning tool:**

```typescript
// ❌ Bad: Copy-paste without understanding
// Ask AI: "Write a user filter component"
// Copy entire response
// Hope it works

// ✅ Good: Use AI to explain, then write yourself
// 1. Ask AI: "Explain how to filter an array by multiple criteria"
// 2. Read explanation
// 3. Try writing it yourself
// 4. If stuck, ask specific questions
// 5. Ask AI to review your code

// ❌ Bad: Let AI debug for you
// Give AI your broken code
// Ask: "Fix this"
// Get back working code
// Still don't know what was wrong

// ✅ Good: Use AI to understand the error
// 1. Look at error message
// 2. Try to fix it yourself
// 3. If stuck, ask AI: "What does this error mean?"
// 4. Apply the learning
// 5. Fix it yourself
```

**Reading AI Code Checklist:**

When AI gives you code:

1. **Before running it:**
   - Read through line by line
   - Identify parts you don't understand
   - Look up unfamiliar concepts

2. **While reading:**
   - What types are used?
   - What state is managed?
   - How does data flow?
   - What are the dependencies?

3. **After understanding:**
   - Rewrite it in your own style
   - Add comments explaining why
   - Test edge cases

4. **Make it yours:**
   - Change variable names to be clearer
   - Reorganize if needed
   - Extract to helper functions
   - Add error handling

---

### Interview Day Strategy

**1 hour before interview:**
- Don't cram
- Review your notes summary
- Do one quick 15-min component build
- Relax

**During interview:**

**Phase 1: Clarify (5 min)**
- Ask about requirements
- Confirm which features are priorities
- Ask about styling expectations
- Ask if using specific libraries is allowed

**Phase 2: Plan (5 min)**
- Write down feature list
- Sketch component structure
- Decide on state management approach
- Don't skip this!

**Phase 3: Setup (5 min)**
- Create project
- Install dependencies
- Setup basic structure

**Phase 4: Core Features (45 min)**
- Start with data fetching
- Then display
- Then basic functionality
- Test as you go

**Phase 5: Additional Features (20 min)**
- Add search
- Add filter
- Make responsive

**Phase 6: Polish (10 min)**
- Fix obvious bugs
- Add loading states
- Clean up code

**Phase 7: Review (10 min)**
- Test all features
- Check for errors
- Prepare to explain

---

### Common Interview Questions & Answers

**Q: "Why use React Query instead of useEffect?"**
A: React Query handles caching, loading states, error states, and refetching automatically. With useEffect, I'd have to manage all of that manually. It also prevents race conditions and provides better developer experience with DevTools.

**Q: "Why use useMemo for filtering?"**
A: Filtering is a relatively expensive operation that would run on every render. useMemo ensures it only recalculates when dependencies (users, searchTerm, selectedNationality) change, improving performance.

**Q: "How would you test this component?"**
A: I'd write tests for:
- Rendering with different states (loading, error, success)
- Search functionality (filters correctly, case-insensitive)
- Nationality filter (filters correctly, no duplicates)
- User interactions (clicking favorite, changing filters)
- Edge cases (empty results, no data)

**Q: "How would you improve performance with thousands of users?"**
A:
- Implement virtual scrolling (react-window)
- Add pagination
- Move search to server-side
- Add debouncing to search (already did this)
- Use useTransition for non-urgent updates

**Q: "What would you do differently for production?"**
A:
- Add comprehensive error boundaries
- Add analytics/logging
- Implement proper error handling
- Add loading skeletons instead of simple "Loading..."
- Add tests
- Add accessibility features
- Optimize images
- Add proper SEO

---

### Final Checklist: Are You Ready?

**Technical Skills:**
- [ ] Can create Next.js project from scratch in 5 minutes
- [ ] Can define TypeScript interfaces without looking
- [ ] Can setup React Query without reference
- [ ] Can build responsive UI with Tailwind
- [ ] Can create custom hooks
- [ ] Can implement search/filter logic
- [ ] Can add localStorage persistence
- [ ] Can debug common React errors
- [ ] Can read and understand others' code
- [ ] Can explain every line of code you write

**Speed:**
- [ ] Can build basic version in 60 minutes
- [ ] Can add search/filter in 30 minutes
- [ ] Can add favorites feature in 30 minutes
- [ ] Can debug most issues in under 10 minutes

**Understanding:**
- [ ] Can explain why re-renders happen
- [ ] Can explain how React Query caching works
- [ ] Can explain useEffect dependencies
- [ ] Can explain the difference between useMemo and useCallback
- [ ] Can explain your state management decisions

**Interview Readiness:**
- [ ] Can work without AI assistance
- [ ] Can explain code while writing
- [ ] Can debug under pressure
- [ ] Can prioritize features
- [ ] Can manage time effectively

---

### Resources

**Official Documentation:**
- [React Docs](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [TanStack Query Docs](https://tanstack.com/query)
- [Tailwind CSS Docs](https://tailwindcss.com/docs)
- [Next.js Docs](https://nextjs.org/docs)

**Practice APIs:**
- [Random User API](https://randomuser.me/) (what you'll use)
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) (more practice)
- [Dog API](https://dog.ceo/dog-api/) (different data structure)

**Code Examples:**
- Search GitHub for "react user directory"
- Look for similar projects
- Read other people's implementations
- Don't copy, understand

**Debugging Tools:**
- React DevTools (browser extension)
- TanStack Query DevTools (built-in)
- Chrome DevTools (Console, Network, Sources)
- VS Code Debugger

---

### Success Metrics

**After Week 2:**
- ✅ Understand each technology independently
- ✅ Can build simple examples with each
- ✅ Can explain core concepts

**After Week 3:**
- ✅ Built complete project 3 times
- ✅ Can build basic version in under 2 hours
- ✅ Understand data flow completely

**After Week 4:**
- ✅ Favorites feature working perfectly
- ✅ Can add new features independently
- ✅ Code is clean and organized

**After Week 5:**
- ✅ Can debug without AI help
- ✅ Can read and understand others' code
- ✅ Can explain common issues

**After Week 6:**
- ✅ Can complete interview challenge in time
- ✅ Can explain decisions confidently
- ✅ Ready for interview!

---

## Your Action Plan

### This Week (Week 1):
1. **Today**: Read this guide completely
2. **Days 1-2**: TypeScript fundamentals + exercises
3. **Days 3-4**: React fundamentals + small project
4. **Days 5-6**: TanStack Query + API fetching
5. **Day 7**: Review and practice

### Next Week (Week 2):
1. **Days 8-9**: Tailwind CSS styling
2. **Days 10-11**: Next.js setup and structure
3. **Days 12-13**: Build simple projects with each technology
4. **Day 14**: Full stack integration test

### Weeks 3-6:
Follow the detailed phase plans above.

---

## Remember

1. **Understanding > Speed**: Speed comes with understanding
2. **Build, don't copy**: Type every line yourself
3. **Break things**: Best way to learn is to fix what you broke
4. **Explain out loud**: If you can't explain it, you don't understand it
5. **No AI during practice**: AI in interview got you stuck, practice without it
6. **Small steps**: Master one thing before combining
7. **Debug systematically**: Use tools, not guessing
8. **Review constantly**: What did I just learn? Why did it work?

---

## The Real Reason You Failed

It wasn't AI's fault. It was relying on AI without understanding.

**The AI gave you:**
- Working code
- Fast results
- Completed features

**But AI didn't give you:**
- Understanding of how it works
- Ability to debug when it breaks
- Confidence to modify it
- Foundation to build on

**This time:**
- Build everything yourself
- Understand every line
- Make mistakes and fix them
- Develop the mental model

**Result:**
- You'll know what the AI would generate
- You'll understand why it works
- You'll be able to debug it
- You'll be able to extend it
- You'll be confident in the interview

---

## Final Motivation

You already know this is possible. You were in an interview, you had the tools, you just needed the foundation.

Now you're building that foundation.

6 weeks from now, you'll:
- Build the entire project from memory
- Add features independently
- Debug confidently
- Explain your decisions
- Pass the interview

**Not because you memorized code.**

**Because you understand how it works.**

Start Week 1 today. In 6 weeks, you'll ace that interview.

---

Good luck! You've got this! 🚀

