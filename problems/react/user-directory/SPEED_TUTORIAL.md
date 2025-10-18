# User Directory - Speed Build Tutorial

**Goal:** Build a working user directory in 35 minutes following the interview speed strategy.

**What you'll learn:**
- How to build fast under pressure
- What to prioritize vs. what to skip
- How working code beats perfect code in interviews

---

## Timeline Overview

- **0-5 min:** Project setup
- **5-15 min:** Types + Data layer
- **15-35 min:** Working UI (everything in one component)
- **35 min:** TEST everything works
- **35-50 min:** Refine (extract components, add favorites)

---

# Phase 0: Project Setup (0-5 min)

## Step 1: Create Next.js Project

```bash
npx create-next-app@latest user-directory --typescript --tailwind --app --no-src
```

When prompted, select:
- TypeScript: **Yes**
- ESLint: **Yes**
- Tailwind CSS: **Yes**
- `src/` directory: **No**
- App Router: **Yes**
- Import alias: **No** (or keep default @/*)

**Expected:** Project created in `user-directory/` folder

---

## Step 2: Navigate and Install Dependencies

```bash
cd user-directory
npm install @tanstack/react-query
```

**Expected:** React Query installed successfully

---

## Step 3: Verify Setup Works

```bash
npm run dev
```

**Expected:**
- Dev server starts at http://localhost:3000
- See default Next.js page
- No errors in terminal

**✓ Checkpoint:** Dev server running, no errors

---

# Phase 1: Types + Data Layer (5-15 min)

## Step 4: Create Types (2 min)

Create file: `types/index.ts`

```typescript
// types/index.ts

export interface User {
  id: string;
  email: string;
  name: {
    first: string;
    last: string;
    full: string;
  };
  picture: {
    large: string;
  };
  nationality: string;
}
```

**What you're doing:** Creating a simple User type with just the fields we need.

**What to say if this were an interview:**
> "I'm creating a User type with just the fields I need. In production I'd also create separate API response types and transformer functions for better boundary separation, but for now I'm prioritizing speed."

---

## Step 5: Create API Function (3 min)

Create file: `lib/api.ts`

```typescript
// lib/api.ts

import { User } from '@/types';

export async function fetchUsers(): Promise<User[]> {
  const response = await fetch('https://randomuser.me/api/?results=50');

  if (!response.ok) {
    throw new Error('Failed to fetch users');
  }

  const data = await response.json();

  // Transform API data inline
  return data.results.map((apiUser: any) => ({
    id: apiUser.email,
    email: apiUser.email,
    name: {
      first: apiUser.name.first,
      last: apiUser.name.last,
      full: `${apiUser.name.first} ${apiUser.name.last}`,
    },
    picture: {
      large: apiUser.picture.large,
    },
    nationality: apiUser.nat,
  }));
}
```

**What you're doing:** Fetching from API and transforming data inline.

**What to say:**
> "I'm transforming API data inline here with any type. In production I'd add runtime validation with zod, create proper API types, and handle edge cases. But this gets us moving quickly."

---

## Step 6: Create useUsers Hook (2 min)

Create file: `hooks/useUsers.ts`

```typescript
// hooks/useUsers.ts

import { useQuery } from '@tanstack/react-query';
import { fetchUsers } from '@/lib/api';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  });
}
```

**What you're doing:** Creating a simple hook that uses React Query.

**What to say:**
> "Using React Query for server state. This gives us caching, loading states, and refetching for free."

---

## Step 7: Setup Providers (3 min)

Create file: `app/providers.tsx`

```typescript
// app/providers.tsx

'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useState } from 'react';

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient());

  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
}
```

**What you're doing:** Setting up React Query provider.

---

## Step 8: Update Root Layout

Edit file: `app/layout.tsx`

Replace the entire file with:

```typescript
// app/layout.tsx

import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'User Directory',
  description: 'Search and filter users',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

**✓ Checkpoint:** Types and data layer ready

---

# Phase 2: Working UI - Everything in One Component (15-35 min)

## Step 9: Create UserDirectory Component (20 min)

Create file: `components/UserDirectory.tsx`

Copy this entire file:

```typescript
// components/UserDirectory.tsx

'use client';

import { useState, useMemo } from 'react';
import { useUsers } from '@/hooks/useUsers';

export function UserDirectory() {
  const { data: users, isLoading, isError } = useUsers();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedNationality, setSelectedNationality] = useState('all');

  // Filter logic INLINE - don't extract to custom hook yet
  const filteredUsers = useMemo(() => {
    if (!users) return [];

    return users.filter(user => {
      // Check if user matches search term (first or last name)
      const matchesSearch = user.name.full
        .toLowerCase()
        .includes(searchTerm.toLowerCase());

      // Check if user matches selected nationality
      const matchesNationality =
        selectedNationality === 'all' ||
        user.nationality === selectedNationality;

      // Both conditions must be true (AND logic)
      return matchesSearch && matchesNationality;
    });
  }, [users, searchTerm, selectedNationality]);

  // Get unique nationalities INLINE
  const nationalities = useMemo(() => {
    if (!users) return [];
    const unique = [...new Set(users.map(u => u.nationality))];
    return unique.sort();
  }, [users]);

  // Loading state
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-xl text-gray-600">Loading users...</div>
      </div>
    );
  }

  // Error state
  if (isError) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-xl text-red-600">
          Failed to load users. Please refresh the page.
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Header */}
      <h1 className="text-4xl font-bold mb-8">User Directory</h1>

      {/* Filters - INLINE, not separate components yet */}
      <div className="mb-6 flex flex-col sm:flex-row gap-4">
        {/* Search Input */}
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Search by name..."
          className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        />

        {/* Nationality Filter */}
        <select
          value={selectedNationality}
          onChange={(e) => setSelectedNationality(e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="all">All Nationalities</option>
          {nationalities.map(nat => (
            <option key={nat} value={nat}>
              {nat.toUpperCase()}
            </option>
          ))}
        </select>
      </div>

      {/* Results Count */}
      <div className="mb-4 text-gray-600">
        Showing {filteredUsers.length} of {users?.length || 0} users
      </div>

      {/* User Grid - Cards INLINE, not separate component yet */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {filteredUsers.map(user => (
          <div
            key={user.id}
            className="border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow"
          >
            {/* User Image */}
            <img
              src={user.picture.large}
              alt={user.name.full}
              className="w-24 h-24 rounded-full mx-auto mb-4 object-cover"
            />

            {/* User Name */}
            <h3 className="font-semibold text-lg text-center mb-2">
              {user.name.full}
            </h3>

            {/* User Email */}
            <p className="text-gray-600 text-center text-sm mb-2 break-all">
              {user.email}
            </p>

            {/* User Nationality */}
            <p className="text-gray-500 text-center text-xs">
              <span className="inline-block bg-gray-100 px-3 py-1 rounded-full">
                {user.nationality.toUpperCase()}
              </span>
            </p>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {filteredUsers.length === 0 && (
        <div className="text-center py-12">
          <p className="text-xl text-gray-600 mb-2">No users found</p>
          <p className="text-gray-500">
            Try adjusting your search or filter criteria
          </p>
          <button
            onClick={() => {
              setSearchTerm('');
              setSelectedNationality('all');
            }}
            className="mt-4 px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
          >
            Clear Filters
          </button>
        </div>
      )}
    </div>
  );
}
```

**What you're doing:** Building the entire UI in one component with everything inline.

**What to say:**
> "I'm building everything in one component first to establish the data flow quickly. The filter logic is inline with useMemo so it only recalculates when dependencies change. Once this works, I'll extract UserCard and other components."

---

## Step 10: Update Homepage

Edit file: `app/page.tsx`

Replace entire file with:

```typescript
// app/page.tsx

import { UserDirectory } from '@/components/UserDirectory';

export default function Home() {
  return <UserDirectory />;
}
```

**✓ Checkpoint:** Save all files and check http://localhost:3000

---

## Step 11: TEST EVERYTHING (Minute 35 - CRITICAL)

**STOP coding. Manual test:**

1. **Page loads:** ✓ Should see users in a grid
2. **Search works:**
   - Type "john" - should filter
   - Type "JOHN" - should still work (case-insensitive)
   - Clear search - should show all users
3. **Filter works:**
   - Select a nationality - should filter
   - Select "All" - should show all users
4. **Both together:**
   - Search for a name AND select a nationality
   - Should show users matching BOTH criteria
5. **Empty state:**
   - Search for "xyz123" - should show "No users found"
   - Click "Clear Filters" - should reset
6. **Responsive:**
   - Resize browser - grid should adjust columns

**If ANY of these fail, DEBUG NOW before proceeding.**

**✓ Checkpoint:** All core features working

---

# Phase 3: Refinement (35-50 min)

You have 15 minutes. Pick ONE thing to improve:
- **Option A:** Extract UserCard component (cleaner code)
- **Option B:** Add favorites feature (more features)

Let's do Option A first (5 min), then Option B if time permits (10 min).

---

## Step 12: Extract UserCard Component (5 min)

Create file: `components/UserCard.tsx`

```typescript
// components/UserCard.tsx

import { User } from '@/types';

interface UserCardProps {
  user: User;
}

export function UserCard({ user }: UserCardProps) {
  return (
    <div className="border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow">
      {/* User Image */}
      <img
        src={user.picture.large}
        alt={user.name.full}
        className="w-24 h-24 rounded-full mx-auto mb-4 object-cover"
      />

      {/* User Name */}
      <h3 className="font-semibold text-lg text-center mb-2">
        {user.name.full}
      </h3>

      {/* User Email */}
      <p className="text-gray-600 text-center text-sm mb-2 break-all">
        {user.email}
      </p>

      {/* User Nationality */}
      <p className="text-gray-500 text-center text-xs">
        <span className="inline-block bg-gray-100 px-3 py-1 rounded-full">
          {user.nationality.toUpperCase()}
        </span>
      </p>
    </div>
  );
}
```

---

## Step 13: Update UserDirectory to Use UserCard

Edit `components/UserDirectory.tsx`

**Find this section (around line 73):**

```typescript
{filteredUsers.map(user => (
  <div
    key={user.id}
    className="border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow"
  >
    {/* ... all the user card content ... */}
  </div>
))}
```

**Replace it with:**

```typescript
{filteredUsers.map(user => (
  <UserCard key={user.id} user={user} />
))}
```

**And add the import at the top:**

```typescript
import { UserCard } from './UserCard';
```

**What to say:**
> "Now that the core works, I'm extracting UserCard as a presentational component. This makes it reusable and easier to test in isolation."

**✓ Checkpoint:** Page still works, code is cleaner

---

## Step 14: Add Favorites Feature (10 min) - Optional

Create file: `hooks/useFavorites.ts`

```typescript
// hooks/useFavorites.ts

import { useState, useEffect } from 'react';

const STORAGE_KEY = 'user-favorites';

export function useFavorites() {
  const [favoriteIds, setFavoriteIds] = useState<string[]>(() => {
    // Initialize from localStorage (client-side only)
    if (typeof window === 'undefined') return [];

    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      return stored ? JSON.parse(stored) : [];
    } catch {
      return [];
    }
  });

  // Sync to localStorage whenever favoriteIds changes
  useEffect(() => {
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(favoriteIds));
    }
  }, [favoriteIds]);

  const toggleFavorite = (userId: string) => {
    setFavoriteIds(prev =>
      prev.includes(userId)
        ? prev.filter(id => id !== userId)
        : [...prev, userId]
    );
  };

  const isFavorite = (userId: string) => favoriteIds.includes(userId);

  return {
    favoriteIds,
    toggleFavorite,
    isFavorite,
  };
}
```

---

## Step 15: Update UserCard with Favorite Button

Edit `components/UserCard.tsx`

Replace entire file with:

```typescript
// components/UserCard.tsx

import { User } from '@/types';

interface UserCardProps {
  user: User;
  isFavorite?: boolean;
  onToggleFavorite?: (userId: string) => void;
}

export function UserCard({ user, isFavorite, onToggleFavorite }: UserCardProps) {
  return (
    <div className="border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow relative">
      {/* Favorite Button */}
      {onToggleFavorite && (
        <button
          onClick={() => onToggleFavorite(user.id)}
          className="absolute top-2 right-2 text-2xl hover:scale-110 transition-transform"
          aria-label={isFavorite ? 'Remove from favorites' : 'Add to favorites'}
        >
          {isFavorite ? '❤️' : '🤍'}
        </button>
      )}

      {/* User Image */}
      <img
        src={user.picture.large}
        alt={user.name.full}
        className="w-24 h-24 rounded-full mx-auto mb-4 object-cover"
      />

      {/* User Name */}
      <h3 className="font-semibold text-lg text-center mb-2">
        {user.name.full}
      </h3>

      {/* User Email */}
      <p className="text-gray-600 text-center text-sm mb-2 break-all">
        {user.email}
      </p>

      {/* User Nationality */}
      <p className="text-gray-500 text-center text-xs">
        <span className="inline-block bg-gray-100 px-3 py-1 rounded-full">
          {user.nationality.toUpperCase()}
        </span>
      </p>
    </div>
  );
}
```

---

## Step 16: Update UserDirectory with Favorites

Edit `components/UserDirectory.tsx`

**Add this import at the top:**

```typescript
import { useFavorites } from '@/hooks/useFavorites';
```

**Add this inside the component (after useUsers):**

```typescript
const { favoriteIds, toggleFavorite, isFavorite } = useFavorites();
const [activeTab, setActiveTab] = useState<'all' | 'favorites'>('all');
```

**Update the filteredUsers useMemo to include tab filtering:**

```typescript
const filteredUsers = useMemo(() => {
  if (!users) return [];

  let result = users;

  // Filter by tab
  if (activeTab === 'favorites') {
    result = result.filter(user => favoriteIds.includes(user.id));
  }

  // Filter by search and nationality
  return result.filter(user => {
    const matchesSearch = user.name.full
      .toLowerCase()
      .includes(searchTerm.toLowerCase());

    const matchesNationality =
      selectedNationality === 'all' ||
      user.nationality === selectedNationality;

    return matchesSearch && matchesNationality;
  });
}, [users, searchTerm, selectedNationality, activeTab, favoriteIds]);
```

**Add tab navigation BEFORE the filters section:**

```typescript
{/* Tab Navigation */}
<div className="mb-6 flex gap-4">
  <button
    onClick={() => setActiveTab('all')}
    className={`px-6 py-2 rounded-lg font-medium transition-colors ${
      activeTab === 'all'
        ? 'bg-blue-500 text-white'
        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
    }`}
  >
    All Users ({users?.length || 0})
  </button>
  <button
    onClick={() => setActiveTab('favorites')}
    className={`px-6 py-2 rounded-lg font-medium transition-colors ${
      activeTab === 'favorites'
        ? 'bg-blue-500 text-white'
        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
    }`}
  >
    Favorites ({favoriteIds.length})
  </button>
</div>
```

**Update the UserCard usage to pass favorite props:**

```typescript
{filteredUsers.map(user => (
  <UserCard
    key={user.id}
    user={user}
    isFavorite={isFavorite(user.id)}
    onToggleFavorite={toggleFavorite}
  />
))}
```

**Update the empty state to be tab-aware:**

```typescript
{filteredUsers.length === 0 && (
  <div className="text-center py-12">
    <p className="text-xl text-gray-600 mb-2">
      {activeTab === 'favorites'
        ? 'No favorites yet'
        : 'No users found'}
    </p>
    <p className="text-gray-500">
      {activeTab === 'favorites'
        ? 'Click the heart icon on user cards to add favorites'
        : 'Try adjusting your search or filter criteria'}
    </p>
    {activeTab === 'all' && (
      <button
        onClick={() => {
          setSearchTerm('');
          setSelectedNationality('all');
        }}
        className="mt-4 px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
      >
        Clear Filters
      </button>
    )}
  </div>
)}
```

**What to say:**
> "Adding favorites with localStorage persistence. The useFavorites hook manages both the state and localStorage sync. In production I'd add validation and handle QuotaExceeded errors."

**✓ Checkpoint:** Favorites working and persisting on refresh

---

# Phase 4: Final Review (50-60 min)

## Step 17: Manual Test - Final Check

Test these scenarios:

**Core Functionality:**
- [ ] Search by name works (case-insensitive)
- [ ] Filter by nationality works
- [ ] Search + filter together works (AND logic)
- [ ] Results count is accurate
- [ ] "No users found" shows when appropriate
- [ ] "Clear filters" button works

**Favorites (if implemented):**
- [ ] Can click heart to favorite
- [ ] Heart fills in (🤍 → ❤️)
- [ ] Can unfavorite (❤️ → 🤍)
- [ ] Favorites tab shows only favorites
- [ ] Favorite count is accurate
- [ ] Favorites persist on page refresh
- [ ] Search/filter work in favorites tab

**Responsive:**
- [ ] Works on mobile (resize to ~400px)
- [ ] Works on tablet (resize to ~800px)
- [ ] Works on desktop (resize to ~1200px+)

**Edge Cases:**
- [ ] Empty search shows all users
- [ ] Search for nonsense shows "no users found"
- [ ] Can clear filters successfully
- [ ] No console errors

---

## Step 18: Code Review Checklist

Quick scan of your code:

- [ ] No `any` types except in fetchUsers (acceptable for speed)
- [ ] All imports are used
- [ ] No console.log statements
- [ ] No unused variables
- [ ] Components have clear names
- [ ] Code is readable

---

# Interview Communication Scripts

## When You Start (0-5 min)

**Say this:**
```
"Let me quickly understand the requirements... [skim for 30 seconds]

Okay, I need to build a user directory that fetches from an API, displays users
in a grid, and allows search by name and filter by nationality.

My plan is to:
1. Set up Next.js with TypeScript and React Query
2. Create types and data fetching
3. Build the UI with everything in one component to get it working fast
4. Then extract components and add bonus features if time permits

I'll assume search and filter work together with AND logic, and that basic
error handling is sufficient for now.

Does that approach sound good?"
```

---

## While Building Data Layer (5-15 min)

**Say this:**
```
"I'm creating a simple User type with just the fields we need - id, email,
name, picture, and nationality.

For the API fetch, I'm transforming the response inline. In production I'd
create separate API response types and a dedicated transformer with validation,
but this gets us moving quickly.

Using React Query gives us caching, loading states, and automatic refetching
for free. I'm using default configuration now but would tune staleTime and
retry logic based on requirements."
```

---

## While Building UI (15-35 min)

**Say this:**
```
"I'm putting all the logic in UserDirectory for now - the search, filter, and
display are all in one component. This lets me get the data flow working quickly.

The filter logic uses useMemo so it only recalculates when users, searchTerm,
or nationality changes. I'm using .includes() for search instead of regex
because it's simpler and handles special characters safely.

Once this is working, I'll extract UserCard as a presentational component."
```

---

## At Minute 35 (Testing Time)

**Say this:**
```
"Let me test the core functionality before moving forward...

[Test search, filter, both together]

Great, everything is working. I have about 15 minutes left. Should I focus on
extracting components for cleaner code or adding the favorites feature?"
```

---

## When Refining (35-50 min)

**Say this:**
```
"Now that the core works, I'm extracting UserCard as a reusable component.
This follows the presentational component pattern - it receives props and
renders UI without any business logic.

[If adding favorites]
I'm adding a useFavorites hook that manages favorites state and syncs with
localStorage. In production I'd add error handling for QuotaExceeded and
validate the data on load."
```

---

## Final Review (50-60 min)

**Say this:**
```
"Let me do a final check...

[Quick manual test]

Here's what I built:
- User directory that fetches 50 users from the API
- Search by name (case-insensitive)
- Filter by nationality
- Both work together with AND logic
- Favorites with localStorage persistence
- Responsive grid layout
- Loading and error states

Given more time, I would:
1. Add runtime validation with zod for the API response
2. Extract SearchInput and NationalityFilter as reusable components
3. Create a custom useUserFilter hook to encapsulate filtering logic
4. Add comprehensive error handling with retry
5. Improve accessibility with proper ARIA labels

I made these tradeoffs to deliver working code in the time available, but I
understand the architectural principles behind what I would do differently."
```

---

# Common Issues & Solutions

## Issue: React Query not working

**Error:** `useQuery is not a function`

**Solution:** Make sure you:
1. Installed @tanstack/react-query
2. Created Providers component
3. Wrapped app in Providers in layout.tsx
4. Used `'use client'` in providers.tsx

---

## Issue: TypeScript errors

**Error:** `Cannot find module '@/types'`

**Solution:**
- Make sure you have `types/index.ts` created
- Check that `@/*` is configured in `tsconfig.json` (should be there by default)

---

## Issue: Styles not working

**Error:** Tailwind classes not applying

**Solution:**
- Make sure you selected Tailwind during setup
- Check that `globals.css` is imported in layout.tsx
- Restart dev server

---

## Issue: Favorites not persisting

**Error:** Favorites reset on refresh

**Solution:**
- Check that you're using `localStorage.setItem` in useEffect
- Make sure you're not in incognito mode (localStorage disabled)
- Check browser console for errors

---

# Time Checkpoints

Use these to stay on track:

- **Minute 5:** Project created, dependencies installed, dev server running
- **Minute 15:** Types created, API function created, useUsers hook created
- **Minute 25:** UserDirectory component created, rendering on page
- **Minute 35:** ✅ **EVERYTHING WORKING** - search, filter, display all work
- **Minute 40:** UserCard extracted (optional)
- **Minute 50:** Favorites added (optional)
- **Minute 60:** Final review done, ready to present

**If you're behind schedule:**
- Skip extraction (keep everything in UserDirectory)
- Skip favorites
- Just get the core working by minute 35
- Use remaining time to explain what you would improve

---

# Success Criteria

## Must Have (35 min)
- ✅ Users display in a grid
- ✅ Search by name works (case-insensitive)
- ✅ Filter by nationality works
- ✅ Both work together
- ✅ Loading state shows
- ✅ Error state shows
- ✅ "No results" state shows
- ✅ Responsive (adjusts to screen size)

## Should Have (50 min)
- ✅ UserCard extracted as component
- ✅ Favorites feature working
- ✅ Favorites persist on refresh
- ✅ Clean code, no errors

## Nice to Have (60 min)
- ✅ SearchInput extracted
- ✅ NationalityFilter extracted
- ✅ useUserFilter hook
- ✅ Better error handling

---

# Next Steps

After completing this tutorial:

1. **Delete the project and rebuild from memory** (no copy-paste)
   - Can you do it in 35 minutes?
   - What did you forget?
   - What took longer than expected?

2. **Time yourself on each phase**
   - Setup: Should take < 5 min
   - Types + Data: Should take < 10 min
   - UI: Should take < 20 min
   - Practice until you hit these times

3. **Practice explaining while building**
   - Record yourself doing the tutorial
   - Explain every decision out loud
   - Review and improve

4. **Try variations**
   - Use different APIs
   - Add different filters (age, gender)
   - Build with different styling (no Tailwind)

---

**You've completed the speed tutorial! 🎉**

**Key takeaways:**
- Working code first, perfect code later
- Communication matters as much as code
- Know what to skip vs. what to say
- Test early, test often
- Manage time ruthlessly

**Now go practice and nail that interview! 🚀**
