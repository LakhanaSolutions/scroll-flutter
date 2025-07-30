import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Subscription status enum
enum SubscriptionStatus {
  freeTrial,
  premium,
  free,
}

/// Trial usage tracking data
class TrialUsageData {
  final int minutesUsed;
  final int maxMinutes;
  final DateTime lastResetAt;
  final int currentMonth;
  final int currentYear;

  const TrialUsageData({
    required this.minutesUsed,
    required this.maxMinutes,
    required this.lastResetAt,
    required this.currentMonth,
    required this.currentYear,
  });

  bool get hasTimeRemaining => minutesUsed < maxMinutes;
  int get remainingMinutes => maxMinutes - minutesUsed;
  double get usagePercentage => minutesUsed / maxMinutes;
  bool get isLimitReached => minutesUsed >= maxMinutes;

  TrialUsageData copyWith({
    int? minutesUsed,
    int? maxMinutes,
    DateTime? lastResetAt,
    int? currentMonth,
    int? currentYear,
  }) {
    return TrialUsageData(
      minutesUsed: minutesUsed ?? this.minutesUsed,
      maxMinutes: maxMinutes ?? this.maxMinutes,
      lastResetAt: lastResetAt ?? this.lastResetAt,
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
    );
  }
}

/// User subscription state
class SubscriptionState {
  final SubscriptionStatus status;
  final DateTime? trialEndDate;
  final bool hasActiveSubscription;
  final TrialUsageData? trialUsage;

  const SubscriptionState({
    required this.status,
    this.trialEndDate,
    required this.hasActiveSubscription,
    this.trialUsage,
  });

  bool get isFreeTrial => status == SubscriptionStatus.freeTrial;
  bool get isPremium => status == SubscriptionStatus.premium;
  bool get isFree => status == SubscriptionStatus.free;
  
  /// Should show premium ads (only show to free trial users)
  bool get shouldShowPremiumAds => status == SubscriptionStatus.freeTrial;
  
  /// Can access premium content (premium users or trial users with time remaining)
  bool get canAccessPremiumContent => isPremium || (isFreeTrial && (trialUsage?.hasTimeRemaining ?? false));

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    DateTime? trialEndDate,
    bool? hasActiveSubscription,
    TrialUsageData? trialUsage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
      trialUsage: trialUsage ?? this.trialUsage,
    );
  }
}

/// Subscription provider notifier
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(SubscriptionState(
    status: SubscriptionStatus.freeTrial, // Default to free trial for demo
    hasActiveSubscription: false,
    trialUsage: TrialUsageData(
      minutesUsed: 3, // Demo: user has used 3 minutes
      maxMinutes: 15,
      lastResetAt: DateTime.now().subtract(const Duration(days: 10)),
      currentMonth: DateTime.now().month,
      currentYear: DateTime.now().year,
    ),
  ));

  /// Update subscription status
  void updateSubscriptionStatus(SubscriptionStatus status) {
    state = state.copyWith(status: status);
  }

  /// Set as premium user
  void setPremium() {
    state = state.copyWith(
      status: SubscriptionStatus.premium,
      hasActiveSubscription: true,
    );
  }

  /// Set as free user (trial ended)
  void setFree() {
    state = state.copyWith(
      status: SubscriptionStatus.free,
      hasActiveSubscription: false,
    );
  }

  /// Set as free trial user
  void setFreeTrial({DateTime? trialEndDate}) {
    state = state.copyWith(
      status: SubscriptionStatus.freeTrial,
      trialEndDate: trialEndDate,
      hasActiveSubscription: false,
    );
  }

  /// Update trial usage data
  void updateTrialUsage(TrialUsageData usage) {
    state = state.copyWith(trialUsage: usage);
  }

  /// Add minutes to trial usage
  void addTrialUsage(int minutes) {
    if (state.trialUsage != null) {
      final newUsage = state.trialUsage!.copyWith(
        minutesUsed: (state.trialUsage!.minutesUsed + minutes).clamp(0, state.trialUsage!.maxMinutes),
      );
      state = state.copyWith(trialUsage: newUsage);
    }
  }

  /// Reset trial usage for new month
  void resetTrialUsage() {
    if (state.trialUsage != null) {
      final now = DateTime.now();
      final newUsage = state.trialUsage!.copyWith(
        minutesUsed: 0,
        lastResetAt: now,
        currentMonth: now.month,
        currentYear: now.year,
      );
      state = state.copyWith(trialUsage: newUsage);
    }
  }
}

/// Subscription provider
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

/// Helper providers for specific states
final shouldShowPremiumAdsProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.shouldShowPremiumAds));
});

final isFreeTrialProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.isFreeTrial));
});

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.isPremium));
});

final canAccessPremiumContentProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.canAccessPremiumContent));
});

final trialUsageDataProvider = Provider<TrialUsageData?>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.trialUsage));
});