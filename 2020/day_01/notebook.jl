### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 31de7d6c-4dc1-11eb-1590-19a9c961ddb6
using DelimitedFiles, BenchmarkTools

# ╔═╡ 3b797b06-4dc1-11eb-3505-61aee2961df0
input = readdlm("input.txt", Int)

# ╔═╡ b63f89e0-4dd3-11eb-2dd0-9fcef3438ba5
md"""
- Split expenses into two halves, one with amounts greater than half the sum $S=2020$ (`v_big_half`), and one with amounts all less than that `v_small_half`. We now know that one and only one expense that sums to this amount is in each half.
- Filter out any remaining expenses from the "large" half that would be larger than `S` (`big_diff_reduced`).
- By definition if an element in `big_diff_reduced` is also in `v_small_half`, we have our pair that sums to $S$, so find it and return its product.
"""

# ╔═╡ 3f2dc366-4dd2-11eb-16bc-77c580cdc1a9
function pair_sum_prod(v, ps)
	big_half_mask = v .> (ps ÷ 2)
	v_big_half = v[big_half_mask]
	v_small_half = v[.!big_half_mask]
	big_diff = ps .- v_big_half
	big_diff_reduced = big_diff[big_diff .≥ 0]
	for val in big_diff_reduced
		val ∈ v_small_half && return ps-val, val, (ps-val)*val
	end
end

# ╔═╡ 0bcedf4c-4dd3-11eb-235a-9f9b848f408b
pair_sum_prod(input, 2020)

# ╔═╡ Cell order:
# ╠═3b797b06-4dc1-11eb-3505-61aee2961df0
# ╟─b63f89e0-4dd3-11eb-2dd0-9fcef3438ba5
# ╠═3f2dc366-4dd2-11eb-16bc-77c580cdc1a9
# ╠═0bcedf4c-4dd3-11eb-235a-9f9b848f408b
# ╠═31de7d6c-4dc1-11eb-1590-19a9c961ddb6
