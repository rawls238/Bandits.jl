using Distributions
abstract Bandit

type RandomBandit <: Bandit
  action_distributions::AbstractArray{Distribution}
  num_arms::Integer
end

pull(rb::RandomBandit, action_idx::Integer) = rand(action_distributions[action_idx]) 
