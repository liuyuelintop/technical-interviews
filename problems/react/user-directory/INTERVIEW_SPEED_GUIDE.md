# 60-Minute Interview Speed Guide

## The Reality Check

You've read the ARCHITECTURAL_GUIDE.md. It's comprehensive, deep, and teaches you to think like an architect. **But you have 60 minutes in a real interview.**

This guide shows you how to **compress architectural thinking into interview speed** while still demonstrating that you understand the principles.

---

## The Core Problem

**ARCHITECTURAL_GUIDE.md teaches:** Deep analysis → Perfect types → Clean separation → Layered implementation → Comprehensive testing

**Real interviews demand:** Working code in 60 minutes while explaining your thought process

**The solution:** Build fast, communicate well, demonstrate knowledge through explanation rather than perfect implementation.

---

# The 60-Minute Strategy

## Phase 0: Lightning Start (0-5 min)

### What the Architectural Guide Says:
- Extract explicit and implicit requirements
- Ask clarifying questions
- Identify edge cases
- Prioritize features
- Analyze API response deeply

### What You Actually Do in 5 Minutes:

1. **Skim requirements once** - identify core features only
2. **Open API in browser** - see ONE actual response
3. **State assumptions OUT LOUD:**

```
"Looking at the requirements, I need to:
- Fetch and display 50 users ← P0
- Search by name ← P0
- Filter by nationality ← P0
- Handle loading/errors ← P0
- Favorites with localStorage ← P1 (if time)

I'm assuming:
- Search and filter work together (AND logic)
- Real-time filtering is fine for 50 users
- Basic error handling is sufficient
- Mobile-friendly but desktop-first

Does that sound right?"
```

4. **Start coding** - don't wait for perfect understanding

### Key Insight:
**Say what you would analyze**, then move on. Don't actually do deep analysis.

---

## Phase 1: Minimum Viable Foundation (5-15 min)

### What the Architectural Guide Says:
- 4-layer type system (API, Domain, UI, Utility)
- Separate transformer functions
- Comprehensive providers setup
- Complete error handling

### What You Actually Do in 10 Minutes:

#### Step 1: One Simple Type File (2 min)

```typescript
// types/index.ts

// Just the domain type - skip API types initially
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

**What to say while typing:**
> "I'm creating a User type with just the fields I need. In production I'd also create separate API response types and transformer functions for better boundary separation, but for now I'm prioritizing speed."

**What to skip:**
- ❌ ApiUserResponse type
- ❌ Separate UI/Utility types
- ❌ Comprehensive prop interfaces

**You demonstrate knowledge by SAYING it, not implementing it**

---

#### Step 2: Fast Data Layer (8 min)

```typescript
// lib/api.ts
import { User } from '@/types';

export async function fetchUsers(): Promise<User[]> {
  const response = await fetch('https://randomuser.me/api/?results=50');
  const data = await response.json();

  // Transform inline - don't create separate transformer yet
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

**What to say:**
> "I'm transforming API data inline here with any type. In production I'd add runtime validation with zod or similar, create proper API types, and handle edge cases like null values. But this gets us moving quickly."

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

**What to say:**
> "Using React Query for server state. This gives us caching, loading states, and refetching for free. I'm using default options now, but I'd configure staleTime, retry logic, etc. in production."

```typescript
// app/providers.tsx
'use client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useState } from 'react';

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient());
  return <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>;
}
```

**What to skip:**
- ❌ Separate transformer functions
- ❌ Runtime validation
- ❌ Comprehensive error handling
- ❌ Elaborate QueryClient configuration

**Time check: You should be at ~15 minutes with data layer ready**

---

## Phase 2: Get It Working (15-35 min)

### What the Architectural Guide Says:
- Build in 7 layers
- Separate smart/dumb components
- Extract custom hooks
- Build components separately (UserCard, SearchInput, NationalityFilter, etc.)
- Test each layer before moving forward

### What You Actually Do in 20 Minutes:

**Build EVERYTHING in ONE component first.** Extract later if time permits.

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
      const matchesSearch = user.name.full
        .toLowerCase()
        .includes(searchTerm.toLowerCase());

      const matchesNationality =
        selectedNationality === 'all' ||
        user.nationality === selectedNationality;

      return matchesSearch && matchesNationality;
    });
  }, [users, searchTerm, selectedNationality]);

  // Get unique nationalities INLINE
  const nationalities = useMemo(() => {
    if (!users) return [];
    return [...new Set(users.map(u => u.nationality))].sort();
  }, [users]);

  if (isLoading) {
    return <div className="p-8">Loading users...</div>;
  }

  if (isError) {
    return <div className="p-8 text-red-600">Failed to load users</div>;
  }

  return (
    <div className="container mx-auto p-8">
      <h1 className="text-3xl font-bold mb-8">User Directory</h1>

      {/* Filters INLINE - don't create separate components yet */}
      <div className="mb-6 flex gap-4">
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Search by name..."
          className="px-4 py-2 border rounded"
        />

        <select
          value={selectedNationality}
          onChange={(e) => setSelectedNationality(e.target.value)}
          className="px-4 py-2 border rounded"
        >
          <option value="all">All Nationalities</option>
          {nationalities.map(nat => (
            <option key={nat} value={nat}>{nat}</option>
          ))}
        </select>
      </div>

      <div className="mb-4 text-gray-600">
        Showing {filteredUsers.length} of {users?.length || 0} users
      </div>

      {/* User grid INLINE - don't create UserCard component yet */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredUsers.map(user => (
          <div key={user.id} className="border rounded-lg p-4">
            <img
              src={user.picture.large}
              alt={user.name.full}
              className="w-24 h-24 rounded-full mx-auto mb-4"
            />
            <h3 className="font-semibold text-lg text-center">{user.name.full}</h3>
            <p className="text-gray-600 text-center text-sm">{user.email}</p>
            <p className="text-gray-500 text-center text-xs mt-2">{user.nationality}</p>
          </div>
        ))}
      </div>

      {filteredUsers.length === 0 && (
        <div className="text-center py-12 text-gray-500">
          No users found. Try different search criteria.
        </div>
      )}
    </div>
  );
}
```

**What to say while building this:**

While creating the component:
> "I'm building everything in one component first to establish the data flow quickly. Once this works, I'll extract UserCard, SearchInput, and NationalityFilter as reusable components."

While writing filter logic:
> "Using useMemo for the filtered list to avoid re-filtering on every render. The dependencies are users, searchTerm, and selectedNationality."

While writing search logic:
> "I'm using .includes() instead of regex for safety with special characters. Making it case-insensitive by converting both to lowercase."

While creating the grid:
> "Starting with inline user cards. In the next iteration I'd extract this to a UserCard component following the presentational component pattern."

**What to skip:**
- ❌ Separate UserCard component (yet)
- ❌ Separate SearchInput component (yet)
- ❌ Separate NationalityFilter component (yet)
- ❌ Custom useUserFilter hook (yet)
- ❌ Comprehensive error states
- ❌ Loading skeletons
- ❌ Animations

**CRITICAL: At minute 35, you MUST have working search and filter.**

**Time check: Minute 35 - DO A MANUAL TEST**
- Search works? ✓
- Filter works? ✓
- Both together work? ✓
- Shows "no results"? ✓

**If yes, proceed to Phase 3. If no, DEBUG IMMEDIATELY.**

---

## Phase 3: Refine (Only if Core Works) (35-50 min)

**You have 15 minutes. Prioritize ruthlessly.**

### Option A: Extract Components (if interviewer values clean code)

#### Extract UserCard (5 min)

```typescript
// components/UserCard.tsx
import { User } from '@/types';

interface UserCardProps {
  user: User;
}

export function UserCard({ user }: UserCardProps) {
  return (
    <div className="border rounded-lg p-4">
      <img
        src={user.picture.large}
        alt={user.name.full}
        className="w-24 h-24 rounded-full mx-auto mb-4"
      />
      <h3 className="font-semibold text-lg text-center">{user.name.full}</h3>
      <p className="text-gray-600 text-center text-sm">{user.email}</p>
      <p className="text-gray-500 text-center text-xs mt-2">{user.nationality}</p>
    </div>
  );
}
```

Update UserDirectory to use it:
```typescript
{filteredUsers.map(user => (
  <UserCard key={user.id} user={user} />
))}
```

**Say:** "Now that the core works, I'm extracting UserCard as a presentational component. This makes it reusable and easier to test."

---

### Option B: Add Favorites (if it's a requirement) (15 min)

```typescript
// hooks/useFavorites.ts
import { useState, useEffect } from 'react';

const STORAGE_KEY = 'user-favorites';

export function useFavorites() {
  const [favoriteIds, setFavoriteIds] = useState<string[]>(() => {
    // Initialize from localStorage
    if (typeof window === 'undefined') return [];
    const stored = localStorage.getItem(STORAGE_KEY);
    return stored ? JSON.parse(stored) : [];
  });

  // Sync to localStorage
  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(favoriteIds));
  }, [favoriteIds]);

  const toggleFavorite = (userId: string) => {
    setFavoriteIds(prev =>
      prev.includes(userId)
        ? prev.filter(id => id !== userId)
        : [...prev, userId]
    );
  };

  const isFavorite = (userId: string) => favoriteIds.includes(userId);

  return { favoriteIds, toggleFavorite, isFavorite };
}
```

Add to UserCard:
```typescript
interface UserCardProps {
  user: User;
  isFavorite?: boolean;
  onToggleFavorite?: (userId: string) => void;
}

export function UserCard({ user, isFavorite, onToggleFavorite }: UserCardProps) {
  return (
    <div className="border rounded-lg p-4 relative">
      {onToggleFavorite && (
        <button
          onClick={() => onToggleFavorite(user.id)}
          className="absolute top-2 right-2 text-2xl"
        >
          {isFavorite ? '❤️' : '🤍'}
        </button>
      )}
      {/* rest of component */}
    </div>
  );
}
```

Update UserDirectory:
```typescript
const { favoriteIds, toggleFavorite, isFavorite } = useFavorites();

{filteredUsers.map(user => (
  <UserCard
    key={user.id}
    user={user}
    isFavorite={isFavorite(user.id)}
    onToggleFavorite={toggleFavorite}
  />
))}
```

**Say:** "Adding favorites with localStorage persistence. In production I'd add validation and handle QuotaExceeded errors."

---

### Option C: Better Error Handling (if interviewer mentioned it) (10 min)

```typescript
// Update useUsers.ts
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
    retry: 2,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}
```

```typescript
// Update UserDirectory.tsx
if (isError) {
  return (
    <div className="p-8">
      <div className="bg-red-50 border border-red-200 rounded p-4">
        <h2 className="text-red-800 font-semibold mb-2">Failed to load users</h2>
        <p className="text-red-600 mb-4">Please try again later.</p>
        <button
          onClick={() => queryClient.invalidateQueries({ queryKey: ['users'] })}
          className="px-4 py-2 bg-red-600 text-white rounded"
        >
          Retry
        </button>
      </div>
    </div>
  );
}
```

**Say:** "Adding retry logic and a better error state with retry button."

---

## Phase 4: Review & Communicate (50-60 min)

**DO NOT SKIP THIS.** This is where you seal the deal.

### Step 1: Quick Manual Test (2 min)

Test these scenarios:
- Search: "john" (should filter)
- Search: "JOHN" (should be case-insensitive)
- Filter: Select a nationality (should filter)
- Both: Search + nationality together (should combine)
- Clear: Empty search (should show all)
- Edge: Search for nonsense (should show "no results")
- Favorites: Toggle favorite (should persist on refresh if implemented)

### Step 2: Code Walkthrough (3 min)

Walk through what you built:

```
"Let me walk through what I built:

1. Data Layer: Using React Query to fetch from the Random User API.
   The data is transformed into our User type inline in the fetch function.

2. State: Using useState for search and nationality filter.
   Filtered users are computed with useMemo to avoid unnecessary recalculations.

3. UI: Everything is in UserDirectory component. Users are displayed in a
   responsive grid with search and filter controls above.

4. [If you extracted]: I extracted UserCard as a presentational component
   that receives props and renders UI.

5. [If you added favorites]: I added favorites with localStorage using
   a custom hook that syncs state with storage.

Everything works together - search and filter combine with AND logic.
"
```

### Step 3: Discuss Trade-offs (3 min)

**This is CRITICAL.** Show you understand the architectural principles even though you didn't implement everything perfectly.

```
"Given more time, here's what I would improve:

Architecture:
- Separate API response types from domain types for better boundary separation
- Extract SearchInput and NationalityFilter as reusable controlled components
- Create a useUserFilter custom hook to encapsulate filtering logic
- Move the transformer to a separate function with runtime validation

Error Handling:
- Add runtime validation of API responses with zod or similar
- Handle edge cases like missing images, null values
- Add proper error boundaries
- Handle localStorage quota errors

Performance:
- For 50 users, performance is fine. For 1000+ I'd add debouncing to search
- For 10,000+ I'd add virtualization with react-window and server-side filtering

Testing:
- Unit tests for filtering logic
- Integration tests with Mock Service Worker for API
- E2E tests with Playwright

Accessibility:
- Proper labels for inputs
- Keyboard navigation for user cards
- ARIA live regions for result counts
- Focus management
"
```

### Step 4: Answer Questions (2 min)

Common questions and how to answer:

**Q: "Why didn't you separate the components from the start?"**
> "I prioritized getting core functionality working first. With working code, I can refactor safely. In production I'd do more upfront design, but in time-limited interviews I optimize for working code first, then clean code."

**Q: "How would you handle 10,000 users?"**
> "I'd switch to server-side filtering and pagination. The API would take search and filter params. I'd use cursor-based pagination for better performance and add virtualization for the list."

**Q: "What about error handling?"**
> "I'd add several layers: runtime validation with zod on API boundaries, error boundaries for React errors, proper loading states, retry logic with exponential backoff, and user-friendly error messages."

**Q: "How would you test this?"**
> "Unit tests for utility functions and hooks, integration tests for components with MSW to mock the API, and E2E tests for critical user flows. I'd test edge cases like empty states, network failures, etc."

---

# The Communication Framework

## What to Say at Each Phase

This is just as important as the code you write.

### Starting Out (0-5 min)

**BAD:**
- *Starts coding silently*
- *Spends 10 minutes reading requirements*

**GOOD:**
```
"Let me quickly understand the requirements... [30 seconds]

Okay, I need to build a user directory with search, filter, and display.
The core features are fetching from the API, searching by name, and filtering
by nationality. Favorites seem like a bonus.

I'm going to start with types and data fetching, then build the UI with
everything in one component to get it working quickly. Once the core works,
I'll refactor and add the bonus features.

I'll assume search and filter work together, and that basic error handling
is sufficient. Does that approach sound good?"
```

**Why this works:**
- Shows you can prioritize
- Shows you have a plan
- Invites feedback early
- Demonstrates communication skills

---

### While Building Data Layer (5-15 min)

**WHAT YOU'RE DOING:**
Writing the fetch function with inline transformation and any type.

**WHAT YOU SAY:**
```
"I'm creating a fetch function that transforms the API response to our User type.
I'm using 'any' for the API response right now to move quickly. In production,
I'd create a separate ApiUserResponse type and a dedicated transformer function
with runtime validation using zod or similar.

The transformation is simple - mapping the API's nested structure to our flatter
User interface. I'm computing the full name here since we'll use it for display.

Using React Query for data fetching gives us caching, loading states, and
automatic refetching. I'm using default configuration now, but I'd tune the
staleTime and retry logic based on requirements."
```

**Why this works:**
- Shows you know what you're doing
- Shows you know the tradeoffs
- Shows you know what "production-ready" means
- You demonstrate knowledge without implementing everything

---

### While Building UI (15-35 min)

**WHAT YOU'RE DOING:**
Building everything in one component.

**WHAT YOU SAY:**
```
"I'm putting everything in UserDirectory for now to get the data flow working
quickly. The filter logic is inline with useMemo so it only recalculates when
users, searchTerm, or nationality changes.

For the search, I'm using .includes() instead of regex because it's simpler
and handles special characters safely. No need to escape user input this way.

I'm rendering user cards inline right now. Once this works, I'll extract
UserCard as a presentational component that takes a user prop and handles
display logic.

The grid uses Tailwind's responsive classes - one column on mobile, three
on desktop. Simple but effective."
```

**Why this works:**
- Explains the "why" behind your shortcuts
- Shows you understand component architecture even though you're building it differently
- Demonstrates you're being pragmatic, not sloppy

---

### When Something Doesn't Work (Whenever)

**BAD:**
- *Stares at screen silently*
- *Random trial and error*
- *Panic*

**GOOD:**
```
"Hmm, the search isn't filtering. Let me debug this systematically.

First, let me check if the state is updating... [adds console.log]
Okay, searchTerm is updating correctly when I type.

Next, is the useMemo recalculating? Let me log the filtered result... [adds console.log]
I see the issue - the filtered array is empty even though it shouldn't be.

Let me check the filter logic... [reads code]
Ah, I see it - I'm checking user.name instead of user.name.full. Let me fix that.

[fixes bug, tests]
Great, now it's working."
```

**Why this works:**
- Shows systematic debugging
- Shows you don't panic
- Shows problem-solving skills
- This is often more valuable than perfect code

---

## The Final Review (50-60 min)

**WHAT YOU SAY:**

### The Summary (1 min)
```
"I've built a user directory that fetches 50 users from the Random User API
and displays them in a responsive grid. Users can search by name (case-insensitive)
and filter by nationality. The filters work together with AND logic.

I'm using React Query for data fetching and caching, useState for filter state,
and useMemo for the computed filtered list. Everything is working, including
loading states, error states, and empty states."
```

### The Honesty (1 min)
```
"Given the time constraint, I made some deliberate trade-offs:

What I prioritized:
- Getting core functionality working
- Clean, readable code
- Proper error and loading states
- Responsive design

What I'd improve with more time:
- Extract components (UserCard, SearchInput, NationalityFilter)
- Add proper TypeScript types for the API response
- Add favorites with localStorage
- Add runtime validation
- Better error handling with retry
- Accessibility improvements"
```

### The Depth (1 min)
```
"I understand the architectural principles behind what I would do differently:

The smart/dumb component pattern would make UserCard more reusable and testable.

Separating API types from domain types creates a clear boundary and makes it
easier to handle API changes.

A custom useUserFilter hook would encapsulate the filtering logic and make it
easier to test in isolation.

I made these tradeoffs to deliver working code in the time available, but I
could refactor towards any of these patterns if needed."
```

**Why this works:**
- Shows self-awareness
- Shows you understand architecture
- Shows you can make pragmatic decisions
- Shows you know what you would do with more time

---

# Common Pitfalls to Avoid

## Pitfall 1: Perfectionism Paralysis

**DON'T DO THIS:**
```
[Minute 25]
Interviewer: "How's it going?"
You: "Still working on the type system. I want to get the API types perfect
before moving forward."
```

**DO THIS INSTEAD:**
```
[Minute 25]
Interviewer: "How's it going?"
You: "I have data fetching working and I'm building the UI now. Search and
filter should be working in about 10 minutes."
```

**Key:** Working code > perfect architecture in interviews.

---

## Pitfall 2: Silent Coding

**DON'T DO THIS:**
- *Codes for 30 minutes in silence*
- *Interviewer has no idea what you're thinking*

**DO THIS INSTEAD:**
- Explain while you type
- Narrate your decisions
- Ask questions
- Think aloud

**Key:** Interviewers can't read your mind. Communication is 30% of the evaluation.

---

## Pitfall 3: Ignoring Time

**DON'T DO THIS:**
```
[Minute 50]
"I'm still working on the type system. I should be able to start on the UI soon."
```

**DO THIS INSTEAD:**
```
[Minute 30]
"Let me do a quick test to make sure the core works before I add more features."

[Minute 35]
"Core functionality is working. I have 15 minutes left - should I extract
components or add the favorites feature?"
```

**Key:** Check the clock every 10-15 minutes. Adjust priorities accordingly.

---

## Pitfall 4: Not Testing Until the End

**DON'T DO THIS:**
```
[Minute 55]
"Let me test this now... oh, nothing works"
```

**DO THIS INSTEAD:**
```
[Minute 35]
"Let me test the search and filter... great, both working."

[Minute 45]
"Testing favorites... works and persists on reload."
```

**Key:** Test incrementally. Find bugs early when you have time to fix them.

---

## Pitfall 5: Giving Up When Stuck

**DON'T DO THIS:**
```
"I don't know why this isn't working. I'm stuck."
[Stares at screen]
```

**DO THIS INSTEAD:**
```
"The search isn't working. Let me debug this systematically.
First, is the state updating? Let me check... [console.log]
Yes, state is updating.
Next, is the filter function running? [console.log]
Hmm, the filter function isn't being called. Let me check why...
Oh, I see - I forgot to add it to the useMemo dependencies."
```

**Key:** Debug out loud. Systematic debugging impresses interviewers even when you're stuck.

---

# The Speed Practice Regimen

## Week 1: Build Fast Muscle Memory

**Goal:** Build working version with everything inline in 30 minutes

**Daily practice (30 min):**
1. Set timer for 30 minutes
2. Build user directory with EVERYTHING in one component
3. Must have working search and filter by end
4. No extraction, no polish, just WORKING

**What you're learning:**
- How to prioritize ruthlessly
- What's actually necessary vs. nice-to-have
- Building under time pressure

**Success criteria:**
- Working search by minute 30
- Working filter by minute 30
- No crashes, no errors

---

## Week 2: Extraction Under Pressure

**Goal:** Learn what's worth extracting and what's not

**Daily practice (50 min):**
1. Build working version in 30 min (same as Week 1)
2. Spend 20 min extracting and refactoring
3. Try different extraction strategies each day:
   - Day 1: Extract UserCard only
   - Day 2: Extract UserCard + SearchInput
   - Day 3: Extract UserCard + useUserFilter hook
   - Day 4: Extract everything
   - Day 5: Extract based on what felt most valuable

**What you're learning:**
- How long extraction actually takes
- What provides the most value
- When to stop refactoring

**Success criteria:**
- Core still works after extraction
- Code is cleaner but not over-engineered
- Can explain what you extracted and why

---

## Week 3: Communication Practice

**Goal:** Explain while you code

**Daily practice (30 min):**
1. Set up screen recording
2. Build user directory while EXPLAINING OUT LOUD
3. Explain every decision, trade-off, shortcut
4. Review recording afterward

**What to say while coding:**
- "I'm doing X because..."
- "I'm skipping Y for now, but in production I'd..."
- "I chose this approach over that one because..."
- "If I had more time, I'd..."

**What you're learning:**
- How to think and talk simultaneously
- How to articulate decisions
- How to demonstrate knowledge without implementing everything

**Success criteria:**
- Can explain every line of code
- Can articulate trade-offs
- Sound confident, not uncertain

---

## Week 4: Full Interview Simulations

**Goal:** Simulate real interview conditions

**Practice (60 min each):**
- Do full 60-minute builds
- Use interview timer (visible countdown)
- Practice stopping at minute 35 to test
- Practice the final review and explanation
- Vary the requirements each time

**Different scenarios to practice:**
1. **Scenario A:** Emphasize clean code - extract components early
2. **Scenario B:** Emphasize features - add favorites and tabs
3. **Scenario C:** Emphasize error handling - comprehensive edge cases
4. **Scenario D:** Balance - get core working, then refine

**What you're learning:**
- How to read interviewer priorities
- How to adjust strategy based on feedback
- How to manage time and pressure

**Success criteria:**
- Working code by minute 35 every time
- Can confidently discuss trade-offs
- Can adapt based on requirements

---

# The Interview Day Checklist

## Before the Interview

**Mental preparation:**
- [ ] I know my 60-minute timeline
- [ ] I know what to prioritize (working code first)
- [ ] I know what to communicate (decisions, trade-offs)
- [ ] I know how to debug out loud
- [ ] I'm ready to be pragmatic, not perfect

**Quick review:**
- [ ] React Query basics (useQuery, QueryClient)
- [ ] useMemo, useState, useEffect dependencies
- [ ] Array methods (map, filter, includes)
- [ ] Tailwind basics (grid, flex, responsive classes)

---

## During the Interview

**0-5 minutes:**
- [ ] Quickly read requirements (not deeply analyze)
- [ ] Test API in browser once
- [ ] State assumptions out loud
- [ ] Start coding

**5-15 minutes:**
- [ ] Simple User type created
- [ ] Data fetching working
- [ ] Can console.log users

**15-35 minutes:**
- [ ] UI rendering
- [ ] Search working
- [ ] Filter working
- [ ] Manual test done

**35-50 minutes:**
- [ ] Decide: extract components OR add features OR improve errors
- [ ] Execute one improvement fully
- [ ] Don't start something you can't finish

**50-60 minutes:**
- [ ] Stop coding
- [ ] Test manually
- [ ] Review code
- [ ] Explain trade-offs
- [ ] Answer questions

---

# Final Thoughts: The Mindset Shift

## From the Architectural Guide Mindset:
```
"I need to deeply understand every requirement"
"I need perfect type separation"
"I need clean component architecture from the start"
"I need comprehensive edge case handling"
```

## To the Interview Speed Mindset:
```
"I need to quickly identify core requirements and start coding"
"I need types that work, I can explain what I'd improve"
"I need working code, I can extract components later"
"I need basic error handling, I can explain what else I'd add"
```

---

## The Key Insight

**The Architectural Guide teaches you WHAT to know.**

**This Speed Guide teaches you WHAT to do in 60 minutes.**

You need both:
- Study the Architectural Guide to build deep understanding
- Practice this Speed Guide to execute under pressure
- In interviews, demonstrate knowledge through COMMUNICATION, not just implementation

---

## The Winning Formula

```
Working Code (40%)
  + Clear Communication (30%)
  + Architectural Knowledge (20%)
  + Problem-Solving Process (10%)
  = Interview Success
```

**Not:**
```
Perfect Code (100%) = Interview Failure (due to time)
```

---

# Quick Reference Card

Print this and put it next to your monitor during practice:

## THE 60-MINUTE TIMELINE

**0-5 min:** Skim, test API, state assumptions, START CODING
**5-15 min:** Types + data layer with inline transformation
**15-35 min:** Everything in one component, must be WORKING
**35 min:** STOP and TEST
**35-50 min:** Refine (extract OR add features OR errors)
**50-60 min:** Review, explain, answer questions

## WHAT TO SAY

**While taking shortcuts:**
"I'm doing X now, in production I'd do Y because..."

**While debugging:**
"Let me check this systematically... [explain process]"

**At the end:**
"Working core features: ✓
What I'd improve with more time: [list]
Architectural principles I applied: [explain]"

## WHAT TO SKIP

- ❌ Perfect type layers initially
- ❌ Separated components initially
- ❌ Custom hooks initially
- ❌ Comprehensive error handling initially
- ❌ Animations, polish, accessibility initially

## WHAT TO DO

- ✅ Get it working first
- ✅ Explain while coding
- ✅ Test at minute 35
- ✅ Refactor only if time permits
- ✅ Demonstrate knowledge through communication

---

**Remember: The interview is not about writing perfect code. It's about demonstrating you can deliver working software under pressure while making sound technical decisions.**

**Good luck! 🚀**
