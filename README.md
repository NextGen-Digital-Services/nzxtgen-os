# NZXTGEN OS

Enterprise-grade Digital Services Platform built with Flutter.

NZXTGEN OS is a premium client-facing platform designed for digital services management, project tracking, service purchasing, consultations, payments, and customer support.

The platform is being developed as a scalable multi-platform application supporting:

* Android
* iOS
* Web
* Linux

---

# Project Overview

NZXTGEN OS allows users to:

* Create accounts
* Login securely
* Browse services
* Purchase services
* Book consultations
* Track project progress
* View invoices
* Manage payments
* Raise support tickets
* Access project files
* Receive notifications

---

# Core Services

The platform currently supports:

* Website Development
* Mobile App Development
* CRM Development
* AI Automation
* SEO
* Meta Ads
* Google Ads
* Branding
* Graphic Design

---

# Tech Stack

## Frontend

* Flutter
* Dart

## State Management

* Provider

## Routing

* GoRouter

## Backend

* Supabase

## Database

* PostgreSQL

## Authentication

* Email Authentication
* Google Authentication (Planned)

## Storage

* Supabase Storage

---

# Project Architecture

The project follows a Feature-First Architecture.

```text
lib/

├── core/
│   ├── routes/
│   ├── theme/
│   ├── constants/
│   └── widgets/
│
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── about/
│   ├── services/
│   ├── dashboard/
│   ├── projects/
│   ├── payments/
│   ├── support/
│   └── profile/
│
├── providers/
├── services/
├── models/
└── shared/
```

---

# Current Development Status

## Completed

* Project Setup
* Theme System
* App Navigation Structure
* Home Screen
* About Screen
* Services Screen
* Service Detail Screen
* Dashboard UI Foundation
* Responsive Layout Foundation

## In Progress

* Authentication
* Supabase Integration
* Database Schema
* Project Tracking System

## Planned

* Payment System
* Support Ticket System
* Notifications
* Admin Dashboard
* Client Portal
* Analytics

---

# Documentation

Project documentation is maintained through:

* PRD.md
* TechSpec.md
* AppFlow.md
* Design.md
* Schema.md
* ImplementationPlan.md
* Tracker.md
* Rules.md

These files serve as the project's source of truth.

---

# Setup Instructions

## Clone Repository

```bash
git clone <repository-url>
cd nzxtgen_os
```

## Install Dependencies

```bash
flutter pub get
```

## Verify Environment

```bash
flutter doctor
```

## Run Application

Android Device

```bash
flutter run
```

Chrome

```bash
flutter run -d chrome
```

Linux

```bash
flutter run -d linux
```

---

# Build Commands

Android APK

```bash
flutter build apk
```

Android App Bundle

```bash
flutter build appbundle
```

Web

```bash
flutter build web
```

Linux

```bash
flutter build linux
```

---

# Development Rules

* Follow Clean Architecture principles.
* Prefer reusable widgets.
* Avoid duplicated business logic.
* Maintain responsive design.
* Use Provider for state management.
* Use GoRouter for navigation.
* Keep UI consistent with Design.md.
* Update Tracker.md before major feature work.

---

# Contributors

Founder:
Fahad Khan

Project:
NZXTGEN Digital Services Platform

---

# License

Private Proprietary Software

Copyright © NZXTGEN

All rights reserved.
