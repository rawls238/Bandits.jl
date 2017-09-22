# Bandits

[![Build Status](https://travis-ci.org/rawls238/Bandits.jl.svg?branch=master)](https://travis-ci.org/rawls238/Bandits.jl)

This package provides tools for simulation of multi-armed bandit problems.

## Documentation

There are several underlying types that need to be constructed before simulation.

The first is a `Bandit` type, which specifies the true distribution of each of the arms. Currently only `StaticBandit` is implemented which takes an array of `Distribution` types from `Distributions.jl` (i.e. `staticbandit([Normal(0, 1), Uniform(0, 1)])`).

The second is a `Policy` type, which specifies the policy the agent is going to follow. This type is used to specify the arm the agent should choose given the agent's beliefs over the arms.

The third is a `Agent` type, which requires the prior of the agent, the underlying bandit, and the policy the agent should follow. 

Now, we can call `simulate` and get back a `BanditStats` object which returns the regret and the number of times each arm was pulled.

As well, this package provides an `aggregate_simulate` function which aggregates the results of N simulations run in parallel.

License: MIT
