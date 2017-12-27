abstract type Policy end
abstract type Agent end

choose(p::Policy, a::Agent) = 0

immutable GreedyPolicy <: Policy end
choose(p::GreedyPolicy, a::Agent) = rand(findallmax(a.empirical_mean))

immutable EpsilonGreedyPolicy <: Policy
  ϵ::Float64
end

function choose(p::EpsilonGreedyPolicy, a::Agent)
  if rand() < p.ϵ
    return rand(1:length(a.empirical_mean))
  else
    return rand(findallmax(a.empirical_mean))
  end
end

immutable ThompsonSampling <: Policy end
choose(p::ThompsonSampling, a::Agent) = rand(findallmax(randomSample(a)))

immutable UCB1 <: Policy end
function choose(p::UCB1, a::Agent)
  num_arms = length(a.action_attempts)
  for i in 1:num_arms:
    if a.action_attempts[i] == 0.0
      return i

  ucb_values = [0.0 for i in range(num_arms)]
  total_counts = sum(a.action_attempts)
  for i in range(numArms):
    bonus = math.sqrt((2 * math.log(total_counts)) / float(a.action_attempts[i]))
    mean_reward = self.total_reward[i] / float(a.action_attempts[i])
    ucb_values[i] = mean_reward + bonus
  end
  return rand(finallmax(ucb_values))
end

immutable ExploreThenExploit <: Policy
  exploration_steps::Integer
end

function choose(p::ExploreThenExploit, a::Agent)
  if a.period < p.explorationSteps
    return rand(a.empirical_mean) 
  else
    return rand(findallmax(a.empirical_mean))
  end
end
