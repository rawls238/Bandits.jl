using Distributions

abstract type Bandit end
pull(b::Bandit, action_idx::Integer) = 0
regret(b::Bandit, action_idx::Integer) = 0


struct StaticBandit <: Bandit
  action_distributions::AbstractVector{Distribution}
  num_arms::Integer
  optimal_expected_return::Float64 #here the arms are static so the best arm is always the same
end

# TODO: weird typing issue here - have a sense it's a Julia bug or I'm misunderstanding something in v0.6
staticbandit(action_distributions) = StaticBandit(action_distributions, length(action_distributions), maximum([mean(distr) for distr in action_distributions]))

pull(sb::StaticBandit, action_idx::Integer) = rand(sb.action_distributions[action_idx])

regret(sb::StaticBandit, action_idx::Integer) = sb.optimal_expected_return - mean(sb.action_distributions[action_idx])
