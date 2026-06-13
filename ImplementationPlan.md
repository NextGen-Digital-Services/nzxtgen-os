# Development Implementation Plan (ImplementationPlan.md)

This document establishes the step-by-step development roadmap for building NZXTGEN OS. The project is broken down into 10 key delivery phases.

---

## Phase 1: Foundation
- **Goals**: Establish project structure, design system components, routing layout, and Supabase integration foundations.
- **Tasks**:
  1. Initialize Flutter project config (configure lint rules in `analysis_options.yaml`).
  2. Implement global theme config containing HSL colors, Geist/Inter fonts, and glassmorphic decoration styles.
  3. Create global custom widgets: buttons, load indicators, textfields, glass container cards.
  4. Write Supabase client singleton wrapper inside the network layer.
  5. Setup GoRouter structure with empty mock views for target routes.
- **Deliverables**: Compile-ready core application with functioning shell routing, dark theme, and placeholder views.
- **Dependencies**: None.
- **Exit Criteria**: Code builds on Android, iOS, and Web without linting warnings or compilation exceptions.

---

## Phase 2: Authentication
- **Goals**: Implement client login/signup flows, session token recovery, and PostgreSQL profile auto-sync.
- **Tasks**:
  1. Implement client-side Auth repository interfacing with Supabase auth endpoints.
  2. Develop Login and Signup UI screens using the glassmorphic style tokens.
  3. Implement Google Sign-In native credential hooks.
  4. Configure PostgreSQL backend trigger: when user registers, insert a matching profile record into the `profiles` table.
  5. Implement AuthGuard in GoRouter to prevent unauthenticated access to `/dashboard`.
- **Deliverables**: Secure sign-in screens, working credentials login, OAuth redirects, and auto-populated client profile table rows.
- **Dependencies**: Phase 1.
- **Exit Criteria**: Unauthenticated users are redirected from `/dashboard` to `/login`; signing up successfully creates a profile database record.

---

## Phase 3: Services Marketplace
- **Goals**: Build the client discovery catalog and the detailed purchase configuration screens.
- **Tasks**:
  1. Build database tables: `service_categories` and `services`. Seed database with standard agency service definitions.
  2. Build Services data source and domain models.
  3. Create Services Catalog layout featuring category filtration tabs.
  4. Design Service Details page, styling long-form Markdown descriptions, delivery timing indicators, and testimonials.
  5. Build Consultation scheduler integration with external meeting calendars.
- **Deliverables**: Interactive services catalog, detail views, and a booking portal.
- **Dependencies**: Phase 2.
- **Exit Criteria**: A client can browse services, filter by Category, view detail subpages, and trigger the "checkout" action.

---

## Phase 4: Project Dashboard
- **Goals**: Implement the milestone progress interface for tracking purchased agency projects.
- **Tasks**:
  1. Build `projects` and `project_updates` database tables.
  2. Implement Projects repository and state provider.
  3. Create active projects view displaying project metadata (start date, status, progress percentage).
  4. Build Project Timeline tracker – a visual timeline tracking project milestones (onboarding, design, development, qa, launch).
  5. Enable clients to download wireframes or code preview links posted inside updates.
- **Deliverables**: Rich project telemetry interface showing active milestone updates and progress trackers.
- **Dependencies**: Phase 3.
- **Exit Criteria**: Changing project status in the database updates the timeline UI in real-time.

---

## Phase 5: Payments
- **Goals**: Secure billing integration, transaction histories, and invoice document management.
- **Tasks**:
  1. Create `payments` and `invoices` tables in Supabase.
  2. Setup secure payment gateway link redirect handlers (e.g., Stripe Checkout checkout URLs).
  3. Develop transaction ledger list inside the user dashboard.
  4. Write automated invoice creation database triggers (create an invoice row and file path when a payment succeeds).
  5. Integrate PDF generation trigger to generate invoices on payments.
- **Deliverables**: Checkout transaction screens, payment logs, and functional PDF download buttons.
- **Dependencies**: Phase 4.
- **Exit Criteria**: Successful payment registers a transaction log and renders a downloadable invoice PDF.

---

## Phase 6: Support System
- **Goals**: Client ticketing and support chat systems.
- **Tasks**:
  1. Set up `support_tickets` and `messages` tables.
  2. Implement ticket creation form (allowing selection of priority level, subject, and description).
  3. Build tickets overview list showing status indicators (e.g., Open, In Progress, Closed).
  4. Develop internal message layout, creating chat bubbles, text input bars, and attachment file attachment triggers.
- **Deliverables**: Support form wizard, open ticket list, and thread-based message chats.
- **Dependencies**: Phase 2.
- **Exit Criteria**: Message text is instantly transmitted to Supabase and displays in chronological order under the ticket view.

---

## Phase 7: Notifications
- **Goals**: In-app alert dispatching and badge indicators.
- **Tasks**:
  1. Set up the `notifications` database table.
  2. Create database triggers to insert notifications:
     - On new project update -> notify client.
     - On support ticket status change -> notify client.
     - On payment received -> notify client.
  3. Build in-app notifications inbox UI.
  4. Implement route navigation hooks (clicking a notification routes to the relevant screen via GoRouter).
- **Deliverables**: Real-time toast alerts and a notification center view.
- **Dependencies**: Phase 4, Phase 5, Phase 6.
- **Exit Criteria**: Triggering a project update in the database flashes a real-time notification to the client.

---

## Phase 8: Admin Panel
- **Goals**: Admin console for agency operations.
- **Tasks**:
  1. Build an admin security middleware check verifying user's database role as `admin`.
  2. Create Admin Dashboard view detailing operational numbers (MRR, active tickets, pending quotes).
  3. Create Orders and Project manager interfaces (enabling admins to edit progress meters and change statuses).
  4. Create client profile browser and ticket dispatch terminal.
- **Deliverables**: Administrative dashboard and content management interface.
- **Dependencies**: Phase 4, Phase 5, Phase 6.
- **Exit Criteria**: Admins can edit project progress bars and answer client support tickets from their portal.

---

## Phase 9: Testing
- **Goals**: Implement unit, widget, and integration testing protocols.
- **Tasks**:
  1. Write unit tests for all domain logic models (Validators, Repositories, Providers).
  2. Implement widget tests verifying design rendering under different screen sizes (Responsive layout checks).
  3. Run security penetration tests verifying RLS rules block cross-tenant database reads.
- **Deliverables**: Clean test report suites and test scripts.
- **Dependencies**: Phase 8.
- **Exit Criteria**: 100% pass rate on all automated unit and widget test suites.

---

## Phase 10: Launch
- **Goals**: Release applications to target app stores and spin up live web hosts.
- **Tasks**:
  1. Configure iOS App Store and Google Play console credentials.
  2. Optimize Web build utilizing CanvasKit options. Deploy build to hosting services (e.g., Vercel, Netlify, or Supabase Hosting).
  3. Conduct security review of Supabase database roles and production API key configurations.
  4. Switch database state to production billing mode.
- **Deliverables**: Active production app store distributions and live website app links.
- **Dependencies**: Phase 9.
- **Exit Criteria**: Production build is live on web and app stores, processing credit card transactions.
