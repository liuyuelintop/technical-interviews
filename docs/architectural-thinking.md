# Architectural Thinking Guide for Technical Interviews

## The Problem You Identified

You're right. The previous guide focused on **HOW to code**, but you also need to develop **HOW to THINK like an architect**.

**What you're missing:**
- How to analyze requirements deeply
- How to understand and model data structures
- How to make design decisions
- How to choose the right tools and patterns
- How to architect a solution before coding
- How to think through edge cases and scalability
- How to communicate your reasoning

This guide teaches you the **thinking process** that happens BEFORE and DURING coding.

---

# Part 1: The Architectural Thinking Framework

## The 5-Phase Thinking Process

### Phase 1: Requirements Analysis (The "What")
### Phase 2: Data Modeling (The "Structure")
### Phase 3: Architecture Design (The "How")
### Phase 4: Implementation Planning (The "Order")
### Phase 5: Risk & Edge Case Analysis (The "What If")

Let's apply this to the User Directory project.

---

## Phase 1: Requirements Analysis

### The Naive Approach (What Most People Do)

```
Interviewer: "Build a user directory with search and filter."

You: "Okay!" *starts coding immediately*
```

**Problem:** You're solving a problem you don't fully understand.

---

### The Architect's Approach

**Step 1: Extract Explicit Requirements**

Read the requirements again, line by line:

```markdown
1. Fetch User Data
   - Use Random User API (https://randomuser.me/api/?results=50)
   - Store fetched data in component's state
   - Define User Type

2. Show user details including:
   - Profile image
   - First name
   - Last name
   - Email
   - Nationality

3. Search Functionality
   - Add input field to search users by first OR last name
   - Case-insensitive
   - Update displayed list in real-time

4. Filter by Nationality
   - Add dropdown to filter users by nationality
   - No duplicate nationalities
   - Default option: "All"

5. Bonus: Mock API search (explain approach)
```

**Step 2: Identify Implicit Requirements**

These are NOT stated but are expected:

```markdown
Implicit Requirements:
- Loading state while fetching
- Error handling if API fails
- No results state when filters return empty
- Responsive design (mobile, tablet, desktop)
- Unique key for each user in list
- Accessibility (alt text, labels, keyboard navigation)
- Performance (don't re-filter on every keystroke if expensive)
- Type safety (TypeScript)
```

**How to find implicit requirements:**
- Think about user experience
- Think about error cases
- Think about different devices
- Think about accessibility
- Think about performance

---

**Step 3: Ask Clarifying Questions**

In an interview, ASK these questions:

```
Architecture Questions:
Q: "Should search and filter work together (AND) or separately (OR)?"
A: Together - user can search AND filter by nationality

Q: "Should results update on every keystroke or with a debounce?"
A: Real-time is fine for 50 users, but explain debouncing for larger datasets

Q: "What happens if the API is slow or fails?"
A: Show loading state, show error message

Q: "Should favorites persist across browser sessions?"
A: Yes (implies localStorage or backend)

Q: "Should the app work offline after initial load?"
A: Not required, but nice to have (React Query caching helps)

Design Questions:
Q: "Any design requirements? Should it match a design system?"
A: Clean, modern UI is fine. Functional > beautiful.

Q: "Which browsers need to be supported?"
A: Modern browsers (Chrome, Firefox, Safari, Edge)

Technical Questions:
Q: "Are there any constraints on libraries or frameworks?"
A: Next.js, React, TypeScript are preferred

Q: "Should I write tests?"
A: Not required in interview, but explain testing strategy
```

**Pro Tip:** Even if the interviewer says "you decide," STATING your assumptions shows architectural thinking.

Example:
> "I'm going to assume we want search and filter to work together, results should update in real-time since we only have 50 users, and we need loading and error states. Does that sound right?"

---

**Step 4: Prioritize Requirements**

Not all requirements are equal. Categorize them:

```markdown
MUST HAVE (P0):
- Fetch and display users
- Search by name
- Filter by nationality
- Basic error handling

SHOULD HAVE (P1):
- Loading states
- Empty states
- Responsive design
- Good TypeScript types

NICE TO HAVE (P2):
- Favorites feature
- Debounced search
- Skeleton loaders
- Animations
- Offline support

FUTURE ENHANCEMENTS:
- Pagination
- Sorting
- Advanced filters (age, location)
- Export to CSV
- Share filtered results
```

**Why prioritize?**
- In time-limited interviews, deliver P0 first
- Shows you understand business value
- Allows you to cut scope gracefully if running out of time

---

## Phase 2: Data Modeling

### Step 1: Understand the API Response

**The Architect's First Step:** ALWAYS inspect the actual data.

You have the actual API response. Let's analyze it architecturally:

```json
{
  "results": [
    {
      "gender": "male",
      "name": {
        "title": "Mr",
        "first": "Viggo",
        "last": "Vollenbroek"
      },
      "location": {
        "street": { "number": 2468, "name": "Heemtuin" },
        "city": "Oudorp Nh",
        "state": "Flevoland",
        "country": "Netherlands",
        "postcode": "7653 RZ",
        "coordinates": { "latitude": "37.9921", "longitude": "-98.4859" },
        "timezone": { "offset": "+5:45", "description": "Kathmandu" }
      },
      "email": "viggo.vollenbroek@example.com",
      "login": {
        "uuid": "eeb3aa22-bbb0-43ee-b248-8679c9aa9561",
        "username": "crazyleopard605",
        "password": "bigman",
        "salt": "UUTdn448",
        "md5": "...",
        "sha1": "...",
        "sha256": "..."
      },
      "dob": {
        "date": "1969-04-07T06:00:10.207Z",
        "age": 56
      },
      "registered": {
        "date": "2011-06-15T02:45:05.975Z",
        "age": 14
      },
      "phone": "(0131) 831600",
      "cell": "(06) 65423183",
      "id": {
        "name": "BSN",
        "value": "27845335"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/62.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/62.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/62.jpg"
      },
      "nat": "NL"
    }
  ],
  "info": {
    "seed": "...",
    "results": 50,
    "page": 1,
    "version": "1.4"
  }
}
```

---

### Step 2: Architectural Analysis of the Data

**Question 1: What data do we NEED vs. what data is AVAILABLE?**

```markdown
REQUIRED by spec:
✓ name.first
✓ name.last
✓ email
✓ picture
✓ nat (nationality)

AVAILABLE but not required:
- gender
- location (entire object)
- login (entire object)
- dob (date of birth)
- registered
- phone
- cell
- id

ARCHITECTURAL DECISION #1:
Should we fetch ALL fields or only what we need?

Option A: Use all data from API
  Pros:
    - Simple (no API parameters to learn)
    - Flexible for future features
    - Users might want more info later
  Cons:
    - Larger payload
    - Might expose sensitive data (password hashes)

Option B: Request only needed fields
  Pros:
    - Smaller payload
    - More secure
    - Faster parsing
  Cons:
    - API might not support field selection
    - Less flexible

DECISION: Use all data (API doesn't support field selection)
BUT: Only model the fields we need in TypeScript
```

---

**Question 2: What is the unique identifier?**

```markdown
Candidates for unique ID:
1. email - Looks unique, user-readable
2. login.uuid - Guaranteed unique, system-generated
3. Array index - Simple, but fragile (changes on filter)

ARCHITECTURAL DECISION #2:
What should we use as the React key?

Analysis:
- email: Unique per user, stable, readable
  Risk: Email could theoretically change

- login.uuid: Guaranteed unique, never changes
  Risk: Harder to debug (non-readable)

- Array index: NEVER use for dynamic lists
  Risk: Breaks React reconciliation on filter/sort

DECISION: Use email as key
Reasoning: For this demo API, emails are unique and stable
In production: Would use UUID or database ID
```

---

**Question 3: How should we structure the data in our application?**

```markdown
ARCHITECTURAL DECISION #3:
Data structure in application state

Option A: Store exactly as API returns
{
  results: User[],
  info: ApiInfo
}
Pros: Matches API, easy to understand
Cons: Always need to access .results

Option B: Extract just the users array
User[]
Pros: Simpler to work with
Cons: Lose metadata (info object)

Option C: Normalize and enhance
{
  users: User[],
  metadata: ApiInfo,
  favoriteIds: string[],
  filters: FilterState
}
Pros: All related data in one place
Cons: More complex

DECISION: Depends on complexity

For simple app (just display): Option B (User[])
For complex app (favorites, etc.): Option C (normalized state)
```

---

### Step 3: Type Modeling Strategy

**The Architect's Approach:** Model types in layers

```typescript
// LAYER 1: API Response Types (exact match to API)
// Purpose: Type safety for API communication
// Location: types/api.ts

interface ApiUserResponse {
  gender: string;
  name: {
    title: string;
    first: string;
    last: string;
  };
  location: {
    street: {
      number: number;
      name: string;
    };
    city: string;
    state: string;
    country: string;
    postcode: string;
    coordinates: {
      latitude: string;
      longitude: string;
    };
    timezone: {
      offset: string;
      description: string;
    };
  };
  email: string;
  login: {
    uuid: string;
    username: string;
    password: string;
    salt: string;
    md5: string;
    sha1: string;
    sha256: string;
  };
  dob: {
    date: string;
    age: number;
  };
  registered: {
    date: string;
    age: number;
  };
  phone: string;
  cell: string;
  id: {
    name: string;
    value: string;
  };
  picture: {
    large: string;
    medium: string;
    thumbnail: string;
  };
  nat: string;
}

interface RandomUserApiResponse {
  results: ApiUserResponse[];
  info: {
    seed: string;
    results: number;
    page: number;
    version: string;
  };
}
```

**Why separate API types?**
- API can change independently
- Clear boundary between external and internal
- Can transform data at the boundary

---

```typescript
// LAYER 2: Domain Types (what our app uses)
// Purpose: Only the data our app needs
// Location: types/domain.ts

interface User {
  // Identity
  id: string; // We'll use email as ID
  email: string;

  // Profile
  name: {
    first: string;
    last: string;
    full: string; // Computed: first + last
  };

  // Display
  picture: {
    large: string;
    medium: string;
    thumbnail: string;
  };

  // Metadata
  nationality: string;

  // Optional: might add later
  gender?: string;
  age?: number;
  location?: {
    city: string;
    country: string;
  };
}
```

**Why domain types differ from API types?**
- Adds computed fields (full name)
- Removes sensitive data (passwords, hashes)
- Renames for clarity (nat → nationality)
- Flattens unnecessary nesting
- Makes optional what we might not use

---

```typescript
// LAYER 3: UI/Component Types
// Purpose: Types for component props and state
// Location: types/ui.ts

type NationalityCode = string; // 'US' | 'GB' | 'NL' etc.
// In production, could be: type NationalityCode = 'US' | 'GB' | 'NL' | ...;

interface FilterState {
  searchTerm: string;
  selectedNationality: NationalityCode | 'all';
}

interface UserCardProps {
  user: User;
  variant?: 'default' | 'compact';
  isFavorite?: boolean;
  onFavoriteToggle?: (user: User) => void;
  onClick?: (user: User) => void;
}

interface UserListProps {
  users: User[];
  loading?: boolean;
  error?: Error | null;
  emptyMessage?: string;
  onUserClick?: (user: User) => void;
}
```

**Why separate UI types?**
- Components need different shapes than domain
- Props include callbacks, variants, UI state
- Clear contract for components
- Easy to change UI without affecting domain

---

```typescript
// LAYER 4: Utility Types
// Purpose: Helper types for specific operations
// Location: types/utils.ts

// For filtering operations
type UserFilterFn = (user: User) => boolean;

// For transformation
type UserTransformer = (apiUser: ApiUserResponse) => User;

// For sorting
type UserSortKey = keyof Pick<User, 'email' | 'nationality'>;
type UserSortFn = (a: User, b: User) => number;

// For grouping
type UsersGroupedByNationality = Record<NationalityCode, User[]>;
```

---

**ARCHITECTURAL DECISION #4: Data Transformation Strategy**

```typescript
// WHERE do we transform API data to Domain data?

// Option A: In the API call
async function fetchUsers(): Promise<User[]> {
  const response = await fetch(API_URL);
  const data: RandomUserApiResponse = await response.json();
  return data.results.map(transformApiUserToUser); // ← Transform here
}

// Option B: In React Query's select
const { data } = useQuery({
  queryKey: ['users'],
  queryFn: fetchRawUsers,
  select: (data) => data.results.map(transformApiUserToUser), // ← Transform here
});

// Option C: In the component
const { data: apiData } = useQuery(...);
const users = useMemo(
  () => apiData?.results.map(transformApiUserToUser), // ← Transform here
  [apiData]
);

DECISION: Option B (React Query select)

Reasoning:
- Transformation is cached by React Query
- Raw API data stays in cache (useful for debugging)
- Transformed data is memoized
- Clean separation of concerns
- Component receives clean domain objects

TRADE-OFF:
- If transformation is expensive, might want Option A
- If need both raw and transformed, might want Option C
```

---

### Step 4: State Management Architecture

**Question: Where should each piece of state live?**

**The Architect's Mental Model:**

```
State Classification:
1. Server State (data from API)
2. Client State (user interactions)
3. UI State (loading, modals, etc.)
4. Derived State (computed from other state)
5. Persistent State (localStorage, etc.)
```

**Let's classify our app's state:**

```markdown
SERVER STATE:
- User list from API
  → Managed by: React Query
  → Why: It's remote data, needs caching, refetching, error handling
  → Location: useUsers() hook

CLIENT STATE - Filters:
- Search term
  → Managed by: useState
  → Why: Local to this session, doesn't need persistence
  → Location: UserDirectory component or useUserFilter hook

- Selected nationality
  → Managed by: useState
  → Why: Local to this session
  → Location: Same as search term

CLIENT STATE - Favorites:
- List of favorite user IDs
  → Managed by: useState + useEffect (for localStorage)
  → Why: Needs to persist, but is client-side only
  → Location: useFavorites() custom hook
  → Alternative: Could use zustand/redux if app grows

UI STATE:
- Active tab (All vs Favorites)
  → Managed by: useState
  → Why: Pure UI state, no persistence needed
  → Location: UserDirectory component

- Modal open/closed (if we add user detail modal)
  → Managed by: useState
  → Why: Ephemeral UI state
  → Location: Component that owns modal

DERIVED STATE (computed, not stored):
- Filtered users
  → Managed by: useMemo
  → Why: Computed from users + filters
  → Location: useUserFilter hook

- Unique nationalities
  → Managed by: useMemo
  → Why: Derived from users array
  → Location: useUserFilter hook

- Favorite users
  → Managed by: useMemo
  → Why: Derived from users + favoriteIds
  → Location: useFavorites hook
```

---

**ARCHITECTURAL DECISION #5: State Composition Pattern**

```typescript
// How do we compose multiple pieces of state?

// ANTI-PATTERN: Prop drilling
function App() {
  const [search, setSearch] = useState('');
  const [nationality, setNationality] = useState('all');
  const [favorites, setFavorites] = useState([]);

  return (
    <UserDirectory
      search={search}
      setSearch={setSearch}
      nationality={nationality}
      setNationality={setNationality}
      favorites={favorites}
      setFavorites={setFavorites}
    />
  );
}
// Problem: Too many props, hard to maintain

// BETTER: Custom hooks (Composition)
function UserDirectory() {
  // Each concern has its own hook
  const { data: users, isLoading, error } = useUsers();
  const filters = useUserFilter(users);
  const favorites = useFavorites();

  return (
    <div>
      <SearchInput value={filters.searchTerm} onChange={filters.setSearchTerm} />
      <NationalityFilter value={filters.nationality} onChange={filters.setNationality} />
      <UserList users={filters.filteredUsers} />
    </div>
  );
}
// Benefit: Clear separation, reusable, testable

// ALTERNATIVE: Context (if deeply nested)
const FiltersContext = createContext(null);
const FavoritesContext = createContext(null);

function App() {
  return (
    <FiltersProvider>
      <FavoritesProvider>
        <UserDirectory />
      </FavoritesProvider>
    </FiltersProvider>
  );
}
// Use when: Props need to go more than 2 levels deep
```

**DECISION: Custom Hooks Pattern**

Reasoning:
- App is not deeply nested
- Custom hooks are simple and testable
- No unnecessary re-renders
- Easy to understand data flow

Trade-off:
- If app grows to 10+ components, consider Context
- If state needs to be shared globally, consider state management library

---

## Phase 3: Architecture Design

### Component Architecture

**The Architect's Question:** How do I break this down into components?

**Thinking Framework:** SOLID Principles for React

```markdown
S - Single Responsibility
  Each component should do ONE thing

O - Open/Closed
  Components should be extendable without modification

L - Liskov Substitution
  Components should be replaceable with variants

I - Interface Segregation
  Components should have minimal, focused props

D - Dependency Inversion
  Components should depend on abstractions (props), not concrete implementations
```

---

### Step 1: Component Tree Design

**The Architect's Process:**

1. **Start with a sketch** (mental or actual)
2. **Identify visual boundaries**
3. **Identify data boundaries**
4. **Identify responsibility boundaries**

```
Visual Sketch:
┌─────────────────────────────────────────┐
│ User Directory                          │
│ ┌─────────────────────────────────────┐ │
│ │ [All Users] [Favorites (3)]         │ │ ← Tab Navigation
│ └─────────────────────────────────────┘ │
│ ┌───────────────┬─────────────────────┐ │
│ │ Search: [   ] │ Nationality: [All] │ │ ← Filters
│ └───────────────┴─────────────────────┘ │
│ Showing 12 of 50 users                  │ ← Results count
│ ┌───────┬───────┬───────┬───────┐      │
│ │ User  │ User  │ User  │ User  │      │
│ │ Card  │ Card  │ Card  │ Card  │      │ ← User Grid
│ │  ♡    │  ♡    │  ♡    │  ♡    │      │
│ └───────┴───────┴───────┴───────┘      │
└─────────────────────────────────────────┘
```

---

**Component Breakdown - First Pass (Naive):**

```
- UserDirectory (everything)
```

**Problem:** One giant component, hard to maintain

---

**Component Breakdown - Second Pass (Better):**

```
UserDirectory
├── SearchInput
├── NationalityFilter
├── UserCard (repeated)
└── UserCard (repeated)
```

**Problem:** UserCard is repeated, no container for the grid

---

**Component Breakdown - Third Pass (Good):**

```
UserDirectory
├── FilterBar
│   ├── SearchInput
│   └── NationalityFilter
├── ResultsCount
└── UserGrid
    └── UserCard (mapped)
```

**Problem:** FilterBar might be unnecessary abstraction

---

**Component Breakdown - Final (Architect's Choice):**

```
UserDirectory (Container - owns state and logic)
├── TabNavigation (Stateless - receives props)
├── SearchInput (Controlled - receives value and onChange)
├── NationalityFilter (Controlled - receives value and onChange)
├── ResultsInfo (Stateless - receives counts)
└── UserGrid (Stateless - receives users array)
    └── UserCard (Stateless - receives user and callbacks)
```

**Why this structure?**

```markdown
UserDirectory:
- Responsibility: Orchestrate the feature
- Owns: All state (via hooks)
- Decides: What to render based on state
- Doesn't: Render complex UI (delegates to children)

TabNavigation:
- Responsibility: Display tabs and handle tab clicks
- Receives: activeTab, onTabChange, favoriteCount
- Doesn't: Know where favorite count comes from

SearchInput:
- Responsibility: Controlled input for search
- Receives: value, onChange
- Doesn't: Know what happens with the value

NationalityFilter:
- Responsibility: Controlled dropdown for nationality
- Receives: value, onChange, options
- Doesn't: Know where options come from

ResultsInfo:
- Responsibility: Display result counts
- Receives: filteredCount, totalCount
- Doesn't: Calculate counts

UserGrid:
- Responsibility: Layout users in a grid
- Receives: users array, loading, empty states
- Doesn't: Filter or fetch users

UserCard:
- Responsibility: Display single user
- Receives: user, isFavorite, onFavoriteToggle
- Doesn't: Know about filtering or favorites logic
```

---

**ARCHITECTURAL DECISION #6: Smart vs Dumb Components**

```typescript
// SMART (Container) Components:
// - Connect to data sources (hooks, context)
// - Manage state
// - Handle business logic
// - Coordinate child components

function UserDirectory() {
  // Smart: Fetches data
  const { data: users, isLoading } = useUsers();

  // Smart: Manages state
  const [activeTab, setActiveTab] = useState('all');

  // Smart: Business logic
  const displayUsers = activeTab === 'all' ? users : favoriteUsers;

  // Smart: Coordinates children
  return (
    <div>
      <TabNavigation activeTab={activeTab} onChange={setActiveTab} />
      <UserGrid users={displayUsers} />
    </div>
  );
}

// DUMB (Presentational) Components:
// - Receive data via props
// - No state (or only UI state)
// - No business logic
// - Highly reusable

function UserCard({ user, isFavorite, onFavoriteToggle }) {
  // Dumb: Just renders what it's given
  return (
    <div>
      <img src={user.picture.large} />
      <h3>{user.name.full}</h3>
      <button onClick={() => onFavoriteToggle(user)}>
        {isFavorite ? '❤️' : '🤍'}
      </button>
    </div>
  );
}
```

**DECISION: Use Smart/Dumb pattern**

Reasoning:
- Clear separation of concerns
- Dumb components are easily testable
- Dumb components are reusable
- Smart components are in one place (easy to find logic)

**When NOT to use this pattern:**
- Very simple apps (overkill)
- Server Components in Next.js (different paradigm)

---

### Step 2: Data Flow Architecture

**The Architect's Question:** How does data flow through the application?

**Data Flow Diagram:**

```
┌─────────────────────────────────────────────────────┐
│                    API Layer                        │
│  fetch('https://randomuser.me/api/?results=50')    │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│                React Query Layer                     │
│  useQuery({ queryKey: ['users'], queryFn })        │
│  - Caching                                          │
│  - Loading states                                   │
│  - Error handling                                   │
│  - Refetching                                       │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│              Custom Hook Layer                       │
│  useUsers() → returns User[]                        │
│  useUserFilter(users) → returns filtered users      │
│  useFavorites() → manages favorite IDs              │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│             Container Component                      │
│  UserDirectory                                      │
│  - Composes hooks                                   │
│  - Manages local UI state                           │
│  - Coordinates children                             │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│          Presentational Components                   │
│  UserCard, SearchInput, etc.                        │
│  - Receive props                                    │
│  - Render UI                                        │
│  - Call callbacks                                   │
└─────────────────────────────────────────────────────┘
```

**Key Principles:**

1. **Unidirectional Data Flow**
   - Data flows DOWN (props)
   - Events flow UP (callbacks)

2. **Single Source of Truth**
   - Users: React Query cache
   - Filters: Component state (or custom hook)
   - Favorites: localStorage + state

3. **Derived Data is Computed**
   - Don't store filtered users in state
   - Compute them with useMemo

---

**ARCHITECTURAL DECISION #7: Where to filter data?**

```typescript
// Option A: Filter in useQuery select
const { data } = useQuery({
  queryKey: ['users', searchTerm, nationality],
  queryFn: fetchUsers,
  select: (data) => filterUsers(data, searchTerm, nationality)
});
// Pros: Filtered data is cached by React Query
// Cons: Different search = different cache entry (memory waste for 50 users)

// Option B: Filter in component with useMemo
const { data: users } = useQuery({ queryKey: ['users'], queryFn: fetchUsers });
const filteredUsers = useMemo(
  () => filterUsers(users, searchTerm, nationality),
  [users, searchTerm, nationality]
);
// Pros: One cache entry, simple
// Cons: Recomputes on every filter change (fine for 50 users)

// Option C: Filter in custom hook
function useUserFilter(users) {
  const [searchTerm, setSearchTerm] = useState('');
  const [nationality, setNationality] = useState('all');

  const filteredUsers = useMemo(
    () => filterUsers(users, searchTerm, nationality),
    [users, searchTerm, nationality]
  );

  return { filteredUsers, searchTerm, setSearchTerm, nationality, setNationality };
}
// Pros: Encapsulated logic, reusable, testable
// Cons: Slightly more complex

DECISION: Option C (custom hook)

Reasoning:
- Encapsulates filter logic
- Easy to test
- Reusable across components
- Clear responsibility

When to use Option A:
- Server-side filtering
- Large datasets
- When filter criteria should be part of cache key

When to use Option B:
- Very simple apps
- One-off filtering
```

---

### Step 3: Performance Architecture

**The Architect's Question:** What are the performance considerations?

**Performance Analysis:**

```markdown
SCENARIO 1: User types in search input
Event: Every keystroke
Current:
  - setState called
  - Component re-renders
  - useMemo recalculates filtered users
  - UserGrid re-renders
  - Each UserCard re-renders

Bottleneck Analysis:
✓ 50 users - filtering is fast (< 1ms)
✗ Re-rendering 50 UserCards might be slow

OPTIMIZATION OPTIONS:

Option 1: Debounce search input
const [debouncedSearch, setDebouncedSearch] = useState('');
useEffect(() => {
  const timer = setTimeout(() => setDebouncedSearch(search), 300);
  return () => clearTimeout(timer);
}, [search]);
// Pros: Fewer filter operations
// Cons: Delayed feedback

Option 2: Virtualize the list (react-window)
<VirtualList items={filteredUsers}>
  {({ item }) => <UserCard user={item} />}
</VirtualList>
// Pros: Only renders visible items
// Cons: Added complexity

Option 3: Memoize UserCard
const UserCard = memo(({ user, isFavorite, onFavoriteToggle }) => {
  // ...
});
// Pros: Prevents unnecessary re-renders
// Cons: Callbacks need useCallback

DECISION for 50 users:
- No optimization needed (premature optimization)
- If users > 1000: Add virtualization
- If users > 10000: Add server-side filtering + pagination

DOCUMENT: "No performance optimization needed for current scale (50 users).
          Will revisit when user count exceeds 500."
```

---

```markdown
SCENARIO 2: User toggles favorite
Event: Click favorite button
Current:
  - favoriteIds state updates
  - useFavorites re-runs
  - Component re-renders
  - Only affected UserCard needs to re-render

OPTIMIZATION:

Option 1: Localize state to UserCard
// Each card manages its own favorite state
const [isFavorite, setIsFavorite] = useState(false);
// Pros: Minimal re-renders
// Cons: No single source of truth, hard to show favorites list

Option 2: Use Context for favorites
// Pros: Global access, minimal re-renders
// Cons: Added complexity

Option 3: Current approach (lift state to container)
// Pros: Simple, single source of truth
// Cons: Container re-renders

DECISION: Current approach is fine
- Container re-render is cheap (no expensive calculations)
- If re-renders become issue, use Context with careful memoization
```

---

**ARCHITECTURAL DECISION #8: When to optimize?**

**The Rule:**
1. **Measure first** - Use React DevTools Profiler
2. **Optimize only if slow** - Don't guess
3. **Document the reason** - Why you optimized

**Performance Budget for this app:**
```
- Initial load: < 2s
- Filter operation: < 100ms
- Favorite toggle: < 50ms
- Search typing: < 16ms (60fps)
```

If any of these are exceeded, THEN optimize.

---

## Phase 4: Implementation Planning

### The Architect's Build Order

**Question:** In what order should I build this?

**Naive Approach:**
```
1. Start with whatever seems easiest
2. Jump around between features
3. Fix things as they break
```

**Architect's Approach:**
```
Build in layers, from foundation to features
Each layer is testable before moving to next
```

---

### Layer-by-Layer Build Plan

**LAYER 0: Project Setup (15 min)**
```bash
Goal: Working development environment

Tasks:
□ Create Next.js project with TypeScript
□ Install dependencies (React Query, etc.)
□ Configure Tailwind
□ Setup project structure (folders)
□ Verify dev server runs

Verification:
✓ npm run dev works
✓ Can see default Next.js page
✓ No TypeScript errors
✓ Tailwind classes work

Exit criteria: Can start writing code
```

---

**LAYER 1: Type System (20 min)**
```typescript
Goal: Complete type safety for the entire feature

Tasks:
□ Create API response types
□ Create domain types (User)
□ Create UI types (component props)
□ Create utility types

File structure:
types/
  api.ts         // API response types
  domain.ts      // User, Nationality, etc.
  ui.ts          // Component props
  utils.ts       // Helper types

Verification:
✓ Can import types
✓ Types match actual API response
✓ No 'any' types

Exit criteria: All types defined, no compilation errors

WHY THIS MATTERS:
- Types guide implementation
- Catches errors early
- Acts as documentation
- Makes autocomplete work
```

---

**LAYER 2: Data Layer (30 min)**
```typescript
Goal: Successfully fetch and transform data

Tasks:
□ Setup QueryClient
□ Create Providers component
□ Wrap app in QueryClientProvider
□ Create fetchUsers function
□ Create API → Domain transformer
□ Create useUsers hook
□ Test with React Query DevTools

Files:
lib/
  queryClient.ts
  api.ts
  transformers.ts
hooks/
  useUsers.ts
app/
  providers.tsx
  layout.tsx

Verification:
✓ Data fetches successfully
✓ Can see data in React Query DevTools
✓ Data is transformed to User type
✓ Loading and error states work

Exit criteria: useUsers() hook returns typed User[]

WHY BUILD THIS FIRST:
- Everything else depends on data
- Isolate API/network issues
- Verify types match reality
```

---

**LAYER 3: Display Layer (30 min)**
```typescript
Goal: Display all users with no functionality

Tasks:
□ Create UserCard component
□ Create UserGrid component
□ Create UserDirectory container
□ Display all users in grid
□ Add loading state
□ Add error state
□ Make responsive

Files:
components/
  UserCard.tsx
  UserGrid.tsx
  UserDirectory.tsx

Verification:
✓ All 50 users display
✓ Images load
✓ Grid is responsive
✓ Loading state shows while fetching
✓ Error state shows on failure

Exit criteria: Can see all users in a grid

WHY THIS ORDER:
- Verify data → UI pipeline works
- Visual confirmation
- Can demo at this point
```

---

**LAYER 4: Search Feature (25 min)**
```typescript
Goal: Filter users by name

Tasks:
□ Create SearchInput component
□ Add search state to UserDirectory
□ Create filter logic (case-insensitive)
□ Connect search to filter
□ Add "no results" state
□ Add results count

Files:
components/
  SearchInput.tsx
hooks/
  useUserFilter.ts (optional, or inline first)

Verification:
✓ Can type in search box
✓ Results filter in real-time
✓ Case-insensitive matching works
✓ Matches first AND last name
✓ "No results" shows when appropriate
✓ Count is accurate

Exit criteria: Search works perfectly

WHY SEARCH BEFORE FILTER:
- Simpler (no dropdown logic)
- Tests filtering pipeline
- Gives quick win
```

---

**LAYER 5: Nationality Filter (20 min)**
```typescript
Goal: Filter users by nationality

Tasks:
□ Create NationalityFilter component
□ Extract unique nationalities from users
□ Add nationality state
□ Combine search + nationality filters
□ Add "All" option

Files:
components/
  NationalityFilter.tsx
hooks/
  useUserFilter.ts (extract logic here)

Verification:
✓ Dropdown shows unique nationalities
✓ "All" is default
✓ Filtering works
✓ Search + filter work together (AND logic)
✓ Nationalities are sorted

Exit criteria: Both filters work together

NOW YOU HAVE: Complete base functionality
```

---

**LAYER 6: Favorites Feature (45 min)**
```typescript
Goal: Allow users to save favorites

Tasks:
□ Create useFavorites hook
□ Add localStorage persistence
□ Add favorite button to UserCard
□ Create TabNavigation component
□ Add tab state to UserDirectory
□ Filter displayUsers by tab
□ Add empty state for favorites

Files:
hooks/
  useFavorites.ts
components/
  TabNavigation.tsx

Changes:
  UserCard.tsx (add favorite button)
  UserDirectory.tsx (add tab logic)

Verification:
✓ Can click favorite (🤍 → ❤️)
✓ Can unfavorite (❤️ → 🤍)
✓ Favorites persist on reload
✓ Favorites tab shows only favorites
✓ Search/filter work in favorites tab
✓ Count is accurate

Exit criteria: Complete favorites feature

NOW YOU HAVE: Full app with all features
```

---

**LAYER 7: Polish & Error Handling (30 min)**
```typescript
Goal: Professional-quality UI and UX

Tasks:
□ Add proper error boundaries
□ Add better loading states (skeleton?)
□ Add animations/transitions
□ Add accessibility (aria-labels, keyboard nav)
□ Add empty states for all scenarios
□ Fix any TypeScript warnings
□ Test edge cases
□ Clean up console.logs
□ Review code for improvements

Verification:
✓ No console errors or warnings
✓ All interactive elements keyboard accessible
✓ Images have alt text
✓ Inputs have labels
✓ Smooth transitions
✓ Handles all edge cases

Exit criteria: Production-ready code
```

---

### Incremental Testing Strategy

**The Architect's Approach:** Test at every layer

```markdown
LAYER 1 (Types):
Test: Do types compile? Does API response match types?
How: Create test file with mock API response, verify types work

LAYER 2 (Data):
Test: Does data fetch? Is it transformed correctly?
How: console.log in useUsers, check React Query DevTools

LAYER 3 (Display):
Test: Do users appear? Is grid responsive?
How: Visual inspection, resize browser

LAYER 4 (Search):
Test: Does search filter correctly?
How: Type various queries, check results

Test cases:
- "john" → shows Johns
- "JOHN" → shows Johns (case-insensitive)
- "xyz123" → shows "no results"
- "" (empty) → shows all users

LAYER 5 (Filter):
Test: Does nationality filter work?
How: Select each nationality, verify results

Test cases:
- "All" → shows all users
- "US" → shows only US users
- "US" + search "john" → shows only US users named John

LAYER 6 (Favorites):
Test: Does favorite persist?
How: Favorite a user, reload page, check if still favorited

Test cases:
- Click favorite → appears in favorites tab
- Click again → removed from favorites tab
- Reload → favorites persist
- Clear localStorage → favorites cleared

LAYER 7 (Polish):
Test: Is it accessible? Does it handle errors?
How: Use keyboard only, use screen reader, simulate API failure
```

---

## Phase 5: Risk & Edge Case Analysis

### The Architect's Question: "What could go wrong?"

**Systematic Risk Analysis:**

---

### Category 1: API Risks

```markdown
RISK: API is down or slow
Impact: Users see error or loading state indefinitely
Mitigation:
- Add timeout to fetch
- Show clear error message
- Add retry button
- Consider offline mode with cached data

Code:
const { data, isError, error, refetch } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
  retry: 2,
  retryDelay: 1000,
});

{isError && (
  <div>
    <p>Failed to load users: {error.message}</p>
    <button onClick={() => refetch()}>Try Again</button>
  </div>
)}
```

---

```markdown
RISK: API returns unexpected data structure
Impact: TypeScript errors, crashes
Mitigation:
- Validate API response at runtime
- Use type guards
- Graceful degradation

Code:
function isValidUser(obj: any): obj is ApiUserResponse {
  return (
    obj &&
    typeof obj.email === 'string' &&
    obj.name &&
    typeof obj.name.first === 'string' &&
    typeof obj.name.last === 'string'
  );
}

async function fetchUsers() {
  const response = await fetch(API_URL);
  const data = await response.json();

  // Validate
  const validUsers = data.results.filter(isValidUser);

  if (validUsers.length === 0) {
    throw new Error('No valid users in API response');
  }

  return validUsers;
}
```

---

```markdown
RISK: API returns duplicate users
Impact: React key warnings, visual duplicates
Mitigation:
- Deduplicate by email
- Log warning for debugging

Code:
function deduplicateUsers(users: User[]): User[] {
  const seen = new Set<string>();
  return users.filter(user => {
    if (seen.has(user.email)) {
      console.warn('Duplicate user:', user.email);
      return false;
    }
    seen.add(user.email);
    return true;
  });
}
```

---

### Category 2: User Input Risks

```markdown
RISK: User enters special characters in search
Impact: Regex errors, unexpected results
Test cases:
- "." (matches everything in regex)
- "*" (invalid regex)
- "é" (accented characters)
Mitigation:
- Escape special characters OR
- Use .includes() instead of regex

Code:
// Safe string matching
const matchesSearch =
  user.name.first.toLowerCase().includes(searchTerm.toLowerCase());
// No regex = no special character issues
```

---

```markdown
RISK: User enters very long search term
Impact: Performance issues, UI breaks
Test: Paste 10,000 character string
Mitigation:
- Limit input length
- Truncate display

Code:
<input
  maxLength={100}
  value={searchTerm}
  onChange={(e) => setSearchTerm(e.target.value)}
/>
```

---

### Category 3: State Risks

```markdown
RISK: localStorage is full
Impact: Favorites don't save
Mitigation:
- Wrap in try/catch
- Show user feedback
- Consider alternatives

Code:
function saveFavorites(ids: string[]) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(ids));
  } catch (error) {
    if (error instanceof DOMException && error.name === 'QuotaExceededError') {
      console.error('localStorage is full');
      // Show user message
      alert('Cannot save favorites: storage is full');
    }
  }
}
```

---

```markdown
RISK: localStorage contains invalid data
Impact: App crashes on load
Mitigation:
- Validate on load
- Clear if invalid
- Use fallback

Code:
function loadFavorites(): string[] {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) return [];

    const parsed = JSON.parse(stored);

    // Validate: should be array of strings
    if (!Array.isArray(parsed)) {
      console.warn('Invalid favorites data, clearing');
      localStorage.removeItem(STORAGE_KEY);
      return [];
    }

    return parsed.filter(item => typeof item === 'string');
  } catch (error) {
    console.error('Failed to load favorites:', error);
    return [];
  }
}
```

---

### Category 4: Rendering Risks

```markdown
RISK: Image fails to load
Impact: Broken image icon
Mitigation:
- Add onError handler
- Show placeholder/avatar
- Use alt text

Code:
const [imgError, setImgError] = useState(false);

<img
  src={imgError ? '/placeholder-avatar.png' : user.picture.large}
  alt={`${user.name.first} ${user.name.last}`}
  onError={() => setImgError(true)}
/>
```

---

```markdown
RISK: No users match filter
Impact: Empty screen, confusing UX
Mitigation:
- Show clear "no results" message
- Suggest actions

Code:
{filteredUsers.length === 0 && (
  <div className="text-center py-12">
    <p className="text-xl mb-2">No users found</p>
    <p className="text-gray-600">
      Try adjusting your search or filter criteria
    </p>
    <button onClick={() => {
      setSearchTerm('');
      setNationality('all');
    }}>
      Clear filters
    </button>
  </div>
)}
```

---

### Category 5: Performance Risks

```markdown
RISK: Too many re-renders
Impact: Slow, laggy UI
Detection: React DevTools Profiler
Mitigation:
- Use React.memo for expensive components
- Use useCallback for callbacks passed to memoized children
- Use useMemo for expensive calculations

Code:
// Only if profiling shows issue
const UserCard = memo(({ user, isFavorite, onToggleFavorite }) => {
  return <div>...</div>;
});

// In parent
const handleToggleFavorite = useCallback((user: User) => {
  // toggle logic
}, [/* dependencies */]);
```

---

```markdown
RISK: Memory leak from useEffect
Impact: Memory grows over time
Cause: Not cleaning up subscriptions/timers
Mitigation:
- Always return cleanup function
- Be careful with intervals/timers

Code:
// Debounce example with cleanup
useEffect(() => {
  const timer = setTimeout(() => {
    setDebouncedSearch(search);
  }, 300);

  return () => clearTimeout(timer); // CRITICAL: cleanup
}, [search]);
```

---

### Category 6: Accessibility Risks

```markdown
RISK: Not keyboard accessible
Impact: Keyboard users can't use app
Test: Try using app with Tab, Enter, Esc only
Mitigation:
- Use semantic HTML
- Add keyboard handlers
- Test with keyboard

Code:
// Make sure all interactive elements are accessible
<button onClick={handleClick}>Click me</button> // ✓ Built-in keyboard support
<div onClick={handleClick}>Click me</div>       // ✗ No keyboard support

// If must use div:
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      handleClick();
    }
  }}
>
  Click me
</div>
```

---

```markdown
RISK: Screen reader can't understand app
Impact: Visually impaired users can't use app
Test: Use screen reader (macOS: VoiceOver, Windows: NVDA)
Mitigation:
- Use semantic HTML
- Add ARIA labels
- Add alt text

Code:
// Labels for inputs
<label htmlFor="search">Search users</label>
<input id="search" ... />

// Alt text for images
<img alt={`${user.name.first} ${user.name.last}`} />

// ARIA labels for buttons
<button aria-label="Add to favorites">🤍</button>

// Live regions for dynamic content
<div aria-live="polite" aria-atomic="true">
  Showing {count} users
</div>
```

---

### Edge Case Checklist

**The Architect's Edge Case Framework:**

```markdown
For every feature, ask:

1. EMPTY STATE
   □ What if there's no data?
   □ What if filter returns no results?
   □ What if user has no favorites?

2. EXTREME VALUES
   □ What if search is 1 character?
   □ What if search is 1000 characters?
   □ What if user favorites all 50 users?
   □ What if there's only 1 user?

3. SPECIAL CHARACTERS
   □ What if name has é, ñ, 中?
   □ What if email has special characters?
   □ What if search includes regex special chars?

4. TIMING ISSUES
   □ What if user clicks favorite while still loading?
   □ What if user types very fast?
   □ What if API is slow?

5. BROWSER DIFFERENCES
   □ What if localStorage is disabled?
   □ What if cookies are disabled?
   □ What if JavaScript is disabled? (graceful degradation)

6. NETWORK CONDITIONS
   □ What if network is slow (3G)?
   □ What if API times out?
   □ What if user goes offline?

7. DATA INTEGRITY
   □ What if API returns null/undefined?
   □ What if image URL is broken?
   □ What if email is duplicate?
```

---

## Phase 6: Communication & Documentation

### The Architect's Communication Strategy

**In an interview, you're being evaluated on:**
1. Technical skills (30%)
2. Problem-solving process (40%)
3. Communication (30%)

**How to communicate like an architect:**

---

### Before You Code: The Design Brief

**Template:**

```markdown
# User Directory Feature - Design Brief

## Requirements Summary
- Fetch 50 users from Random User API
- Display in grid with image, name, email, nationality
- Search by name (case-insensitive, real-time)
- Filter by nationality
- Favorites with persistence

## Architecture Decisions

### Data Layer
- Use React Query for server state management
  Reason: Handles caching, loading, errors automatically
  Alternative considered: useEffect + useState (more manual)

### State Management
- Local state (useState) for filters
  Reason: No global state needed, app is simple
  Alternative: If app grows, consider Zustand

- Custom hooks for business logic (useUserFilter, useFavorites)
  Reason: Reusable, testable, separates concerns

### Component Structure
Smart/Dumb pattern:
- UserDirectory: Smart (owns state)
- UserCard, SearchInput, etc.: Dumb (receive props)
  Reason: Clear separation, easy testing

### Type System
Four layers: API types, Domain types, UI types, Utility types
  Reason: Clear boundaries, easy to change

### Performance
- No optimization for 50 users
- Use useMemo for filtering
- If needed later: virtualization or pagination
  Reason: Premature optimization is waste

## Implementation Order
1. Types → 2. Data → 3. Display → 4. Search → 5. Filter → 6. Favorites

## Risk Mitigation
- API failure: Error state + retry button
- Invalid data: Runtime validation
- localStorage full: Try/catch + user message
- Accessibility: Semantic HTML + ARIA labels

## Success Criteria
- All requirements met
- TypeScript strict mode, no errors
- Keyboard accessible
- Responsive design
- Clear code, well-organized
```

**When to present this:**
- At the start: "Before I code, let me outline my approach..."
- Get feedback: "Does this sound reasonable?"
- Shows: You think before you code

---

### During Coding: Think Aloud

**Template for explaining while coding:**

```
"I'm creating a custom hook called useUserFilter. This will encapsulate
all the filtering logic - both search and nationality filtering.

I'm using useMemo here because filtering is a computed value based on
the users array and filter criteria. Without useMemo, this would recalculate
on every render, which is wasteful.

The dependencies are users, searchTerm, and selectedNationality - any time
these change, we need to recompute the filtered list.

For the search logic, I'm using .includes() instead of regex because it's
simpler and handles special characters safely. I'm converting both the
search term and user names to lowercase to make it case-insensitive.

I'm checking both first and last name, so searching 'john' would match
both John Smith and Mary Johnson."
```

**What this shows:**
- You understand what you're writing
- You understand the "why"
- You can explain trade-offs
- You're aware of edge cases

---

### When Making Decisions: Explain Trade-offs

**Template:**

```
"I need to decide where to manage the favorites state.

Option 1: Keep it in localStorage only, read on every render
  Pros: Simple, always in sync
  Cons: Slow, causes re-renders

Option 2: Keep it in state, sync to localStorage
  Pros: Fast reads, React-friendly
  Cons: Need to keep in sync

Option 3: Use a state management library like Zustand
  Pros: Designed for this, good DevTools
  Cons: Overkill for this small app, extra dependency

I'm going with Option 2 because it's fast and fits the React paradigm.
I'll use a custom hook to encapsulate the sync logic, making it reusable
and testable."
```

**What this shows:**
- You consider multiple approaches
- You understand trade-offs
- You make reasoned decisions
- You're not just coding blindly

---

### When Stuck: Vocalize Your Debugging

**Template:**

```
"Hmm, the search isn't working. Let me debug this systematically.

First, let me check if the state is updating:
*adds console.log*
Okay, I can see searchTerm is updating when I type.

Next, is the filter function being called?
*adds console.log*
Yes, it's being called with the right search term.

Now let's check the filter logic:
*reads code*
Ah, I see the issue - I'm filtering by user.firstName, but the API
returns user.name.first. Let me fix that."
```

**What this shows:**
- You debug systematically, not randomly
- You use tools (console.log, DevTools)
- You don't panic when stuck
- You can figure things out

---

### At the End: Code Review Your Own Work

**Template:**

```
"Let me do a quick review of what I built:

✓ Data fetching: Using React Query, handles loading and errors
✓ Type safety: All components and functions are typed
✓ Filtering: Works for both search and nationality
✓ Favorites: Persist to localStorage
✓ Responsive: Grid adapts to screen size
✓ Accessible: All inputs have labels, images have alt text

Potential improvements if I had more time:
1. Add debouncing to search for large datasets
2. Add animation when filtering
3. Add unit tests for filtering logic
4. Add error boundary for runtime errors
5. Optimize with React.memo if performance becomes an issue

Trade-offs I made:
- Chose simplicity over optimization (fine for 50 users)
- Used custom hooks instead of global state (appropriate for app size)
- Client-side filtering instead of server-side (good for small dataset)
```

**What this shows:**
- You can evaluate your own code
- You know what "good enough" looks like
- You understand trade-offs
- You think about improvements

---

## Putting It All Together: The Interview Flow

### Pre-Interview (15 min)
```
1. Read requirements carefully
2. Understand the API (test it in browser/Postman)
3. Identify must-have vs nice-to-have
4. Sketch component structure
5. Mental outline of build order
```

### Interview Start (5 min)
```
1. Restate requirements to confirm understanding
2. Ask clarifying questions
3. Present architectural approach
4. Get feedback/alignment
5. Begin coding
```

### During Interview (80 min)
```
Follow build order:
- Types (10 min)
- Data layer (15 min)
- Display (15 min)
- Search (15 min)
- Filter (10 min)
- Favorites (if time) (15 min)

Think aloud throughout:
- Explain decisions
- Explain trade-offs
- Explain code
- Vocalize when stuck
```

### Interview End (10 min)
```
1. Review code
2. Test features
3. Fix obvious bugs
4. Explain trade-offs
5. Discuss improvements
6. Answer questions
```

---

## Final Architectural Principles

### 1. Understand Before Building

```
Bad: "I'll figure it out as I go"
Good: "Let me understand the data structure first"
```

### 2. Design Before Implementing

```
Bad: "I'll start with UserCard component"
Good: "Let me sketch the component tree first"
```

### 3. Build in Layers

```
Bad: Jump between features randomly
Good: Complete each layer before moving to next
```

### 4. Test Incrementally

```
Bad: Build everything, then test at the end
Good: Test each piece as you build it
```

### 5. Think About Edge Cases

```
Bad: Code happy path only
Good: "What if the API returns empty array?"
```

### 6. Make Reasoned Trade-offs

```
Bad: "I'll use Redux because I know it"
Good: "For this app size, local state is sufficient"
```

### 7. Communicate Your Thinking

```
Bad: Code silently
Good: "I'm using useMemo here because..."
```

### 8. Optimize When Needed, Not Before

```
Bad: "Let me add virtualization for 50 users"
Good: "I'll add optimization if performance becomes an issue"
```

---

## Practice Exercises

### Exercise 1: API Analysis

**Task:** Given a new API, analyze it architecturally

```
API: https://jsonplaceholder.typicode.com/users

Questions to answer:
1. What is the data structure?
2. What fields do we need vs what's available?
3. What is the unique identifier?
4. Are there any nested structures?
5. What could go wrong with this API?
6. How would you type this in TypeScript?
7. Do you need to transform the data?
```

### Exercise 2: Requirement Analysis

**Task:** Given requirements, extract implicit requirements

```
Requirement: "Build a todo app"

Explicit requirements:
- Add todos
- Mark as complete
- Delete todos

What are the implicit requirements?
(Think about: data, state, UX, errors, edge cases, accessibility)
```

### Exercise 3: Architecture Design

**Task:** Design component architecture for a feature

```
Feature: "User profile page with edit mode"

Design:
1. Component tree
2. State management strategy
3. Data flow
4. Edge cases
5. Performance considerations
```

### Exercise 4: Trade-off Analysis

**Task:** Compare approaches and justify choice

```
Problem: "Where to store form data while editing?"

Analyze:
- Local state
- Ref
- Form library (React Hook Form)
- Global state

What would you choose and why?
```

### Exercise 5: Communication Practice

**Task:** Record yourself explaining your code

```
Build a simple filter component
While building:
- Explain what you're doing
- Explain why
- Explain alternatives
- Explain trade-offs

Review the recording:
- Did you explain clearly?
- Did you mention trade-offs?
- Did you sound confident?
```

---

## Architectural Thinking Checklist

Before any interview:

**Understanding Phase:**
- [ ] I've read the requirements multiple times
- [ ] I've tested the API and understood the response structure
- [ ] I've identified explicit and implicit requirements
- [ ] I've clarified ambiguous requirements
- [ ] I've prioritized must-have vs nice-to-have

**Design Phase:**
- [ ] I've sketched the component tree
- [ ] I've decided on state management approach
- [ ] I've identified data flow
- [ ] I've chosen appropriate tools/libraries
- [ ] I've considered edge cases
- [ ] I've thought about performance
- [ ] I've thought about accessibility

**Planning Phase:**
- [ ] I've decided on build order
- [ ] I've identified testable milestones
- [ ] I've estimated time for each layer
- [ ] I've identified risky parts

**Communication Phase:**
- [ ] I can explain my architecture
- [ ] I can justify my decisions
- [ ] I can explain trade-offs
- [ ] I can vocalize my thought process
- [ ] I can adapt based on feedback

**During Interview:**
- [ ] I explain as I code
- [ ] I test incrementally
- [ ] I handle being stuck gracefully
- [ ] I stay calm under pressure
- [ ] I communicate clearly

**Post-Interview:**
- [ ] I review my code
- [ ] I can explain improvements
- [ ] I can discuss trade-offs made
- [ ] I can answer questions confidently

---

## Your Next Steps

### Week 1: Practice Requirement Analysis
- Take 5 different project ideas
- For each, extract explicit and implicit requirements
- Ask clarifying questions (even if hypothetical)
- Prioritize requirements

### Week 2: Practice API Analysis
- Find 5 different public APIs
- Analyze each deeply
- Design TypeScript types
- Identify edge cases
- Design transformers

### Week 3: Practice Architecture Design
- Design component trees for different features
- Choose state management approaches
- Design data flow
- Justify decisions
- Compare alternatives

### Week 4: Practice Communication
- Build features while explaining out loud
- Record yourself
- Review and improve
- Practice explaining trade-offs
- Get comfortable vocalizing thoughts

### Week 5: Practice Full Flow
- Do mock interviews
- Follow full process: understand → design → plan → build
- Time yourself
- Review afterward
- Identify areas to improve

### Week 6: Combine with Coding Practice
- Use this architectural thinking with actual coding
- Build complete features
- Document decisions
- Review your own code
- Explain to someone else

---

## Remember

**You failed the interview not because you couldn't code.**

**You failed because you couldn't:**
1. Understand the requirements deeply
2. Analyze the data structure
3. Design a solution architecture
4. Make reasoned decisions
5. Debug code you didn't understand
6. Communicate your thinking

**This guide teaches you to think like an architect.**

**Next time:**
- You'll understand the problem before coding
- You'll design before implementing
- You'll make reasoned trade-offs
- You'll build systematically
- You'll communicate clearly
- You'll debug confidently

**Because you'll think architecturally.**

---

## The Architect's Mindset

```
Beginner thinks: "What code do I write?"
Architect thinks: "What problem am I solving?"

Beginner thinks: "Let me start coding"
Architect thinks: "Let me understand the requirements"

Beginner thinks: "I'll use what I know"
Architect thinks: "What's the right tool for this?"

Beginner thinks: "Make it work"
Architect thinks: "Make it right, then make it work"

Beginner thinks: "Code first, design later"
Architect thinks: "Design first, code follows"

Beginner thinks: "Hope it works"
Architect thinks: "I know it will work, here's why"
```

**Become the architect.**

Good luck!
