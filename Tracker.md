# Project Tracker (Tracker.md)

This tracker maps active engineering items across features, bugs, refactors, and documentation.

---

## 1. Project Board Summary

| Status | Total Tasks | Description |
| :--- | :--- | :--- |
| **Backlog** | 12 | Future items slated for subsequent release phases. |
| **To Do** | 8 | Active items prioritized for implementation in the next phase. |
| **In Progress** | 1 | Currently active design or programming items. |
| **Blocked** | 1 | Items waiting for external dependencies or client assets. |
| **Completed** | 8 | Finished and verified tasks. |

---

## 2. Status Board Details

### 2.1 Backlog
Items scheduled for later phases of the project lifecycle.

| ID | Task Type | Component / Feature | Description | Phase |
| :--- | :--- | :--- | :--- | :--- |
| `BK-01` | Feature | Support / Messages | Implement image and document attachments in Chat. | Phase 6 |
| `BK-02` | Feature | Notification System | Setup database triggers to push notifications. | Phase 7 |
| `BK-03` | Feature | Client Dashboard | Add search and filters to Project timeline view. | Phase 4 |
| `BK-04` | Feature | Admin Dashboard | Add graph analytics showing MRR and client churn metrics. | Phase 8 |
| `BK-05` | Feature | Billing System | Integrate monthly retainer support subscriptions. | Phase 5 |
| `BK-06` | Refactor | Core Theme | Migrate static glassmorphic style maps to a custom inherited widget. | Phase 1 |
| `BK-07` | Feature | Localization | Add support for multiple language files (i18n). | Phase 10 |
| `BK-08` | Feature | Consultation | Webview integrations for Cal.com scheduler UI. | Phase 3 |
| `BK-09` | Feature | Client Vault | Create encrypted storage folder for client asset storage. | Phase 10 |
| `BK-10` | Feature | Reviews | Customer review ratings forms with star selection UI. | Phase 3 |
| `BK-11` | Feature | Admin Portal | Ticket auto-assignment algorithm matching ticket category to developer role. | Phase 8 |
| `BK-12` | Bug | Core Engine | Debug performance drops of CanvasKit renderer on old Safari versions. | Phase 9 |

---

### 2.2 To Do
Ready to be developed as soon as active work begins.

| ID | Task Type | Component / Feature | Description | Phase |
| :--- | :--- | :--- | :--- | :--- |
| `TD-01` | Feature | Core Foundation | Initialize Flutter project folder structure and configurations. | Phase 1 |
| `TD-02` | Feature | Core Styling | Build global typography text styles, theme configurations, and colors. | Phase 1 |
| `TD-03` | Feature | Global UI | Code reusable widgets (Buttons, Textfields, loaders, glass container template). | Phase 1 |
| `TD-04` | Feature | Network Layer | Implement Supabase Client manager singleton wrapper. | Phase 1 |
| `TD-05` | Feature | Routing System | Build declarative GoRouter routing table and mock screens. | Phase 1 |
| `TD-06` | Feature | Security Auth | Write credentials signup/login repository logic. | Phase 2 |
| `TD-07` | Feature | Profile Synchronization| Create Postgres profiles trigger for auto sync during signup. | Phase 2 |
| `TD-08` | Documentation | Security System | Document secure access tokens storage procedure. | Phase 2 |

---

### 2.3 In Progress
Tasks currently being worked on.

| ID | Task Type | Component / Feature | Description | Assignee |
| :--- | :--- | :--- | :--- | :--- |
| `IP-01` | Documentation | System Architecture | Authoring the 8 fundamental OS architecture documents. | Antigravity (Lead AI Architect) |

---

### 2.4 Blocked
Tasks halted due to missing information, dependencies, or external assets.

| ID | Task Type | Component / Feature | Description | Reason Blocked |
| :--- | :--- | :--- | :--- | :--- |
| `BL-01` | Feature | Billing Gateway | Connect Stripe production merchant accounts. | Awaiting client merchant keys. |

---

### 2.5 Completed
Fully executed and verified tasks.

| ID | Task Type | Component / Feature | Description | Date Completed |
| :--- | :--- | :--- | :--- | :--- |
| `CP-01` | Documentation | Project Concept | Create Product Requirement Document (`PRD.md`). | 2026-06-13 |
| `CP-02` | Documentation | Technical Specs | Create Technical Specification Document (`TechSpec.md`). | 2026-06-13 |
| `CP-03` | Documentation | Navigation Mapping | Create User App Flow Map (`AppFlow.md`). | 2026-06-13 |
| `CP-04` | Documentation | Design System | Create Spacing and Glassmorphic Theme Rules (`Design.md`). | 2026-06-13 |
| `CP-05` | Documentation | Database Schema | Create Relational Database Design specifications (`Schema.md`). | 2026-06-13 |
| `CP-06` | Documentation | Roadmap Planning | Create Phases Development Roadmap (`ImplementationPlan.md`). | 2026-06-13 |
| `CP-07` | Documentation | Tracking Board | Create Active Tasks Tracker (`Tracker.md`). | 2026-06-13 |
| `CP-08` | Documentation | Code Standards | Create Strict Programming Best Practices (`Rules.md`). | 2026-06-13 |
