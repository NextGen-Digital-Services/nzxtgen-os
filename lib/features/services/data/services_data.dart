import 'package:flutter/material.dart';
import 'models/service_model.dart';

class ServicesData {
  ServicesData._();

  static final List<ServiceModel> services = [
    // 1. Website Development
    const ServiceModel(
      id: 'website-development',
      title: 'Website Development',
      description: 'Stunning, high-performance web applications built for optimal speed and UX.',
      overview: 'Transform your web presence with Next-Gen engineering. We build high-converting landing pages, interactive marketing sites, and full-stack custom web applications optimized for speed, search engines, and modern accessibility standards.',
      category: 'Development',
      icon: Icons.web_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1547082299-de196ea013d6?w=600&auto=format&fit=crop&q=80',
      benefits: [
        '99+ Google PageSpeed Optimization score',
        'Responsive layouts supporting all modern browsers',
        'Built using Next.js, Flutter Web, or TailwindCSS',
        'SEO-optimized architecture right out of the box'
      ],
      features: [
        'Custom interactive 3D elements & animations',
        'Server-side rendering (SSR) for instant loads',
        'Dynamic CMS integration (Sanity / Contentful)',
        'Built-in analytics dashboard integrations',
        'PWA (Progressive Web App) deployment capabilities'
      ],
      timeline: [
        TimelineStep(
          title: 'Discovery & Design Figma',
          description: 'Interactive low-fidelity wireframing and user experience mockups in Figma.',
          duration: 'Week 1-2',
        ),
        TimelineStep(
          title: 'Frontend Development',
          description: 'Translating Figma designs into clean, responsive pixel-perfect HTML/CSS/Dart/JS.',
          duration: 'Week 3-4',
        ),
        TimelineStep(
          title: 'Testing & Launch',
          description: 'Cross-browser testing, PageSpeed optimization audits, and Cloudflare deployment.',
          duration: 'Week 5',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Starter Landing',
          price: '\$2,999',
          period: 'one-time',
          features: [
            '1 Single Page layout',
            'Figma design conversion',
            'Full mobile responsiveness',
            'Standard SEO setup',
            '3 months free maintenance'
          ],
        ),
        PricingPlan(
          title: 'Premium Web App',
          price: '\$5,499',
          period: 'one-time',
          features: [
            'Up to 7 custom pages',
            'CMS Content management integration',
            'Custom high-performance animations',
            'Advanced SEO & Analytics tracking',
            '6 months support & host support',
          ],
          isPopular: true,
        ),
        PricingPlan(
          title: 'Enterprise Custom',
          price: '\$9,999',
          period: 'one-time',
          features: [
            'Unlimited pages & custom databases',
            'Tailored full-stack backend APIs',
            'Realtime database hooks',
            'Dynamic multi-language localization',
            '1 Year dedicated SLAs'
          ],
        ),
      ],
      faqs: [
        FaqItem(
          question: 'Do you build using templates or custom code?',
          answer: 'All our projects are handcrafted from blank Figma canvases and custom coded to ensure peak performance, clean code structures, and zero bloated template weight.',
        ),
        FaqItem(
          question: 'Will I be able to edit the content myself later?',
          answer: 'Yes. We integrate robust, modern Headless CMS systems like Sanity or Strapi so your marketing team can publish pages and update text/images instantly without code.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Apex SaaS Portal',
          description: 'A dark cyber-themed landing page featuring WebGL particle systems.',
          imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&auto=format&fit=crop&q=80',
        ),
        PortfolioItem(
          title: 'Veloce E-Commerce',
          description: 'Headless shop platform boasting a 0.8s load time and custom cart logic.',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 2. App Development
    const ServiceModel(
      id: 'app-development',
      title: 'App Development',
      description: 'High-fidelity cross-platform mobile apps for iOS and Android built on Flutter.',
      overview: 'Launch native iOS and Android apps powered by a unified codebase. Using Flutter and native integrations, we craft beautiful micro-interactions, responsive screens, offline data caching, and secure cloud synchronization.',
      category: 'Development',
      icon: Icons.phone_iphone_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Single code-base deployment for iOS & Android',
        '60 FPS smooth animations & responsive controls',
        'Secure token storage and offline-first databases',
        'App Store and Play Store launch management'
      ],
      features: [
        'Push notifications & localized scheduling',
        'Biometric authentication (FaceID / Fingerprint)',
        'Background task processing & background sync',
        'Hardware integrations (Camera, GPS, Bluetooth)',
        'Real-time analytics and crashlytics reporters'
      ],
      timeline: [
        TimelineStep(
          title: 'UX Flowcharts & Design',
          description: 'Mapping out screens, user permissions, states, and interactive user pathways.',
          duration: 'Week 1-3',
        ),
        TimelineStep(
          title: 'Feature Implementation',
          description: 'Core logic, backend integration, offline caching, and widget testing.',
          duration: 'Week 4-8',
        ),
        TimelineStep(
          title: 'Beta Testing & Launch',
          description: 'TestFlight deployment, Google Play internal testing, and App Store submission.',
          duration: 'Week 9-10',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Cross-Platform MVP',
          price: '\$6,499',
          period: 'one-time',
          features: [
            'iOS & Android native build',
            'Up to 10 user screens',
            'Supabase/Firebase core sync',
            'Social login integration',
            'Store publishing walkthrough'
          ],
        ),
        PricingPlan(
          title: 'Pro Feature App',
          price: '\$11,999',
          period: 'one-time',
          features: [
            'Up to 22 custom screens',
            'Offline data caching & sync',
            'Push notification campaign hooks',
            'Custom hardware integrations',
            '6 Months developer SLA support',
          ],
          isPopular: true,
        ),
        PricingPlan(
          title: 'Enterprise Scaled',
          price: '\$24,999',
          period: 'one-time',
          features: [
            'Unlimited screens & clean architectures',
            'Full offline sync engine',
            'Payment gateway & subscription systems',
            'Complete custom admin backend API',
            '1 Year priority developer SLA'
          ],
        ),
      ],
      faqs: [
        FaqItem(
          question: 'Do you use hybrid web views or native components?',
          answer: 'We develop using Flutter, compiling directly to native ARM machine code. This guarantees high-end graphics rendering speeds, fast load metrics, and standard native controls.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Volt Health Monitor',
          description: 'Real-time heart sensor app connected via BLE with local SQL databases.',
          imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 3. CRM Development
    const ServiceModel(
      id: 'crm-development',
      title: 'CRM Development',
      description: 'Custom customer relationship platforms built to match your internal workflows.',
      overview: 'Commercial CRMs force your team to adapt to their rigid UI. We engineer bespoke CRMs tailored exactly around your sales channels, client onboarding pipelines, automated triggers, and reporting structures.',
      category: 'Development',
      icon: Icons.dashboard_customize_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Zero monthly per-user licensing fees',
        'Custom lead-scoring and lifecycle tracking',
        'Integration with VoIP, Email, and Slack API',
        'Enterprise-level role and permission security'
      ],
      features: [
        'Kanban sales boards with drag-and-drop',
        'Interactive analytics graphs and metrics',
        'Automated email trigger sequences',
        'CSV/Excel import & export pipelines',
        'Mobile-friendly responsive dashboard layout'
      ],
      timeline: [
        TimelineStep(
          title: 'Workflow Mapping',
          description: 'Documenting current internal procedures, roles, data schemas, and pipeline structures.',
          duration: 'Week 1-2',
        ),
        TimelineStep(
          title: 'Database & Dashboard Code',
          description: 'Building schema architectures, dashboard charts, pipelines, and notifications.',
          duration: 'Week 3-7',
        ),
        TimelineStep(
          title: 'Onboarding & Deployment',
          description: 'User-testing sessions, training videos, security penetration tests, and VPS hosting launch.',
          duration: 'Week 8',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Bespoke Lite',
          price: '\$4,999',
          period: 'one-time',
          features: [
            'Lead management database',
            'Simple Sales Pipeline board',
            'Basic Email template sender',
            'Up to 10 operator seats',
            '3 Months post-launch support'
          ],
        ),
        PricingPlan(
          title: 'Agency Suite',
          price: '\$9,499',
          period: 'one-time',
          features: [
            'Multi-stage pipeline custom rules',
            'VoIP and automated SMS systems',
            'Detailed analytics dashboard charts',
            'Unlimited user accounts & permissions',
            '6 Months support SLA',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'Can we migrate our existing Salesforce/HubSpot data?',
          answer: 'Absolutely. We will build custom migration scripts to clean, map, and import your CSV data pipelines into the new database without losing key client histories.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Nova Client Engine',
          description: 'Sales dashboard servicing over 50 real estate agents with automated SMS.',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 4. Meta Ads
    const ServiceModel(
      id: 'meta-ads',
      title: 'Meta Ads Management',
      description: 'High-ROAS advertising campaigns scaled across Facebook and Instagram.',
      overview: 'Stop wasting budget on simple boosted posts. We execute structured advertising funnels across Meta channels targeting high-value customer profiles, combining stunning visual ad creatives with precise pixel event tracking.',
      category: 'Marketing',
      icon: Icons.ads_click_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Data-driven audience funnel mapping',
        'Continuous Creative testing & variations',
        'CAPI (Conversions API) pixel installations',
        'Weekly video dashboard performance reports'
      ],
      features: [
        'A/B testing ad copy & creatives',
        'Lookalike & Custom audience modeling',
        'Dynamic catalog ads for E-Commerce',
        'Retargeting sequences to capture leaks',
        'Competitor market trend analysis'
      ],
      timeline: [
        TimelineStep(
          title: 'Funnel & Tracking Audit',
          description: 'Configuring Meta Conversions API, catalog uploads, and building initial ad content.',
          duration: 'Week 1',
        ),
        TimelineStep(
          title: 'Launch & Learning Phase',
          description: 'Running budget tests to collect audience performance data and find high-performing targets.',
          duration: 'Week 2-3',
        ),
        TimelineStep(
          title: 'Scaling and Growth',
          description: 'Aggressing budget on high-performing copy, pruning underperforming ads, and horizontal scaling.',
          duration: 'Ongoing',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Starter Scale',
          price: '\$1,499',
          period: 'month',
          features: [
            'Up to \$5k/mo ad spend management',
            '5 Creative ad assets built by us',
            'Standard pixel event hooks',
            'Weekly campaign updates',
            'Monthly strategy calls'
          ],
        ),
        PricingPlan(
          title: 'Growth Accelerator',
          price: '\$2,999',
          period: 'month',
          features: [
            'Up to \$25k/mo ad spend management',
            '15 Custom ad creatives/mo',
            'Conversions API (CAPI) backend hook',
            'Competitor analysis dashboard',
            'Bi-weekly live sync calls',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'Does the pricing include the advertising budget?',
          answer: 'No. The advertising budget is paid directly to Meta. Our fee is for strategist hours, campaign setup, continuous optimizations, and professional creative graphic assets.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'FitWear Growth Funnel',
          description: 'Scaled an Athleisure brand from 1.2x to 4.5x ROAS in 90 days.',
          imageUrl: 'https://images.unsplash.com/photo-1571721795195-a2ca2d33e402?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 5. Google Ads
    const ServiceModel(
      id: 'google-ads',
      title: 'Google Ads (SEM)',
      description: 'Target high-intent search traffic and scale conversions on Search, Display, & YouTube.',
      overview: 'Capture clients at the exact moment they search for your solutions. We design search campaigns, Performance Max channels, and remarketing lists to secure top placements for high-intent keywords.',
      category: 'Marketing',
      icon: Icons.campaign_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Detailed high-intent keyword harvesting',
        'Negative keyword management to prune waste',
        'Responsive Search Ads with custom copy hooks',
        'Maximized Quality Score adjustments for lower CPC'
      ],
      features: [
        'PMax (Performance Max) strategy builds',
        'YouTube video remarketing setups',
        'Google Merchant Center shopping optimization',
        'Conversion tracking tags via GTM',
        'Competitive bidding algorithms monitoring'
      ],
      timeline: [
        TimelineStep(
          title: 'Keyword Research & Setup',
          description: 'Keyword search volumes audit, bidding strategies, and landing page checks.',
          duration: 'Week 1',
        ),
        TimelineStep(
          title: 'Campaign Activation',
          description: 'Ad copy publishing, negative lists configuration, and bid adjustments.',
          duration: 'Week 2',
        ),
        TimelineStep(
          title: 'Optimization Cycles',
          description: 'Pruning bad keywords, updating match types, and scaling budgets on converters.',
          duration: 'Ongoing',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Search Focus',
          price: '\$1,499',
          period: 'month',
          features: [
            'Up to \$5k/mo ad budget control',
            'Search text ad configurations',
            'Basic negative keyword setups',
            'Google Analytics 4 setup',
            'Monthly report cards'
          ],
        ),
        PricingPlan(
          title: 'Full Omnichannel',
          price: '\$2,999',
          period: 'month',
          features: [
            'Up to \$30k/mo ad budget control',
            'Search, Display, Shopping, & PMax',
            'Google Merchant catalog maintenance',
            'Dynamic call tracking tags setup',
            'Bi-weekly strategists updates',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'What is Google Quality Score and why does it matter?',
          answer: 'Quality Score measures keyword relevance, click CTR, and landing page UX. A higher score means Google charges you less money to place your ad in top slots.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'LawGroup Lead Acquisition',
          description: 'Increased high-value consulting inquiries by 180% while cutting cost-per-lead by 34%.',
          imageUrl: 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 6. SEO
    const ServiceModel(
      id: 'seo',
      title: 'Search Engine Optimization',
      description: 'Dominate organic search results with custom technical and content SEO strategies.',
      overview: 'Stop renting traffic. Own it. We implement comprehensive SEO processes covering core page speeds, site maps, high-impact content blogs, and authoritative link networks to earn top organic ranking positions.',
      category: 'Marketing',
      icon: Icons.search_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1571721795195-a2ca2d33e402?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'E-E-A-T score optimization guidelines',
        'Technical code crawling and indexation fixes',
        'Long-tail buyer keyword strategies',
        'Increasing compounding monthly inbound organic traffic'
      ],
      features: [
        'Core Web Vitals code fixes',
        'Structured schema schema markup injection',
        'Competitor backlink gap strategies',
        'Semantic content brief creation',
        'Google Search Console tracking audits'
      ],
      timeline: [
        TimelineStep(
          title: 'Technical Audit',
          description: 'Scanning indexation errors, metadata gaps, and loading performance blockers.',
          duration: 'Month 1',
        ),
        TimelineStep(
          title: 'On-Page & Content Blueprint',
          description: 'Optimizing titles, headers, image alt text, and launching monthly SEO blogs.',
          duration: 'Month 2',
        ),
        TimelineStep(
          title: 'Backlinks & Compound Growth',
          description: 'Executing clean digital PR outreach and earning trust metrics.',
          duration: 'Ongoing',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'SEO Core',
          price: '\$1,999',
          period: 'month',
          features: [
            'Technical indexation audit',
            'On-page title/meta tag updates',
            '2 Custom SEO-written blogs/mo',
            'Keyword position tracking charts',
            'Monthly organic traffic reports'
          ],
        ),
        PricingPlan(
          title: 'Authority Scaled',
          price: '\$3,499',
          period: 'month',
          features: [
            'Full technical page speed fixes',
            '6 Custom SEO articles/mo',
            'Competitor keyword stealing plan',
            'Authority link outreach campaigns',
            'Live analytics access & calls',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'How long does it take to see results on SEO?',
          answer: 'Unlike paid ads, SEO is a long-term asset. You will typically begin to see rank movements in 45-90 days, with compounding traffic increases peaking between 6-12 months.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Fintech Blog Expansion',
          description: 'Grew organic search views from 10k to 140k monthly sessions inside 8 months.',
          imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 7. Branding
    const ServiceModel(
      id: 'branding',
      title: 'Premium Brand Identity',
      description: 'Create memorable brand systems including logos, typography, and visual assets.',
      overview: 'Align your business visual quality with your engineering excellence. We design modern typographic rules, primary logos, color constants, social guidelines, and interactive design files tailored for luxury SaaS companies.',
      category: 'Design',
      icon: Icons.brush_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Cohesive and premium brand presentation',
        'Fully layered vector files and formats',
        'Comprehensive style guideline books',
        'Custom typographies and color schemes'
      ],
      features: [
        'Modern primary & sub logo designs',
        'Custom mood boards & voice concepts',
        'Color palette specifications (RGB, CMYK, Pantone)',
        'Social media banner template layouts',
        'Business card and letterhead layouts'
      ],
      timeline: [
        TimelineStep(
          title: 'Mood Boards & Concepts',
          description: 'Exploring color ideas, visual references, and conceptual styles.',
          duration: 'Week 1-2',
        ),
        TimelineStep(
          title: 'Logo Design & Selection',
          description: 'Iterating on primary logos, icons, typographies, and layouts.',
          duration: 'Week 3-4',
        ),
        TimelineStep(
          title: 'Asset Export & Guidelines',
          description: 'Packaging asset source files and publishing the brand handbook.',
          duration: 'Week 5',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Identity Kit',
          price: '\$2,499',
          period: 'one-time',
          features: [
            'Primary logo design',
            'Brand color guidelines',
            'Font selections',
            'Source vector files',
            '1 round of revisions'
          ],
        ),
        PricingPlan(
          title: 'Premium Enterprise Brand',
          price: '\$4,999',
          period: 'one-time',
          features: [
            '3 Custom logo concepts to choose from',
            'Detailed 40-page style manual',
            'Stationery & digital banner mockups',
            'Presentation templates (Pitch Deck)',
            'Unlimited design iterations',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'What source files will I receive?',
          answer: 'You will receive fully editable source files including Adobe Illustrator (.AI), Figma design files, EPS vectors, print-ready PDFs, and transparent PNGs.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Holo Systems Identity',
          description: 'Developed complete branding suite, pitch decks, and web design styles for a quantum computing startup.',
          imageUrl: 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 8. AI Automation
    const ServiceModel(
      id: 'ai-automation',
      title: 'AI Automation & Agents',
      description: 'Integrate LLMs, AI agents, and workflow automations to reduce manual tasks.',
      overview: 'Eradicate operational bottlenecks with AI. We build custom automations connecting your software tools (CRM, Email, Slack, Databases) using tools like Make/Zapier, or deploy customized OpenAI/Claude agents to handle lead categorization, customer support, and automatic content scheduling.',
      category: 'AI',
      icon: Icons.auto_awesome_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780efad99a?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Up to 80% reduction in manual data entries',
        '24/7/365 automated client support responding',
        'Integrate state-of-the-art LLMs (GPT-4, Claude 3.5)',
        'Detailed pipeline logging and error control'
      ],
      features: [
        'Custom customer service chat routing agents',
        'Automated database updates from incoming emails',
        'Dynamic invoice generation & followups',
        'AI voice transcription and summary scripts',
        'API schema integrations between fragmented tools'
      ],
      timeline: [
        TimelineStep(
          title: 'Operations Audit',
          description: 'Analyzing manual processes, checking software APIs, and defining automation routes.',
          duration: 'Week 1',
        ),
        TimelineStep(
          title: 'Workflow Development',
          description: 'Linking APIs, programming prompts, configuring triggers, and test loops.',
          duration: 'Week 2-4',
        ),
        TimelineStep(
          title: 'Launch & QA monitoring',
          description: 'Deploying agents, running volume simulations, and training internal managers.',
          duration: 'Week 5',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Workflow Boost',
          price: '\$2,999',
          period: 'one-time',
          features: [
            'Up to 3 multi-step automations',
            'Zapier/Make account configurations',
            'Standard LLM prompt API settings',
            'Basic error log dashboard',
            '30 days post-launch support'
          ],
        ),
        PricingPlan(
          title: 'Agent Deploy Suite',
          price: '\$6,999',
          period: 'one-time',
          features: [
            'Up to 8 custom automations',
            'Custom AI agent assistant for Slack/Discord',
            'Vector database integration for memory',
            'Complete custom script API wrappers',
            '90 days optimization SLA',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'Are there monthly runtime fees for AI?',
          answer: 'Yes. Depending on your volume, tool platforms like Zapier, Make, and OpenAI API tokens have small monthly usage fees which we help optimize to keep operating overhead low.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Apex Agency Automations',
          description: 'Automated sales lead scoring, client document updates, and Slack notices saving 25 hours weekly.',
          imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),

    // 9. Graphic Design
    const ServiceModel(
      id: 'graphic-design',
      title: 'Expert Graphic Design',
      description: 'Stunning marketing visuals, presentation materials, and digital graphics.',
      overview: 'Acquire access to senior graphic designers. We supply beautiful visuals for social networks, presentation decks, advertisements, custom graphics, and product boxes designed to align with premium SaaS design aesthetics.',
      category: 'Design',
      icon: Icons.palette_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1561070791-26c113006238?w=600&auto=format&fit=crop&q=80',
      benefits: [
        'Pixel-perfect assets matching brand standards',
        'Super fast turnaround times (under 48h for basic assets)',
        'Clean source files and templates for marketing teams',
        'Expert advice on modern premium layouts'
      ],
      features: [
        'Stunning social media post grids & cards',
        'Pitch decks and investor presentation decks',
        'Physical product box design and layouts',
        'High-converting ad creatives design assets',
        'Custom SVG vectors for applications'
      ],
      timeline: [
        TimelineStep(
          title: 'Creative Briefing',
          description: 'Collecting design files, copy instructions, asset dimensions, and specs.',
          duration: 'Week 1',
        ),
        TimelineStep(
          title: 'Design Drafting',
          description: 'Developing graphics layouts, coloring variations, and styling options.',
          duration: 'Week 2',
        ),
        TimelineStep(
          title: 'Final Handover',
          description: 'Pruning styles based on review comments and exporting high-res formats.',
          duration: 'Week 3',
        ),
      ],
      pricing: [
        PricingPlan(
          title: 'Asset Sprint',
          price: '\$1,199',
          period: 'one-time',
          features: [
            'Up to 10 visual assets',
            'Social banner templates included',
            'Full source Figma files',
            '2 revisions iterations',
            '7-day delivery speed'
          ],
        ),
        PricingPlan(
          title: 'Graphic Subscription',
          price: '\$2,499',
          period: 'month',
          features: [
            'Unlimited custom graphic requests',
            '48-hour delivery times',
            'Dedicated visual strategist',
            'Print and digital assets support',
            'Cancel any time model',
          ],
          isPopular: true,
        ),
      ],
      faqs: [
        FaqItem(
          question: 'What is the request pipeline for the monthly subscription?',
          answer: 'You receive access to a dedicated Trello board where you can queue as many graphic requests as you like. We build and deliver them sequentially.',
        ),
      ],
      portfolio: [
        PortfolioItem(
          title: 'Cyber Deck Visuals',
          description: 'Created an investor presentation deck that helped secure \$2.4M in seed funding.',
          imageUrl: 'https://images.unsplash.com/photo-1561070791-26c113006238?w=400&auto=format&fit=crop&q=80',
        ),
      ],
    ),
  ];
}
