# MedChain UI/UX Design Concept
## Healthcare Supply Chain Platform - Design System

---

## 🎨 DESIGN PHILOSOPHY

### Core Concept: "Clinical Precision Meets Human Care"
একটি healthcare platform যা একসাথে professional, trustworthy, এবং human-friendly

**Design Direction: Medical Minimalism with Warm Accents**
- Clean, clinical precision (like a modern hospital)
- Warm, human touches (like caring hands)
- Data-dense but breathable
- Serious but not intimidating

---

## 🎯 AESTHETIC PILLARS

### 1. Trust & Authority
Healthcare is serious business. Design must convey:
- Professional competence
- Data accuracy
- System reliability
- Regulatory compliance

### 2. Clarity & Efficiency  
Users are busy healthcare professionals:
- Information at a glance
- Minimal cognitive load
- Fast task completion
- Zero ambiguity

### 3. Warmth & Humanity
Behind the data are real patients:
- Not cold/clinical
- Accessible, friendly
- Encouraging, supportive
- Optimistic about health outcomes

---

## 🎨 COLOR SYSTEM

### Primary Palette: "Medical Blue & Living Green"

```css
:root {
  /* Primary - Trust & Professionalism */
  --primary-900: #0A2540;    /* Deep Ocean - headers, emphasis */
  --primary-700: #1565C0;    /* Medical Blue - primary actions */
  --primary-500: #2196F3;    /* Sky Blue - links, hover states */
  --primary-300: #64B5F6;    /* Light Blue - backgrounds */
  --primary-100: #E3F2FD;    /* Ice Blue - subtle backgrounds */
  
  /* Secondary - Life & Growth */
  --secondary-700: #2E7D32;  /* Forest Green - success states */
  --secondary-500: #4CAF50;  /* Living Green - positive indicators */
  --secondary-300: #81C784;  /* Spring Green - charts, growth */
  
  /* Accent - Urgency & Attention */
  --accent-warning: #FF6B35; /* Sunset Orange - warnings */
  --accent-critical: #E53935; /* Medical Red - critical alerts */
  --accent-expired: #9C27B0;  /* Purple - expired items */
  
  /* Neutrals - Medical Grays */
  --gray-900: #1A1A1A;       /* Almost Black - body text */
  --gray-700: #424242;       /* Dark Gray - secondary text */
  --gray-500: #757575;       /* Medium Gray - labels */
  --gray-300: #BDBDBD;       /* Light Gray - borders */
  --gray-100: #F5F5F5;       /* Off White - backgrounds */
  --gray-50:  #FAFAFA;       /* Paper White - cards */
  
  /* Semantic Colors */
  --success: var(--secondary-500);
  --warning: var(--accent-warning);
  --error: var(--accent-critical);
  --info: var(--primary-500);
}
```

### Color Usage Guidelines

**Primary Blue:**
- Main navigation
- Primary buttons
- Active states
- Data visualization (main series)
- Links

**Secondary Green:**
- Success messages
- "In Stock" indicators
- Positive trends
- Completion states
- Growth metrics

**Orange Warnings:**
- Near-expiry alerts (30-60 days)
- Below reorder level
- Attention needed

**Critical Red:**
- Expired items
- Out of stock
- Recall alerts
- Life-threatening ADRs

**Purple Accent:**
- Expired status
- Deactivated items
- Historical data

---

## 📐 TYPOGRAPHY

### Font Pairing: "Technical Precision + Human Warmth"

```css
/* Primary Font: IBM Plex Sans */
/* Why: Technical precision, excellent readability, pharmaceutical industry feel */
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;500;600;700&display=swap');

/* Secondary Font: Inter (for data/numbers) */
/* Why: Tabular numbers, excellent at small sizes, clean metrics */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

/* Accent Font: Playfair Display (for headers/branding) */
/* Why: Elegant, trustworthy, adds warmth without sacrificing professionalism */
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap');

:root {
  --font-display: 'Playfair Display', serif;
  --font-body: 'IBM Plex Sans', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'IBM Plex Mono', 'Courier New', monospace;
  --font-data: 'Inter', sans-serif;
}
```

### Type Scale

```css
/* Fluid Typography with clamp() */
:root {
  --text-xs:   clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);   /* 12-14px */
  --text-sm:   clamp(0.875rem, 0.8rem + 0.35vw, 1rem);      /* 14-16px */
  --text-base: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);     /* 16-18px */
  --text-lg:   clamp(1.125rem, 1rem + 0.5vw, 1.25rem);      /* 18-20px */
  --text-xl:   clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem);     /* 20-24px */
  --text-2xl:  clamp(1.5rem, 1.3rem + 1vw, 2rem);           /* 24-32px */
  --text-3xl:  clamp(2rem, 1.7rem + 1.5vw, 2.5rem);         /* 32-40px */
  --text-4xl:  clamp(2.5rem, 2rem + 2.5vw, 3.5rem);         /* 40-56px */
}

/* Usage */
h1 { 
  font-family: var(--font-display); 
  font-size: var(--text-4xl);
  font-weight: 700;
  line-height: 1.1;
  color: var(--primary-900);
}

h2 { 
  font-family: var(--font-display); 
  font-size: var(--text-3xl);
  font-weight: 600;
}

h3 { 
  font-family: var(--font-body); 
  font-size: var(--text-xl);
  font-weight: 600;
}

body {
  font-family: var(--font-body);
  font-size: var(--text-base);
  line-height: 1.6;
  color: var(--gray-900);
}

/* Data Tables */
.data-table {
  font-family: var(--font-data);
  font-variant-numeric: tabular-nums; /* Aligned numbers */
}

/* Code/Technical */
code, .batch-number, .medicine-code {
  font-family: var(--font-mono);
  font-size: 0.9em;
}
```

---

## 🏗️ LAYOUT SYSTEM

### Grid Structure

```css
/* 12-Column Grid with CSS Grid */
.container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 24px;
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 32px;
}

/* Responsive Breakpoints */
:root {
  --breakpoint-sm: 640px;   /* Mobile */
  --breakpoint-md: 768px;   /* Tablet */
  --breakpoint-lg: 1024px;  /* Desktop */
  --breakpoint-xl: 1280px;  /* Large Desktop */
  --breakpoint-2xl: 1536px; /* Wide Screen */
}

/* Dashboard Layout Example */
.dashboard-grid {
  display: grid;
  grid-template-columns: 280px 1fr; /* Sidebar + Main */
  grid-template-rows: 64px 1fr;     /* Header + Content */
  height: 100vh;
  gap: 0;
}

.sidebar {
  grid-row: 1 / -1; /* Full height */
  background: var(--primary-900);
  color: white;
}

.header {
  grid-column: 2;
  background: white;
  border-bottom: 1px solid var(--gray-300);
}

.main-content {
  grid-column: 2;
  background: var(--gray-50);
  padding: 32px;
  overflow-y: auto;
}
```

### Spacing Scale (8px base)

```css
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 24px;
  --space-8: 32px;
  --space-10: 40px;
  --space-12: 48px;
  --space-16: 64px;
  --space-20: 80px;
  --space-24: 96px;
}
```

---

## 🎭 COMPONENT LIBRARY

### 1. Status Badges

```html
<div class="status-badge status-active">Active</div>
<div class="status-badge status-expired">Expired</div>
<div class="status-badge status-warning">Near Expiry</div>
<div class="status-badge status-critical">Critical</div>
```

```css
.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: var(--text-xs);
  font-weight: 600;
  font-family: var(--font-data);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-active {
  background: #E8F5E9;
  color: #2E7D32;
  border: 1px solid #81C784;
}

.status-expired {
  background: #FCE4EC;
  color: #C2185B;
  border: 1px solid #F48FB1;
}

.status-warning {
  background: #FFF3E0;
  color: #E65100;
  border: 1px solid #FFB74D;
}

.status-critical {
  background: #FFEBEE;
  color: #C62828;
  border: 1px solid #EF5350;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}
```

### 2. Data Cards (KPI Cards)

```html
<div class="kpi-card">
  <div class="kpi-icon">
    <svg><!-- Icon --></svg>
  </div>
  <div class="kpi-content">
    <div class="kpi-label">Total Inventory Value</div>
    <div class="kpi-value">৳12,45,678</div>
    <div class="kpi-trend trend-up">
      <span class="trend-icon">↗</span>
      <span class="trend-value">12.5%</span>
      <span class="trend-label">vs last month</span>
    </div>
  </div>
</div>
```

```css
.kpi-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 
    0 1px 3px rgba(0, 0, 0, 0.05),
    0 10px 15px -3px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.kpi-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-500), var(--secondary-500));
}

.kpi-card:hover {
  transform: translateY(-2px);
  box-shadow: 
    0 4px 6px rgba(0, 0, 0, 0.07),
    0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.kpi-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: var(--primary-100);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16px;
}

.kpi-label {
  font-size: var(--text-sm);
  color: var(--gray-700);
  font-weight: 500;
  margin-bottom: 8px;
}

.kpi-value {
  font-size: var(--text-3xl);
  font-weight: 700;
  font-family: var(--font-data);
  color: var(--primary-900);
  margin-bottom: 12px;
}

.kpi-trend {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: var(--text-sm);
}

.trend-up {
  color: var(--secondary-700);
}

.trend-down {
  color: var(--accent-critical);
}

.trend-icon {
  font-size: 18px;
  font-weight: bold;
}

.trend-value {
  font-weight: 600;
  font-family: var(--font-data);
}

.trend-label {
  color: var(--gray-500);
}
```

### 3. Medicine Card (Product Card)

```css
.medicine-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid var(--gray-300);
  transition: all 0.3s ease;
}

.medicine-card:hover {
  border-color: var(--primary-500);
  box-shadow: 0 8px 16px rgba(33, 150, 243, 0.15);
}

.medicine-header {
  padding: 20px;
  background: linear-gradient(135deg, var(--primary-100) 0%, white 100%);
  border-bottom: 1px solid var(--gray-200);
}

.medicine-name {
  font-family: var(--font-display);
  font-size: var(--text-lg);
  font-weight: 600;
  color: var(--primary-900);
  margin-bottom: 4px;
}

.medicine-generic {
  font-size: var(--text-sm);
  color: var(--gray-700);
}

.medicine-body {
  padding: 20px;
}

.medicine-meta {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  margin-bottom: 16px;
}

.meta-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.meta-label {
  font-size: var(--text-xs);
  color: var(--gray-500);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.meta-value {
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--gray-900);
  font-family: var(--font-data);
}

.medicine-footer {
  padding: 16px 20px;
  background: var(--gray-50);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stock-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
}

.stock-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--secondary-500);
}

.stock-dot.low {
  background: var(--accent-warning);
  animation: blink 2s ease-in-out infinite;
}

.stock-dot.out {
  background: var(--accent-critical);
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
```

### 4. Alert Component

```css
.alert {
  display: flex;
  gap: 16px;
  padding: 16px 20px;
  border-radius: 12px;
  border-left: 4px solid;
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.alert-critical {
  border-left-color: var(--accent-critical);
  background: linear-gradient(90deg, #FFEBEE 0%, white 100%);
}

.alert-warning {
  border-left-color: var(--accent-warning);
  background: linear-gradient(90deg, #FFF3E0 0%, white 100%);
}

.alert-info {
  border-left-color: var(--primary-500);
  background: linear-gradient(90deg, var(--primary-100) 0%, white 100%);
}

.alert-icon {
  flex-shrink: 0;
  width: 24px;
  height: 24px;
}

.alert-content {
  flex: 1;
}

.alert-title {
  font-weight: 600;
  margin-bottom: 4px;
  color: var(--gray-900);
}

.alert-message {
  font-size: var(--text-sm);
  color: var(--gray-700);
  line-height: 1.5;
}

.alert-actions {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}
```

### 5. Data Table

```css
.data-table {
  width: 100%;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.table-header {
  background: var(--primary-900);
  color: white;
  padding: 16px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-title {
  font-size: var(--text-lg);
  font-weight: 600;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background: var(--gray-100);
  border-bottom: 2px solid var(--gray-300);
}

th {
  padding: 12px 16px;
  text-align: left;
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--gray-700);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

tbody tr {
  border-bottom: 1px solid var(--gray-200);
  transition: background 0.2s ease;
}

tbody tr:hover {
  background: var(--primary-100);
}

td {
  padding: 16px;
  font-size: var(--text-sm);
  color: var(--gray-900);
}

td.numeric {
  font-family: var(--font-data);
  font-variant-numeric: tabular-nums;
  text-align: right;
}

/* Sticky header for long tables */
thead {
  position: sticky;
  top: 0;
  z-index: 10;
}
```

---

## 🎬 ANIMATIONS & MICRO-INTERACTIONS

### Page Load Animation

```css
/* Staggered fade-in for dashboard cards */
.kpi-card {
  animation: fadeInUp 0.6s ease-out backwards;
}

.kpi-card:nth-child(1) { animation-delay: 0.1s; }
.kpi-card:nth-child(2) { animation-delay: 0.2s; }
.kpi-card:nth-child(3) { animation-delay: 0.3s; }
.kpi-card:nth-child(4) { animation-delay: 0.4s; }

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Button Interactions

```css
.btn {
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

/* Ripple effect */
.btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.5);
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.btn:active::after {
  width: 300px;
  height: 300px;
}
```

### Skeleton Loading

```css
.skeleton {
  background: linear-gradient(
    90deg,
    var(--gray-200) 25%,
    var(--gray-100) 50%,
    var(--gray-200) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

## 📱 RESPONSIVE DESIGN

### Mobile-First Approach

```css
/* Mobile (default) */
.dashboard-grid {
  grid-template-columns: 1fr;
  grid-template-rows: 56px 1fr;
}

.sidebar {
  position: fixed;
  left: -280px;
  transition: left 0.3s ease;
  z-index: 1000;
}

.sidebar.open {
  left: 0;
}

/* Tablet */
@media (min-width: 768px) {
  .kpi-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .dashboard-grid {
    grid-template-columns: 280px 1fr;
  }
  
  .sidebar {
    position: static;
  }
  
  .kpi-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}
```

---

## 🎨 DASHBOARD LAYOUTS

### 1. Executive Dashboard

```
┌─────────────────────────────────────────────────────────┐
│                     HEADER BAR                          │
│  Logo    Search         Notifications   Profile         │
└─────────────────────────────────────────────────────────┘
┌──────┬──────────────────────────────────────────────────┐
│      │  ┌──────────┬──────────┬──────────┬──────────┐  │
│      │  │ Total    │ Near     │ Out of   │ Active   │  │
│ SIDE │  │ Inventory│ Expiry   │ Stock    │ Alerts   │  │
│ BAR  │  │ Value    │ (145)    │ (23)     │ (12)     │  │
│      │  │৳12,45,678│          │          │          │  │
│ Nav  │  └──────────┴──────────┴──────────┴──────────┘  │
│      │                                                  │
│Links │  ┌───────────────────────────────────────────┐  │
│      │  │     Inventory Value Trend (Chart)        │  │
│      │  │                                           │  │
│      │  └───────────────────────────────────────────┘  │
│      │                                                  │
│      │  ┌──────────────────┬────────────────────────┐  │
│      │  │ Top Medicines    │ Recent Supply Chain    │  │
│      │  │ by Value         │ Events (Timeline)      │  │
│      │  │ (Bar Chart)      │                        │  │
│      │  └──────────────────┴────────────────────────┘  │
│      │                                                  │
│      │  ┌──────────────────────────────────────────┐  │
│      │  │   Critical Alerts (Interactive Table)   │  │
│      │  └──────────────────────────────────────────┘  │
└──────┴──────────────────────────────────────────────────┘
```

### 2. Inventory Management

```
┌─────────────────────────────────────────────────────────┐
│ INVENTORY MANAGEMENT                                     │
│ ┌─────────┬─────────┬─────────┐  [Search] [Filter] [+]│
│ │ All     │ Active  │ Expiring│                         │
│ │ (1,234) │ (1,100) │ (89)    │                         │
│ └─────────┴─────────┴─────────┘                         │
├─────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Medicine  │ Batch  │ Expiry │ Qty │ Location │ Status│ │
│ ├───────────┼────────┼────────┼─────┼──────────┼───────┤ │
│ │ Napa 500  │ A12345 │ 45 days│ 500 │ Pharm-1  │  🟢   │ │
│ │ Amoxil    │ B67890 │ 15 days│ 100 │ WH-Main  │  🟡   │ │
│ │ Insulin   │ C11111 │EXPIRED │  50 │ Cold-1   │  🔴   │ │
│ └─────────────────────────────────────────────────────┘ │
│                                                           │
│ Pagination: ‹ 1 2 3 ... 45 ›                      10/pg │
└───────────────────────────────────────────────────────────┘
```

### 3. Medicine Detail Page

```
┌─────────────────────────────────────────────────────────┐
│ ‹ Back to Inventory                                      │
├─────────────────────────────────────────────────────────┤
│ ┌──────────────┐  Paracetamol 500mg (Napa)             │
│ │              │  Square Pharmaceuticals Ltd            │
│ │   [QR CODE]  │  SKU: MED0000001                       │
│ │              │                                         │
│ └──────────────┘  Status: [●  ACTIVE]                   │
│                                                           │
│ ┌─────────┬─────────┬─────────┬─────────┐               │
│ │ Total   │ Active  │ Reserved│ Near    │               │
│ │ Stock   │ Batches │ Qty     │ Expiry  │               │
│ │ 12,450  │   15    │  1,200  │    3    │               │
│ └─────────┴─────────┴─────────┴─────────┘               │
│                                                           │
│ ┌─ ACTIVE BATCHES ───────────────────────────────────┐  │
│ │ Batch    │ Mfg Date  │ Exp Date  │ Qty  │ Location│  │
│ │ A12345   │ 15-Jan-24 │ 15-Jan-26 │ 5000 │ WH-1   │  │
│ │ A12346   │ 20-Jan-24 │ 20-Jan-26 │ 3000 │ WH-2   │  │
│ └────────────────────────────────────────────────────┘  │
│                                                           │
│ ┌─ DRUG INFORMATION ─────────────────────────────────┐  │
│ │ Generic Name: Paracetamol                          │  │
│ │ Therapeutic Class: Analgesic, Antipyretic         │  │
│ │ Storage: Store below 25°C                         │  │
│ └────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
```

---

## 📊 DATA VISUALIZATION

### Chart Color Palette

```css
:root {
  --chart-1: #2196F3;  /* Primary Blue */
  --chart-2: #4CAF50;  /* Green */
  --chart-3: #FF9800;  /* Orange */
  --chart-4: #9C27B0;  /* Purple */
  --chart-5: #00BCD4;  /* Cyan */
  --chart-6: #FF5722;  /* Deep Orange */
  
  /* Chart Gradients */
  --chart-gradient-1: linear-gradient(180deg, rgba(33,150,243,0.2) 0%, rgba(33,150,243,0) 100%);
  --chart-gradient-2: linear-gradient(180deg, rgba(76,175,80,0.2) 0%, rgba(76,175,80,0) 100%);
}
```

### Chart Styles

```css
/* Area Chart with Gradient Fill */
.recharts-area {
  fill: url(#colorGradient);
  opacity: 0.8;
}

.recharts-line {
  stroke-width: 3px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
}

/* Tooltip */
.custom-tooltip {
  background: white;
  padding: 12px 16px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  border: 1px solid var(--gray-300);
}

.tooltip-label {
  font-weight: 600;
  margin-bottom: 8px;
  color: var(--gray-900);
}

.tooltip-value {
  font-family: var(--font-data);
  font-size: var(--text-lg);
  color: var(--primary-700);
}
```

---

## 🎯 NAVIGATION PATTERNS

### Sidebar Navigation

```css
.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 20px;
  color: rgba(255, 255, 255, 0.7);
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  position: relative;
}

.nav-item:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.nav-item.active {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  border-left-color: var(--secondary-500);
}

.nav-item.active::before {
  content: '';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 24px;
  background: var(--secondary-500);
  border-radius: 2px 0 0 2px;
}

.nav-icon {
  width: 20px;
  height: 20px;
}

.nav-badge {
  margin-left: auto;
  background: var(--accent-critical);
  color: white;
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 10px;
  font-weight: 600;
}
```

---

## 💫 SPECIAL EFFECTS

### Glass morphism for Cards

```css
.glass-card {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 8px 32px rgba(0, 0, 0, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.5);
}
```

### Gradient Mesh Background

```css
.dashboard-background {
  background: 
    radial-gradient(circle at 20% 50%, rgba(33, 150, 243, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(76, 175, 80, 0.1) 0%, transparent 50%),
    var(--gray-50);
}
```

### Noise Texture Overlay

```css
.page-container::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300"><filter id="noise"><feTurbulence type="fractalNoise" baseFrequency="0.65"/></filter><rect width="100%" height="100%" filter="url(%23noise)" opacity="0.03"/></svg>');
  pointer-events: none;
  z-index: 1;
}
```

---

## 🔔 NOTIFICATION SYSTEM

```css
.notification-panel {
  position: fixed;
  top: 64px;
  right: 20px;
  width: 360px;
  max-height: calc(100vh - 84px);
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.2);
  overflow: hidden;
  transform: translateX(400px);
  transition: transform 0.3s ease;
}

.notification-panel.open {
  transform: translateX(0);
}

.notification-item {
  padding: 16px;
  border-bottom: 1px solid var(--gray-200);
  display: flex;
  gap: 12px;
  transition: background 0.2s ease;
}

.notification-item:hover {
  background: var(--gray-50);
}

.notification-item.unread {
  background: var(--primary-100);
}

.notification-item.unread::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 60%;
  background: var(--primary-500);
}
```

---

## ✨ FINAL TOUCHES

### Custom Scrollbar

```css
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: var(--gray-100);
}

::-webkit-scrollbar-thumb {
  background: var(--gray-400);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--gray-500);
}
```

### Focus States (Accessibility)

```css
*:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

button:focus-visible,
a:focus-visible {
  box-shadow: 
    0 0 0 3px white,
    0 0 0 5px var(--primary-500);
}
```

---

## 🎨 COMPLETE EXAMPLE: DASHBOARD PAGE

[See next section for full HTML/CSS/JS implementation]

