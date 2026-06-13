# Database Schema (Schema.md)

This schema is designed for PostgreSQL on Supabase. It integrates with Supabase's managed `auth.users` table and utilizes Row Level Security (RLS) for data protection.

---

## 1. Entity Relationship Overview

The schema is built around the client-service-project paradigm.
- A **User** (represented in `auth.users`) has a corresponding `profile`.
- **Services** belong to **Service Categories**.
- A client can buy a **Service** which spawns a **Project**.
- **Projects** receive **Project Updates** and generate **Payments** and **Invoices**.
- Clients communicate via **Messages** and open **Support Tickets** (which also host messages).
- **Consultations** capture initial client requests.
- **Reviews** capture client feedback on services.

---

## 2. Table Definitions

### 2.1 profiles
Links directly to Supabase Auth (`auth.users`) to hold metadata.
- **Table Name**: `public.profiles`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY`, `REFERENCES auth.users(id) ON DELETE CASCADE` | Match uid from auth.users |
| `full_name` | `varchar(255)` | `NOT NULL` | Full legal or display name |
| `avatar_url` | `text` | `NULL` | Public URL to profile picture |
| `role` | `varchar(50)` | `NOT NULL DEFAULT 'client'` | `client` or `admin` or `developer` |
| `company_name`| `varchar(255)` | `NULL` | Client business organization name |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Record timestamp |
| `updated_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Last update timestamp |

---

### 2.2 service_categories
Groups services for visual separation in UI.
- **Table Name**: `public.service_categories`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `name` | `varchar(100)`| `NOT NULL UNIQUE` | Category name (e.g. Website Dev) |
| `slug` | `varchar(100)`| `NOT NULL UNIQUE` | URL/route friendly string |
| `description` | `text` | `NULL` | Category scope summary |
| `icon_name` | `varchar(50)` | `NULL` | Material/Geist icon identifier |
| `display_order`| `integer` | `NOT NULL DEFAULT 0` | Ordering weight for layouts |

---

### 2.3 services
Catalog of products available for purchase.
- **Table Name**: `public.services`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `category_id` | `uuid` | `REFERENCES public.service_categories(id) ON DELETE RESTRICT` | Parent category linkage |
| `title` | `varchar(255)`| `NOT NULL` | Service name (e.g., Premium Landing Page) |
| `slug` | `varchar(255)`| `NOT NULL UNIQUE` | Unique URL handle |
| `short_description`| `text`| `NOT NULL` | Single line subtitle for catalog |
| `long_description` | `text`| `NOT NULL` | Markdown detailing service scope |
| `base_price` | `numeric(10,2)`| `NOT NULL` | Base price in USD |
| `price_type` | `varchar(50)` | `NOT NULL DEFAULT 'one_time'` | `one_time` or `subscription` (monthly) |
| `delivery_time_days`| `integer`| `NOT NULL` | Standard turnaround estimate |
| `is_active` | `boolean` | `NOT NULL DEFAULT true` | Toggles product visibility |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.4 projects
An active service contract in progress.
- **Table Name**: `public.projects`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `client_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id)` | Owner client account |
| `service_id` | `uuid` | `REFERENCES public.services(id) ON DELETE SET NULL` | Service type purchased |
| `title` | `varchar(255)`| `NOT NULL` | Custom name (e.g., "Sarah's Store Design") |
| `status` | `varchar(50)` | `NOT NULL DEFAULT 'onboarding'`| `onboarding` -> `planning` -> `in_progress` -> `review` -> `completed` -> `paused` |
| `progress_percent`| `integer` | `NOT NULL DEFAULT 0` | Overall percentage (0-100) |
| `start_date` | `timestamptz` | `NULL` | Commencement timestamp |
| `target_delivery` | `timestamptz` | `NULL` | Expected delivery target |
| `github_repo` | `text` | `NULL` | Repo path for tech projects |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Record creation |

---

### 2.5 project_updates
Milestones and progress logs posted by developers/admins.
- **Table Name**: `public.project_updates`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `project_id` | `uuid` | `NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE` | Linked project |
| `author_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id)` | User logging update (admin/dev) |
| `title` | `varchar(255)`| `NOT NULL` | Update title (e.g., Wireframes Approved) |
| `description` | `text` | `NOT NULL` | Details of progress made |
| `attachment_url`| `text` | `NULL` | Link to preview file (image, design) |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.6 payments
Financial transaction logs.
- **Table Name**: `public.payments`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `client_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id)` | Client who paid |
| `project_id` | `uuid` | `REFERENCES public.projects(id) ON DELETE SET NULL` | Linked project (if applicable) |
| `amount` | `numeric(10,2)`| `NOT NULL` | Paid amount in USD |
| `payment_status`| `varchar(50)` | `NOT NULL DEFAULT 'pending'` | `pending`, `completed`, `failed`, `refunded` |
| `payment_gateway`| `varchar(50)` | `NOT NULL DEFAULT 'stripe'` | Payment vendor |
| `transaction_id`| `varchar(255)`| `NULL UNIQUE` | Unique reference ID from vendor (Stripe id) |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.7 invoices
Official invoice documents generated for accounting.
- **Table Name**: `public.invoices`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `payment_id` | `uuid` | `UNIQUE REFERENCES public.payments(id) ON DELETE CASCADE` | Linked successful transaction |
| `client_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id)` | Recipient user profile |
| `invoice_number`| `varchar(100)`| `NOT NULL UNIQUE` | Human-readable ID (e.g., NZXT-2026-0001) |
| `pdf_url` | `text` | `NOT NULL` | Path to storage bucket location |
| `issue_date` | `timestamptz` | `NOT NULL DEFAULT now()` | Document date |

---

### 2.8 support_tickets
Issues or work tickets raised by clients.
- **Table Name**: `public.support_tickets`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `client_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE` | Client who opened ticket |
| `project_id` | `uuid` | `REFERENCES public.projects(id) ON DELETE SET NULL` | Linked project (if applicable) |
| `subject` | `varchar(255)`| `NOT NULL` | Short summary of issue |
| `category` | `varchar(100)`| `NOT NULL` | `technical`, `billing`, `design`, `other` |
| `priority` | `varchar(50)` | `NOT NULL DEFAULT 'standard'`| `low`, `standard`, `critical` |
| `status` | `varchar(50)` | `NOT NULL DEFAULT 'open'` | `open`, `in_progress`, `resolved`, `closed` |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.9 messages
Text lines representing discussions within projects or tickets.
- **Table Name**: `public.messages`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `sender_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE` | Creator of the message |
| `project_id` | `uuid` | `REFERENCES public.projects(id) ON DELETE CASCADE` | Linked project (optional) |
| `ticket_id` | `uuid` | `REFERENCES public.support_tickets(id) ON DELETE CASCADE` | Linked support ticket (optional) |
| `content` | `text` | `NOT NULL` | Message body |
| `attachment_url`| `text` | `NULL` | Optional file link |
| `is_read` | `boolean` | `NOT NULL DEFAULT false` | Status |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.10 notifications
In-app alerts pushed to users.
- **Table Name**: `public.notifications`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `recipient_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE` | User receiving the alert |
| `title` | `varchar(255)`| `NOT NULL` | Alert headline |
| `body` | `text` | `NOT NULL` | Alert description content |
| `type` | `varchar(50)` | `NOT NULL` | `project_update`, `payment_received`, `message_received`, `ticket_status_changed` |
| `action_route` | `text` | `NULL` | GoRouter matching route string |
| `is_read` | `boolean` | `NOT NULL DEFAULT false` | Status |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.11 reviews
Customer reviews for purchased services.
- **Table Name**: `public.reviews`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `client_id` | `uuid` | `NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE` | Reviewer |
| `service_id` | `uuid` | `NOT NULL REFERENCES public.services(id) ON DELETE CASCADE` | Service reviewed |
| `rating` | `integer` | `NOT NULL CHECK (rating >= 1 AND rating <= 5)`| Star rating (1-5) |
| `comment` | `text` | `NULL` | Review copy |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

### 2.12 consultations
Consultation requests booked prior to checkout.
- **Table Name**: `public.consultations`
- **Columns**:

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | `uuid` | `PRIMARY KEY DEFAULT gen_random_uuid()` | Unique identifier |
| `client_id` | `uuid` | `REFERENCES public.profiles(id) ON DELETE SET NULL` | Client profile (if authenticated) |
| `guest_email` | `varchar(255)`| `NULL` | Contact email if guest user |
| `guest_name` | `varchar(255)`| `NULL` | Contact name if guest user |
| `service_slug` | `varchar(100)`| `NULL` | Preferred interest slug |
| `scheduled_time`| `timestamptz`| `NOT NULL` | Booked slot time |
| `status` | `varchar(50)` | `NOT NULL DEFAULT 'scheduled'` | `scheduled`, `completed`, `cancelled` |
| `meeting_link` | `text` | `NULL` | Zoom/Google Meet URL |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | Timestamp |

---

## 3. Database Indexing Strategy

To maintain sub-millisecond query response times, index allocations are set up for primary lookup targets, foreign key constraints, and status-based aggregations.

```sql
-- Profiles: Fast email/name lookups
CREATE INDEX idx_profiles_role ON public.profiles(role);

-- Services: Slug lookups for routing
CREATE INDEX idx_services_slug ON public.services(slug);
CREATE INDEX idx_services_category ON public.services(category_id);

-- Projects: Frequent status aggregation and client lookup
CREATE INDEX idx_projects_client ON public.projects(client_id);
CREATE INDEX idx_projects_status ON public.projects(status);

-- Updates: Sorted timeline lookups
CREATE INDEX idx_project_updates_project_date ON public.project_updates(project_id, created_at DESC);

-- Payments & Invoices: Fast billing queries
CREATE INDEX idx_payments_client ON public.payments(client_id);
CREATE INDEX idx_payments_status ON public.payments(payment_status);
CREATE INDEX idx_invoices_client ON public.invoices(client_id);
CREATE INDEX idx_invoices_number ON public.invoices(invoice_number);

-- Tickets & Messages: Real-time queries
CREATE INDEX idx_support_tickets_client ON public.support_tickets(client_id);
CREATE INDEX idx_support_tickets_status ON public.support_tickets(status);
CREATE INDEX idx_messages_project ON public.messages(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX idx_messages_ticket ON public.messages(ticket_id) WHERE ticket_id IS NOT NULL;
CREATE INDEX idx_messages_date ON public.messages(created_at DESC);

-- Notifications: Unread filters
CREATE INDEX idx_notifications_recipient_unread ON public.notifications(recipient_id) WHERE is_read = false;

-- Consultations: Future schedule checks
CREATE INDEX idx_consultations_schedule ON public.consultations(scheduled_time DESC);
```
