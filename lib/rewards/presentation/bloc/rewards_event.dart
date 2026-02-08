/// Base class for all events related to rewards.
sealed class RewardsEvent {
  const RewardsEvent();
}

/// Event to get the current coin balance state.
class GetCoinsStateEvent extends RewardsEvent {
  const GetCoinsStateEvent();
}

/// Event to persist an updated coin balance.
class UpdateCoinsEvent extends RewardsEvent {
  const UpdateCoinsEvent();
}
