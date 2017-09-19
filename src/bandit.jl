using Distributions
abstract Bandit
pull(b::Bandit, action_idx::Integer) = 0


type StaticBandit <: Bandit
  action_distributions::AbstractArray{Distribution}
  num_arms::Integer
end

pull(sb::StaticBandit, action_idx::Integer) = rand(sb.action_distributions[action_idx]) 
