import 'package:admin_service/providers/recource_provider.dart';
import 'package:admin_service/resources/config.dart';
import 'package:admin_service/resources/loyalty.dart';
import 'package:admin_service/resources/recipes.dart';
import 'package:admin_service/resources/options.dart';
import 'package:admin_service/resources/reports.dart';
import 'package:admin_service/resources/services.dart';
import 'package:flutter/material.dart';
import 'package:admin_service/resources/summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Resource extends ConsumerStatefulWidget {
  const Resource({super.key});

  @override
  ResourceState createState() => ResourceState();
}

class ResourceState extends ConsumerState<Resource> {
  int id = 0;
  @override
  Widget build(BuildContext context) {
    switch (ref.watch(resourceProvider).tabId) {
      case 3:
        return (RecipesScreen());
      case 2:
        return (ServicesScreen());
      case 4:
        return (OptionsScreen());
      case 5:
        return (LoyaltyScreen());
      case 6:
        return (ReportsScreen());
      case 8:
        return (ConfigSetScreen());
      default:
        return (Summary());
    }
  }
}
