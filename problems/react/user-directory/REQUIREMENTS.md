# Requirements - User Directory with Search & Filter

## Problem Description

Create a user directory web application using Next.js/React that fetches user data from a public API and displays it with search and filter functionality.

---

## 1. Data Requirements

### 1.1 Data Source
- **API:** Random User API
- **Endpoint:** https://randomuser.me/api/?results=50
- **Method:** GET
- **Data Count:** 50 users

### 1.2 Data Fields to Display
**Required:**
- Profile image (large size)
- First name
- Last name
- Email address
- Nationality code

**Available but not required:**
- Gender
- Location
- Date of birth
- Phone numbers
- Login credentials
- Registration date

### 1.3 Data Structure
- Define TypeScript interfaces for User data
- Handle API response structure
- Transform data if needed for application use

---

## 2. Functional Requirements

### 2.1 Data Fetching
- **FR-1.1:** Application shall fetch 50 users from Random User API on initial load
- **FR-1.2:** Application shall store fetched data in application state
- **FR-1.3:** Application shall handle API request failures gracefully
- **FR-1.4:** Application shall show loading indicator while data is being fetched
- **FR-1.5:** Application shall cache fetched data appropriately

### 2.2 User Display
- **FR-2.1:** Application shall display all users in a grid layout
- **FR-2.2:** Each user card shall show:
  - Profile image
  - Full name (first + last)
  - Email address
  - Nationality
- **FR-2.3:** Grid shall be responsive (adjust columns based on screen size)
- **FR-2.4:** Application shall show total user count

### 2.3 Search Functionality
- **FR-3.1:** Application shall provide a search input field
- **FR-3.2:** Search shall filter users by first name OR last name
- **FR-3.3:** Search shall be case-insensitive
- **FR-3.4:** Search results shall update in real-time as user types
- **FR-3.5:** Application shall show filtered count
- **FR-3.6:** Empty search shall display all users

### 2.4 Filter by Nationality
- **FR-4.1:** Application shall provide a nationality dropdown
- **FR-4.2:** Dropdown shall contain unique nationalities from user data
- **FR-4.3:** Dropdown shall have "All" as default option
- **FR-4.4:** Nationalities in dropdown shall not have duplicates
- **FR-4.5:** Selecting nationality shall filter displayed users
- **FR-4.6:** Search and nationality filter shall work together (AND logic)

### 2.5 Favorites Feature (Bonus)
- **FR-5.1:** Each user card shall have a favorite button
- **FR-5.2:** Clicking favorite shall toggle favorite status
- **FR-5.3:** Favorite status shall be visually indicated
- **FR-5.4:** Favorites shall persist across page reloads
- **FR-5.5:** Application shall provide "Favorites" view/tab
- **FR-5.6:** Favorites view shall show only favorited users
- **FR-5.7:** Search and filter shall work in Favorites view

---

## 3. Non-Functional Requirements

### 3.1 Performance
- **NFR-1.1:** Initial page load shall complete within 3 seconds
- **NFR-1.2:** Search filtering shall complete within 100ms
- **NFR-1.3:** UI shall remain responsive during all operations
- **NFR-1.4:** No unnecessary re-renders

### 3.2 Usability
- **NFR-2.1:** Interface shall be intuitive and easy to use
- **NFR-2.2:** All interactive elements shall have clear visual feedback
- **NFR-2.3:** Error messages shall be clear and actionable
- **NFR-2.4:** Loading states shall be clear and informative

### 3.3 Accessibility
- **NFR-3.1:** All images shall have alt text
- **NFR-3.2:** All form inputs shall have labels
- **NFR-3.3:** Application shall be keyboard navigable
- **NFR-3.4:** Interactive elements shall have appropriate ARIA labels
- **NFR-3.5:** Color contrast shall meet WCAG AA standards

### 3.4 Responsive Design
- **NFR-4.1:** Application shall work on mobile devices (320px+)
- **NFR-4.2:** Application shall work on tablets (768px+)
- **NFR-4.3:** Application shall work on desktop (1024px+)
- **NFR-4.4:** Grid layout shall adjust columns based on viewport:
  - Mobile: 1 column
  - Tablet: 2-3 columns
  - Desktop: 4+ columns

### 3.5 Code Quality
- **NFR-5.1:** All code shall be written in TypeScript with strict mode
- **NFR-5.2:** No `any` types shall be used
- **NFR-5.3:** All functions shall have clear, descriptive names
- **NFR-5.4:** Code shall follow React best practices
- **NFR-5.5:** Components shall have single responsibility
- **NFR-5.6:** No console.log statements in production code

### 3.6 Browser Compatibility
- **NFR-6.1:** Application shall work in Chrome (latest)
- **NFR-6.2:** Application shall work in Firefox (latest)
- **NFR-6.3:** Application shall work in Safari (latest)
- **NFR-6.4:** Application shall work in Edge (latest)

---

## 4. Technical Constraints

### 4.1 Technology Stack
- **TC-1.1:** Must use Next.js 14+ with App Router
- **TC-1.2:** Must use TypeScript
- **TC-1.3:** Must use TanStack Query (React Query) for data fetching
- **TC-1.4:** Must use Tailwind CSS for styling
- **TC-1.5:** Shall use functional components and hooks (no class components)

### 4.2 Data Management
- **TC-2.1:** Use React Query for server state (API data)
- **TC-2.2:** Use React hooks (useState, useMemo, etc.) for client state
- **TC-2.3:** Use localStorage for favorites persistence
- **TC-2.4:** No global state management library required (no Redux, Zustand, etc.)

---

## 5. User Interface Requirements

### 5.1 Layout Structure
```
┌─────────────────────────────────────────┐
│ User Directory                          │ ← Header/Title
├─────────────────────────────────────────┤
│ [All Users] [Favorites (3)]             │ ← Tab Navigation (Bonus)
├─────────────────────────────────────────┤
│ Search: [____________]  | Nationality: [All ▼] │ ← Filters
├─────────────────────────────────────────┤
│ Showing 12 of 50 users                  │ ← Results Count
├─────────────────────────────────────────┤
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐        │
│ │User │ │User │ │User │ │User │        │ ← User Grid
│ │Card │ │Card │ │Card │ │Card │        │
│ └─────┘ └─────┘ └─────┘ └─────┘        │
└─────────────────────────────────────────┘
```

### 5.2 User Card Design
```
┌──────────────────┐
│   [Profile Pic]  │ ← Image (rounded)
│                  │
│   John Doe   ♡   │ ← Name + Favorite button
│ john@example.com │ ← Email
│      [US]        │ ← Nationality badge
└──────────────────┘
```

### 5.3 States to Design
1. **Loading State:** Spinner or skeleton loader
2. **Error State:** Error message with retry button
3. **Empty State:** "No users found" message
4. **No Favorites State:** "Add favorites to see them here"

---

## 6. Edge Cases & Error Handling

### 6.1 API Errors
- API is unreachable
- API returns error status
- API returns unexpected data structure
- API returns empty results
- Request timeout

### 6.2 User Input
- Empty search query
- Search with no matches
- Special characters in search
- Very long search terms
- Filter combination returns no results

### 6.3 Data Integrity
- Duplicate users in API response
- Missing required fields
- Invalid image URLs
- Null or undefined values

### 6.4 Favorites (Bonus)
- localStorage is full
- localStorage is disabled
- Invalid data in localStorage
- Favoriting while data is loading
- Favorite user that no longer exists

### 6.5 Browser & Device
- Small screen sizes (< 320px)
- Very large screen sizes (> 2000px)
- Slow network connection
- JavaScript disabled (graceful degradation)
- Keyboard-only navigation

---

## 7. Success Criteria

### 7.1 Must Pass
- ✅ All P0 functional requirements implemented
- ✅ TypeScript strict mode with no errors
- ✅ No console errors or warnings
- ✅ Responsive on mobile, tablet, desktop
- ✅ Loading and error states working
- ✅ Search and filter working correctly
- ✅ Clean, organized code

### 7.2 Should Pass
- ✅ Favorites feature implemented
- ✅ All edge cases handled
- ✅ Keyboard accessible
- ✅ Good performance (no lag)
- ✅ Professional UI/UX

### 7.3 Nice to Have
- ✅ Smooth animations
- ✅ Debounced search
- ✅ Test coverage
- ✅ Documentation

---

## 8. Bonus Requirements

### 8.1 Mock API Search
- Explain how you would implement server-side search
- Discuss debouncing strategy
- Handle loading states during search
- Discuss caching strategy

### 8.2 Additional Features (Time Permitting)
- Sorting (by name, email, nationality)
- Pagination
- Detail modal on user click
- Export to CSV
- Dark mode
- Print-friendly view

---

## 9. Deliverables

### 9.1 Code
- Complete, working Next.js application
- All source code in src/ directory
- Proper file organization
- Clean, commented code

### 9.2 Setup
- README.md with setup instructions
- package.json with all dependencies
- No environment variables required (or .env.example provided)

### 9.3 Documentation (Optional)
- Architecture decisions explained
- Component structure documented
- Any assumptions made
- Known limitations

---

## 10. Time Allocation Suggestion

For a 90-120 minute interview:

- **15 min:** Requirements analysis, planning
- **60-75 min:** Implementation
  - 15 min: Setup & types
  - 20 min: Data fetching & display
  - 15 min: Search functionality
  - 10 min: Filter functionality
  - 15 min: Favorites (if time)
  - 5 min: Polish & error handling
- **15 min:** Testing, debugging, review

---

## 11. Evaluation Criteria

Candidates will be evaluated on:

1. **Problem Understanding** (15%)
   - Asked clarifying questions
   - Understood requirements
   - Identified edge cases

2. **Architecture & Design** (25%)
   - Component structure
   - State management decisions
   - Type definitions
   - Code organization

3. **Implementation** (30%)
   - Code correctness
   - TypeScript usage
   - React best practices
   - Clean code

4. **Edge Cases & Errors** (15%)
   - Handled error states
   - Considered edge cases
   - Input validation

5. **Communication** (15%)
   - Explained decisions
   - Thought out loud
   - Asked for feedback
   - Professional demeanor

---

**Note:** This is a comprehensive requirements document. In a real interview, requirements may be less detailed, and asking clarifying questions is expected and encouraged.
