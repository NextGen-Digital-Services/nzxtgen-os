import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String overview;
  final String category;
  final IconData icon;
  final String imageUrl;
  final List<String> benefits;
  final List<String> features;
  final List<TimelineStep> timeline;
  final List<PricingPlan> pricing;
  final List<FaqItem> faqs;
  final List<PortfolioItem> portfolio;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.overview,
    required this.category,
    required this.icon,
    required this.imageUrl,
    required this.benefits,
    required this.features,
    required this.timeline,
    required this.pricing,
    required this.faqs,
    required this.portfolio,
  });
}

class TimelineStep {
  final String title;
  final String description;
  final String duration;

  const TimelineStep({
    required this.title,
    required this.description,
    required this.duration,
  });
}

class PricingPlan {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;

  const PricingPlan({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
  });
}

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });
}

class PortfolioItem {
  final String title;
  final String description;
  final String imageUrl;

  const PortfolioItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
