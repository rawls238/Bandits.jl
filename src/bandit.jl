using Distributions

abstract type Bandit end
pull(b::Bandit, action_idx::Integer) = 0
regret(b::Bandit, action_idx::Integer) = 0


type StaticBandit <: Bandit
  action_distributions::AbstractVector{Distribution}
  optimal_expected_return::Float64 #here the arms are static so the best arm is always the same
  function StaticBandit(action_distributions::AbstractVector{Distribution})
    opt = maximum([mean(distr) for distr in action_distributions])
    StaticBandit(action_distributions, opt)
  end
end

pull(sb::StaticBandit, action_idx::Integer) = rand(sb.action_distributions[action_idx])

regret(sb::StaticBandit, action_idx::Integer) = sb.optimal_expected_return - mean(sb.action_distributions[action_idx])
