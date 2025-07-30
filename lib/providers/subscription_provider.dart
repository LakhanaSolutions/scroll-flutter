import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Subscription status enum
enum SubscriptionStatus {
  freeTrial,
  premium,
  free,
}

/// User subscription state
class SubscriptionState {
  final SubscriptionStatus status;
  final DateTime? trialEndDate;
  final bool hasActiveSubscription;

  const SubscriptionState({
    required this.status,
    this.trialEndDate,
    required this.hasActiveSubscription,
  });

  bool get isFreeTrial => status == SubscriptionStatus.freeTrial;
  bool get isPremium => status == SubscriptionStatus.premium;
  bool get isFree => status == SubscriptionStatus.free;
  
  /// Should show premium ads (only show to free trial users)
  bool get shouldShowPremiumAds => status == SubscriptionStatus.freeTrial;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    DateTime? trialEndDate,
    bool? hasActiveSubscription,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
    );
  }
}

/// Subscription provider notifier
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState(
    status: SubscriptionStatus.freeTrial, // Default to free trial for demo
    hasActiveSubscription: false,
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