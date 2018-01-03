abstract type Policy end
abstract type Agent end

choose(p::Policy, a::Agent) = 0

immutable GreedyPolicy <: Policy end
choose(p::GreedyPolicy, a::Agent) = rand(find_all_max_indices(a.empirical_mean))

immutable EpsilonGreedyPolicy <: Policy
  ϵ::Float64
end

function choose(p::EpsilonGreedyPolicy, a::Agent)
  if rand() < p.ϵ
    return rand(1:length(a.empirical_mean))
  else
    return rand(find_all_max_indices(a.empirical_mean))
  end
end

immutable ThompsonSampling <: Policy end
choose(p::ThompsonSampling, a::Agent) = rand(find_all_max_indices(randomSample(a)))

immutable UCB1 <: Policy end
function choose(p::UCB1, a::Agent)
  num_arms = length(a.action_attempts)
  for i in 1:num_arms
    if a.action_attempts[i] == 0.0
      return i
    end
  end

  ucb_values = [0.0 for i in 1:num_arms]
  total_counts = sum(a.action_attempts)
  for i in 1:num_arms
    action_attempts = convert(AbstractFloat, a.action_attempts[i])
    bonus = sqrt((2 * log(total_counts)) / action_attempts)
    mean_reward = a.total_reward[i] / action_attempts
    ucb_values[i] = mean_reward + bonus
  end
  return rand(find_all_max_indices(ucb_values))
end

immutable ExploreThenExploit <: Policy
  exploration_steps::Integer
end

function choose(p::ExploreThenExploit, a::Agent)
  if a.period < p.exploration_steps
    return rand(1:length(a.empirical_mean))
  else
    return rand(find_all_max_indices(a.empirical_mean))
  end
end
