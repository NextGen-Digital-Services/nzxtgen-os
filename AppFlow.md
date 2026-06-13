# Application User Flow (AppFlow)

This document details the user journey maps and navigation structures of NZXTGEN OS. It is organized by user states: Guest, Authenticated Client, Dashboard Operations, and Administrator.

---

## 1. Complete System Navigation Map

```mermaid
graph TD
    %% Define Styles
    classDef guest fill:#1a1c29,stroke:#00e5ff,stroke-width:2px,color:#fff;
    classDef auth fill:#1a1c29,stroke:#9d4edd,stroke-width:2px,color:#fff;
    classDef admin fill:#1a1c29,stroke:#ff007f,stroke-width:2px,color:#fff;
    classDef global fill:#12131c,stroke:#fff,stroke-width:1px,color:#fff;

    %% Global Entry
    Splash((Splash Screen)) :::global --> Onboarding{First Run?} :::global
    Onboarding -- Yes --> OnboardingScreen[Onboarding Carousel] :::global
    Onboarding -- No --> GuestHome[Guest Home Page] :::guest

    %% Guest Flow
    subgraph Guest User Flow
        GuestHome --> ServicesCatalog[Services Catalog] :::guest
        ServicesCatalog --> ServiceDetailGuest[Service Details View] :::guest
        ServiceDetailGuest --> LoginRequired{Trigger Purchase / Book?} :::guest
        LoginRequired -- Yes --> LoginPage[Login Screen] :::guest
        GuestHome --> LoginPage
        LoginPage --> SignupPage[Sign Up Screen] :::guest
    end

    %% Authenticated Flow
    subgraph Authenticated Client Flow
        LoginPage -- Successful Auth --> AuthHome[Client Home Page] :::auth
        SignupPage -- Successful Auth --> AuthHome
        AuthHome --> ServicesCatalogAuth[Services Catalog] :::auth
        ServicesCatalogAuth --> ServiceDetailAuth[Service Detail Screen] :::auth
        ServiceDetailAuth --> ConsultationBooking[Book Free Consultation] :::auth
        ServiceDetailAuth --> CheckoutPayment[Checkout & Payment] :::auth
        CheckoutPayment -- Success --> ProjectDashboard[Dashboard] :::auth
    end

    %% Dashboard Sub-flows
    subgraph Client Dashboard Flow
        ProjectDashboard --> ProjectsTab[Active Projects & Timeline] :::auth
        ProjectDashboard --> PaymentsTab[Payments History] :::auth
        ProjectDashboard --> InvoicesTab[Invoices Download] :::auth
        ProjectDashboard --> MessagesTab[Support Chat & Thread] :::auth
        ProjectDashboard --> SupportTab[Create Support Ticket] :::auth
        ProjectDashboard --> ProfileTab[Profile & Security Settings] :::auth
    end

    %% Admin Flow
    subgraph Admin Portal Flow
        AdminLogin[Admin Secret Login] :::admin --> AdminDashboard[Admin Panel Dashboard] :::admin
        AdminDashboard --> AdminOrders[Manage Orders & Client Requests] :::admin
        AdminDashboard --> AdminClients[Client Database Directory] :::admin
        AdminDashboard --> AdminPayments[Revenue & Invoice Controller] :::admin
        AdminDashboard --> AdminTickets[Support Tickets Dispatcher] :::admin
    end
```

---

## 2. User Flows & State Logic

### 2.1 Guest Flow (Unauthenticated)
The entry point for new users designed to showcase services and build high design-based credibility.
1. **Splash Screen**: Checks user session tokens, executes local syncs, and initializes connection to Supabase.
2. **Onboarding Carousel**: A premium 3-slide visual introducing features: "Browse Tech Services", "Track Progress Live", and "Pay & Get Support Securely".
3. **Guest Home**: Main landing layout. Displays hero banners, highlighted services, client reviews, and a "Get Started" call to action.
4. **Services Catalog**: List of digital services grouped by category (Web, Mobile, AI, CRM, SEO, Ads).
5. **Login / Signup Screen**: Simple, dynamic login screen allowing quick Email/Password authentication or Google OAuth redirection.

---

### 2.2 Authenticated Flow (Client Account)
Triggers once the client completes authentication. The app transforms into a personalized service marketplace.
1. **Client Home**: Displays personalized welcome widget, active projects preview, and recommended services based on historical search patterns.
2. **Service Detail**: Deep-dive explanation page showing pricing models (One-time vs. Retainer), detailed scope items, technical deliverables, and active reviews.
3. **Consultation Scheduler**: Allows booking directly into the CRM calendars (e.g., Cal.com/Calendly webview integrations) for custom project discussions.
4. **Checkout & Payment**: Input billing details, review service deliverables, and complete payment. Redirects back to the dashboard upon successful transaction.

---

### 2.3 Client Dashboard Flow
The operational center for the client's current projects.
- **Projects Tab**: Interactive timeline showing phase-by-phase progress (e.g., Wireframing, Styling, Database, QA). Clients can view progress updates and submit required files.
- **Payments Tab**: Overview of billing history, payment methods, recurring subscriptions, and outstanding quotes.
- **Invoices Tab**: List of generated receipts with one-click PDF downloading.
- **Messages Tab**: Interface for messaging project managers and engineers.
- **Support Tab**: Form to open priority support tickets (categorized by severity: Critical, Standard, Low).
- **Profile Tab**: Edit personal information, upload client avatars, and change password/auth provider details.

---

### 2.4 Administrator Flow
A secure, separate portal for the NZXTGEN team to manage client interactions. Accessed via designated email configurations or dedicated `/admin` path.
1. **Admin Login**: Separate login interface with Multi-Factor Authentication (MFA) or direct Supabase role assertion.
2. **Admin Dashboard**: Core telemetry overview displaying Monthly Recurring Revenue (MRR), total active clients, active development tickets, and open support tickets.
3. **Orders Manager**: Track incoming service requests, assign projects to developers, and customize pricing parameters.
4. **Client Directory**: Browse client profiles, project histories, contact records, and access logs.
5. **Payments Controller**: Review payments, refund transactions, and generate custom invoices/quotes.
6. **Support Tickets Dispatcher**: Route support tickets to developers, respond to ticket queries, and update ticket lifecycle markers.

---

## 3. GoRouter Routing Configuration Map

The application routes are structured to support declarative redirections and shell routing (nested layouts).

| Path | Screen Class | Guard / Requirement | Shell Layout (Dashboard) |
| :--- | :--- | :--- | :--- |
| `/` | `SplashScreen` | None | No |
| `/onboarding` | `OnboardingScreen` | First Run Check | No |
| `/guest-home` | `GuestHomeScreen` | Guest Only | No |
| `/services` | `ServicesCatalogScreen` | None | No |
| `/services/:id` | `ServiceDetailScreen` | None | No |
| `/login` | `LoginScreen` | Guest Only | No |
| `/signup` | `SignupScreen` | Guest Only | No |
| `/dashboard` | `DashboardShell` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/projects`| `ProjectsScreen` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/payments`| `PaymentsScreen` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/invoices`| `InvoicesScreen` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/messages`| `MessagesScreen` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/support` | `SupportScreen` | Authenticated | Yes (Dashboard Shell) |
| `/dashboard/profile` | `ProfileScreen` | Authenticated | Yes (Dashboard Shell) |
| `/admin/login` | `AdminLoginScreen` | Guest Only | No |
| `/admin/dashboard` | `AdminDashboardScreen` | Admin Role Auth | Yes (Admin Shell) |
| `/admin/orders` | `AdminOrdersScreen` | Admin Role Auth | Yes (Admin Shell) |
| `/admin/clients` | `AdminClientsScreen` | Admin Role Auth | Yes (Admin Shell) |
| `/admin/payments` | `AdminPaymentsScreen` | Admin Role Auth | Yes (Admin Shell) |
| `/admin/tickets` | `AdminTicketsScreen` | Admin Role Auth | Yes (Admin Shell) |
