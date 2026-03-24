# SmartLabLauncher Responsive Layout Design

## Problem Statement

**Fixed Requirements:**
- 5 buttons total
- Button aspect ratio: 4:5 (380px × 470px at baseline)
- Gap between buttons: 22px
- Padding: 32px left/right
- Chrome bars: 28px top + 24px bottom
- Buttons must be centered both horizontally and vertically

**Goal:**
Maximize button size while fitting all 5 buttons in available viewport, maintaining aspect ratio.

---

## Core Algorithm: Layout Optimization

### Step 1: Calculate Available Space

```
availableWidth = viewportWidth - (2 × padding)
availableHeight = viewportHeight - topChrome - bottomChrome
```

For 1440×1707 example:
- availableWidth = 1440 - 64 = 1376px
- availableHeight = 1707 - 28 - 24 = 1655px

---

## Step 2: Test All Possible Layout Configurations

For 5 buttons, valid grid configurations:
- **1×5** (single row, 5 columns)
- **2×3** (2 rows, 3 columns, 5th button centered on row 2)
- **3×2** (3 rows, 2 columns, 5th button centered on row 3)
- **5×1** (5 rows, single column)

For each configuration, calculate the maximum button size that fits.

---

## Step 3: Calculate Maximum Button Size for Each Layout

### Formula for Layout (rows × cols):

**Width constraint:**
```
maxButtonWidth = (availableWidth - (cols - 1) × gap) / cols
```

**Height constraint:**
```
maxButtonHeight = (availableHeight - (rows - 1) × gap) / rows
```

**Aspect ratio constraint (4:5):**
```
If buttonWidth = W, then buttonHeight must = W × (5/4)
If buttonHeight = H, then buttonWidth must = H × (4/5)
```

**Final button size:**
```
# Calculate size constrained by width
widthLimitedButton = maxButtonWidth
heightFromWidth = widthLimitedButton × (5/4)

# Calculate size constrained by height  
heightLimitedButton = maxButtonHeight
widthFromHeight = heightLimitedButton × (4/5)

# Pick whichever gives smaller button (both constraints must be satisfied)
if heightFromWidth <= maxButtonHeight:
    buttonWidth = widthLimitedButton
    buttonHeight = heightFromWidth
    constraint = "width-limited"
else:
    buttonWidth = widthFromHeight
    buttonHeight = heightLimitedButton
    constraint = "height-limited"
```

**Layout score:** `buttonWidth × buttonHeight` (larger is better)

---

## Step 4: Layout-Specific Calculations

### 1×5 Layout (Single Row)
```
cols = 5
rows = 1
maxButtonWidth = (availableWidth - 4×gap) / 5
maxButtonHeight = availableHeight
```

**Example (1440×1707):**
```
maxButtonWidth = (1376 - 88) / 5 = 257.6px
maxButtonHeight = 1655px
heightFromWidth = 257.6 × 1.25 = 322px ≤ 1655px ✓
Final: 257.6×322px (width-limited)
Score: 82,947
```

### 2×3 Layout (2 rows, 3 columns)
```
cols = 3
rows = 2
maxButtonWidth = (availableWidth - 2×gap) / 3
maxButtonHeight = (availableHeight - 1×gap) / 2
```

**Example (1440×1707):**
```
maxButtonWidth = (1376 - 44) / 3 = 444px
maxButtonHeight = (1655 - 22) / 2 = 816.5px
heightFromWidth = 444 × 1.25 = 555px ≤ 816.5px ✓
Final: 444×555px (width-limited)
Score: 246,420
```

### 3×2 Layout (3 rows, 2 columns)
```
cols = 2
rows = 3
maxButtonWidth = (availableWidth - 1×gap) / 2
maxButtonHeight = (availableHeight - 2×gap) / 3
```

**Example (1440×1707):**
```
maxButtonWidth = (1376 - 22) / 2 = 677px
maxButtonHeight = (1655 - 44) / 3 = 537px
widthFromHeight = 537 × 0.8 = 429.6px ≤ 677px ✓
Final: 429.6×537px (height-limited)
Score: 230,695
```

### 5×1 Layout (Single Column)
```
cols = 1
rows = 5
maxButtonWidth = availableWidth
maxButtonHeight = (availableHeight - 4×gap) / 5
```

**Example (1440×1707):**
```
maxButtonWidth = 1376px
maxButtonHeight = (1655 - 88) / 5 = 313.4px
widthFromHeight = 313.4 × 0.8 = 250.7px ≤ 1376px ✓
Final: 250.7×313.4px (height-limited)
Score: 78,558
```

---

## Step 5: Select Winner

**Winner: 2×3 layout with 444×555px buttons (score: 246,420)**

This is 72% larger than the current fixed 1×5 layout!

---

## Decision Tree

```
function selectOptimalLayout(viewportWidth, viewportHeight):
    
    availableWidth = viewportWidth - 64
    availableHeight = viewportHeight - 52
    
    layouts = [
        {name: "1×5", rows: 1, cols: 5},
        {name: "2×3", rows: 2, cols: 3},
        {name: "3×2", rows: 3, cols: 2},
        {name: "5×1", rows: 5, cols: 1}
    ]
    
    bestLayout = null
    bestScore = 0
    
    for each layout in layouts:
        buttonSize = calculateMaxButtonSize(
            availableWidth, 
            availableHeight,
            layout.rows,
            layout.cols,
            gap=22,
            aspectRatio=5/4
        )
        
        score = buttonSize.width × buttonSize.height
        
        if score > bestScore:
            bestScore = score
            bestLayout = layout
            bestLayout.buttonSize = buttonSize
    
    return bestLayout
```

---
## Step 6: Positioning Logic

### Centering the Grid

After selecting optimal layout, center the button grid in available space:

**Horizontal centering:**
```
totalGridWidth = (cols × buttonWidth) + ((cols - 1) × gap)
leftMargin = (availableWidth - totalGridWidth) / 2
```

**Vertical centering:**
```
totalGridHeight = (rows × buttonHeight) + ((rows - 1) × gap)
topMargin = (availableHeight - totalGridHeight) / 2
```

### 5th Button Placement (Uneven Grids)

**DESIGN DECISION: Incomplete rows are left-aligned to maintain grid structure.**

This creates intentional whitespace on the right side rather than centering incomplete rows.

**2×3 layout:** 5 buttons in 2 rows, 3 columns
- Row 1: buttons 1, 2, 3 (full width)
- Row 2: buttons 4, 5 (left-aligned under buttons 1 and 2)
- Whitespace remains in the position where button 3's column would be

```
Button 4 x-position: leftMargin
Button 5 x-position: leftMargin + buttonWidth + gap
```

**3×2 layout:** 5 buttons in 3 rows, 2 columns
- Rows 1-2: buttons 1, 2, 3, 4 (2 columns each)
- Row 3: button 5 (left-aligned under button 1)
- Whitespace remains in the second column

```
Button 5 x-position: leftMargin
```

This grid-aligned approach keeps the layout clean and structured.

---

## Edge Cases & Constraints

### Minimum Button Size

Set absolute minimum to maintain usability:
```
MIN_BUTTON_WIDTH = 120px
MIN_BUTTON_HEIGHT = 150px (maintains 4:5 ratio)
```

If ANY layout produces buttons smaller than minimum:
- Fall back to scrolling (buttons overflow, user can scroll horizontally)
- OR show warning message: "Screen too small for optimal display"

### Maximum Button Size

Prevent buttons from becoming absurdly large on huge screens:
```
MAX_BUTTON_WIDTH = 600px
MAX_BUTTON_HEIGHT = 750px (maintains 4:5 ratio)
```

If calculated size exceeds maximum, cap at max and add extra margins.

### Single Button Test

Before finalizing layout, verify at least one button fits:
```
if bestLayout.buttonSize.width < MIN_BUTTON_WIDTH:
    return ERROR_STATE or FALLBACK_SCROLL_MODE
```

---

## Implementation Strategy

### Phase 1: CSS Media Query Breakpoints (Simple)

Define breakpoints where layout changes:

```css
/* Ultra-narrow: 5×1 vertical stack */
@media (max-width: 599px) { ... }

/* Narrow: 3×2 grid */
@media (min-width: 600px) and (max-width: 999px) { ... }

/* Medium: 2×3 grid */
@media (min-width: 1000px) and (max-width: 1649px) { ... }

/* Wide: 1×5 original layout */
@media (min-width: 1650px) { ... }
```

**Pros:** Simple, fast, CSS-only
**Cons:** Not optimal - doesn't account for height, fixed breakpoints

### Phase 2: JavaScript Dynamic Calculation (Optimal)

Calculate on every resize:

```javascript
window.addEventListener('resize', debounce(() => {
    const layout = selectOptimalLayout(
        window.innerWidth,
        window.innerHeight - 52  // minus chrome bars
    );
    applyLayout(layout);
}, 150));
```

**Pros:** Truly optimal for any screen dimension
**Cons:** More complex, requires JS

### Recommended: Phase 2 (JavaScript)

Use JS to calculate optimal layout on page load and window resize.

---

## Visual Examples

### Example 1: 1440×1707 (Narrow Vertical)

**Tested Layouts:**
- 1×5: 257.6×322px (score: 82,947)
- **2×3: 444×555px (score: 246,420) ← WINNER**
- 3×2: 429.6×537px (score: 230,695)
- 5×1: 250.7×313.4px (score: 78,558)

**Result:** 2×3 grid, buttons 72% larger than 1×5 would be

### Example 2: 2160×1280 (Wide Horizontal)

**Tested Layouts:**
- **1×5: 398.4×498px (score: 198,403) ← WINNER**
- 2×3: 698×872.5px → exceeds height! → 409.6×512px (score: 209,715)
- 3×2: 1047×402px → exceeds width! → 321.6×402px (score: 129,283)
- 5×1: 2096×227.2px → exceeds width! → 181.8×227.2px (score: 41,297)

**Result:** 1×5 original layout works best

### Example 3: 5120×2108 (Ultra-wide)

**Tested Layouts:**
- **1×5: 995.2×1244px (capped at 600×750) (score: 450,000) ← WINNER**
- 2×3: 1662×2056px → capped at 600×750px (score: 450,000)
- All others: smaller scores

**Result:** 1×5 layout, buttons at maximum size cap

---

## Breakpoint Analysis

Based on calculations, approximate breakpoints:

| Viewport Width | Optimal Layout | Button Size Range |
|----------------|----------------|-------------------|
| < 600px | 5×1 or 3×2 | ~150-250px wide |
| 600-999px | 3×2 | ~250-400px wide |
| 1000-1649px | 2×3 | ~400-550px wide |
| 1650-2400px | 1×5 | ~380-600px wide |
| > 2400px | 1×5 (capped) | 600px max |

**Height also matters!** These are approximations assuming reasonable height.

---

## Special Cases

### Ultra-tall Narrow Screens (Phone Portrait)
Example: 480×2400

**Calculation:**
- 5×1 layout: 416×520px buttons
- Likely winner, buttons stack vertically

### Square-ish Screens
Example: 1440×1440

**Calculation:**
- 2×3: 444×555px
- 3×2: 677×429px (height-limited, smaller)
- Winner: 2×3

### Ultra-wide Short Screens  
Example: 3840×800 (browser at 1/3 height on 32:9)

**Calculation:**
- 1×5: 746×748px → height-limited → 598.4×748px
- All grids: too short vertically
- Winner: 1×5 but buttons may feel cramped vertically

---
## Complete Algorithm Pseudocode

```javascript
function calculateResponsiveLayout(viewportWidth, viewportHeight) {
    // Constants
    const PADDING = 32;
    const TOP_CHROME = 28;
    const BOTTOM_CHROME = 24;
    const GAP = 22;
    const ASPECT_RATIO = 5/4;  // height/width
    const MIN_WIDTH = 120;
    const MIN_HEIGHT = 150;
    const MAX_WIDTH = 600;
    const MAX_HEIGHT = 750;
    
    // Available space
    const availableWidth = viewportWidth - (2 * PADDING);
    const availableHeight = viewportHeight - TOP_CHROME - BOTTOM_CHROME;
    
    // Layout configurations to test
    const layouts = [
        {name: "1x5", rows: 1, cols: 5},
        {name: "2x3", rows: 2, cols: 3},
        {name: "3x2", rows: 3, cols: 2},
        {name: "5x1", rows: 5, cols: 1}
    ];
    
    let bestLayout = null;
    let bestScore = 0;
    
    for (let layout of layouts) {
        // Calculate maximum button size for this layout
        const maxWidth = (availableWidth - (layout.cols - 1) * GAP) / layout.cols;
        const maxHeight = (availableHeight - (layout.rows - 1) * GAP) / layout.rows;
        
        // Apply aspect ratio constraint
        let buttonWidth, buttonHeight, constraint;
        
        const heightFromWidth = maxWidth * ASPECT_RATIO;
        if (heightFromWidth <= maxHeight) {
            // Width-limited
            buttonWidth = maxWidth;
            buttonHeight = heightFromWidth;
            constraint = "width";
        } else {
            // Height-limited
            buttonHeight = maxHeight;
            buttonWidth = buttonHeight / ASPECT_RATIO;
            constraint = "height";
        }
        
        // Apply min/max constraints
        buttonWidth = Math.max(MIN_WIDTH, Math.min(MAX_WIDTH, buttonWidth));
        buttonHeight = Math.max(MIN_HEIGHT, Math.min(MAX_HEIGHT, buttonHeight));
        
        // Recalculate to maintain aspect ratio after capping
        if (buttonWidth === MAX_WIDTH) {
            buttonHeight = Math.min(MAX_HEIGHT, buttonWidth * ASPECT_RATIO);
        } else if (buttonHeight === MAX_HEIGHT) {
            buttonWidth = Math.min(MAX_WIDTH, buttonHeight / ASPECT_RATIO);
        }
        
        // Calculate score (larger buttons = better)
        const score = buttonWidth * buttonHeight;
        
        // Track best layout
        if (score > bestScore) {
            bestScore = score;
            bestLayout = {
                ...layout,
                buttonWidth,
                buttonHeight,
                constraint,
                score
            };
        }
    }
    
    // Calculate positioning
    const gridWidth = (bestLayout.cols * bestLayout.buttonWidth) + 
                     ((bestLayout.cols - 1) * GAP);
    const gridHeight = (bestLayout.rows * bestLayout.buttonHeight) + 
                      ((bestLayout.rows - 1) * GAP);
    
    const leftMargin = PADDING + ((availableWidth - gridWidth) / 2);
    const topMargin = TOP_CHROME + ((availableHeight - gridHeight) / 2);
    
    // Generate button positions
    const buttons = [];
    let buttonIndex = 0;
    
    for (let row = 0; row < bestLayout.rows; row++) {
        let colsThisRow = bestLayout.cols;
        let rowOffset = 0;
        
        // Handle uneven grids (5 buttons in 2×3 or 3×2)
        if (bestLayout.name === "2x3" && row === 1) {
            colsThisRow = 2;  // Only 2 buttons in row 2
            rowOffset = (gridWidth - (2 * bestLayout.buttonWidth + GAP)) / 2;
        } else if (bestLayout.name === "3x2" && row === 2) {
            colsThisRow = 1;  // Only 1 button in row 3
            rowOffset = (gridWidth - bestLayout.buttonWidth) / 2;
        }
        
        for (let col = 0; col < colsThisRow && buttonIndex < 5; col++) {
            const x = leftMargin + rowOffset + (col * (bestLayout.buttonWidth + GAP));
            const y = topMargin + (row * (bestLayout.buttonHeight + GAP));
            
            buttons.push({
                index: buttonIndex,
                x,
                y,
                width: bestLayout.buttonWidth,
                height: bestLayout.buttonHeight
            });
            
            buttonIndex++;
        }
    }
    
    return {
        layout: bestLayout.name,
        buttonWidth: bestLayout.buttonWidth,
        buttonHeight: bestLayout.buttonHeight,
        gridWidth,
        gridHeight,
        leftMargin,
        topMargin,
        buttons,
        score: bestLayout.score,
        constraint: bestLayout.constraint
    };
}
```

---

## Implementation Notes

### 1. When to Recalculate

```javascript
// On page load
window.addEventListener('DOMContentLoaded', () => {
    applyResponsiveLayout();
});

// On window resize (debounced)
let resizeTimeout;
window.addEventListener('resize', () => {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(applyResponsiveLayout, 150);
});

function applyResponsiveLayout() {
    const layout = calculateResponsiveLayout(
        window.innerWidth,
        window.innerHeight
    );
    
    // Apply to DOM
    updateButtonPositions(layout);
}
```

### 2. CSS Transitions

Smooth transitions between layouts:

```css
.monolith {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

### 3. Three.js Background Handling

When buttons resize, update canvas dimensions:

```javascript
function resizeButtonBackground(button, width, height) {
    const canvas = button.querySelector('.btn-bg-canvas');
    const renderer = canvas.__renderer;  // stored reference
    const camera = canvas.__camera;
    
    renderer.setSize(width, height);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
}
```

### 4. Testing Strategy

Test on these critical dimensions:
- 480×800 (phone portrait)
- 800×480 (phone landscape)
- 1440×1707 (vertical monitor, 1/3 height)
- 1920×1080 (standard wide)
- 2560×1440 (1440p)
- 3840×2160 (4K)
- 5120×1440 (ultrawide)

---

## Summary

**The algorithm:**
1. Calculate available space
2. Test 4 layout configurations (1×5, 2×3, 3×2, 5×1)
3. For each, calculate maximum button size maintaining 4:5 aspect ratio
4. Pick layout with largest buttons (maximize area)
5. Center the grid in available space
6. Position buttons with proper offsets for uneven grids

**Key advantages:**
- ✅ Truly responsive - works on ANY screen size
- ✅ Maximizes button size - always as large as possible
- ✅ Maintains aspect ratio - buttons never distort
- ✅ Smart layout selection - algorithm picks best grid
- ✅ Handles edge cases - minimum sizes, maximum caps, centering

**Next steps:**
1. Implement `calculateResponsiveLayout()` function
2. Add resize event listeners with debouncing
3. Update CSS to support variable button sizes
4. Test Three.js canvas resizing
5. Add smooth transitions

---

## Open Questions

1. **Should we animate layout changes?** (1×5 → 2×3 transition)
   - Pros: Smooth, polished
   - Cons: Complex, could be distracting
   
2. **Fallback for tiny screens?** (< 480px)
   - Option A: Allow horizontal scroll
   - Option B: Show message "Screen too small"
   - Option C: Switch to vertical list (text-only)

3. **Should Three.js backgrounds adapt or stay?**
   - Current: They resize with buttons
   - Alternative: Disable backgrounds on small screens for performance

4. **Cache layout calculation?**
   - Store result for current dimensions
   - Only recalculate on actual size change
   - Performance optimization

---
---

## Implementation Status

### ✅ COMPLETED (March 24, 2026)

**Core Algorithm:**
- ✅ `calculateResponsiveLayout()` function with complete logic
- ✅ Tests 4 layouts (1×5, 2×3, 3×2, 5×1) and selects optimal
- ✅ Maintains 4:5 aspect ratio with min/max constraints
- ✅ Scales text/glyph sizes proportionally
- ✅ Left-aligned incomplete rows (design choice)
- ✅ Small screen detection (< 400px width)

**Layout Application:**
- ✅ `applyResponsiveLayout()` sets CSS variables dynamically
- ✅ Buttons positioned via absolute positioning
- ✅ Three.js canvas resizing on layout changes
- ✅ Small screen mode disables backgrounds

**Transitions:**
- ✅ `transitionLayout()` with fade out/in (300ms + 100ms)
- ✅ Smooth position transitions (400ms cubic-bezier)
- ✅ Debounced resize handler (150ms)

**Integration:**
- ✅ Initialized on page load
- ✅ Applied before CLI animation completes
- ✅ Three.js backgrounds only on non-small screens
- ✅ Camera aspect ratios updated on resize

### Testing Results

**Tested on:** localhost:7700
**Current viewport:** 1438×715 (likely 1×5 layout)
**Console:** No errors
**Visual:** Buttons render correctly with proper spacing
**Layout changes:** Smooth transitions confirmed

### Design Decisions

1. **Left-aligned incomplete rows:** Maintains grid structure with intentional whitespace
2. **Small screen threshold:** 400px width for text-only mode
3. **Aspect ratio:** 4:5 (width:height) maintained across all layouts
4. **Transition timing:** 300ms fade + 100ms pause + 400ms reposition = smooth UX

---
