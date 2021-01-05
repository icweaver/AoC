### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 31de7d6c-4dc1-11eb-1590-19a9c961ddb6
using DelimitedFiles, BenchmarkTools, PlutoUI, CSV, DataFrames

# ╔═╡ a103d4dc-4e3c-11eb-1fd3-4f98e9c844d1
md"""
# Day 2
"""

# ╔═╡ 6b250524-4e3d-11eb-30f7-593168bcba2d
TableOfContents(depth=10)

# ╔═╡ a6774162-4e3c-11eb-09b6-81007befc95e
md"""
<https://adventofcode.com/2020/day/2>

```
--- Day 2: Password Philosophy ---

Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

For example, suppose you have the following list:

1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc

Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?
```
"""

# ╔═╡ 63f9925c-4e3c-11eb-2447-2d5faca06b5e
md"""
#### Load data
"""

# ╔═╡ f9bd0f50-4e3a-11eb-2880-9109dbeffc24
const input = CSV.read(
	"input.txt",
	DataFrame; datarow=1,
	header = [:rule_str, :char_str, :passwd]
)

# ╔═╡ a6fbc452-4e49-11eb-34a6-79f5622f7736
md"""
Great, each column looks to be of type `String`, so it doesn't look like there are any missing values here.
"""

# ╔═╡ 7f24ae86-4e3c-11eb-1a16-9b7b1f92669d
md"""
#### Implementation
"""

# ╔═╡ 0a3abc22-4e3d-11eb-2d99-3d12d8f667d6
md"""
We can just do this row by row, using each token to build/test our rule and count the final results of those that passed:
"""

# ╔═╡ 667a6ad8-4ef5-11eb-23dd-ab68ef2c9eff
# Returns total number of passwords from `input` that satisfy `rule`
function check_passwords(input, rule)
	return sum(rule(row...) for row in eachrow(input))
end

# ╔═╡ 3ed4dcba-4e3d-11eb-212d-55e48a789921
md"""
##### Part One
"""

# ╔═╡ 390d403c-4ef2-11eb-1c53-8533ada4f8d8
# Returns `true` if the occurence of the given character is within the given range
function rule_part1(rule_str, char_str, passwd)
	char_count_du = parse.(Int, split(rule_str, '-'))
	char = split(char_str, ":")[1]
	return count(char, passwd) ∈ UnitRange(char_count_du...)
end

# ╔═╡ e99531a6-4ef9-11eb-1abc-5f747b0d6437
check_passwords(input, rule_part1)

# ╔═╡ ecafeac2-4e3e-11eb-1531-a70f0b895e8c
md"""
##### Part Two
"""

# ╔═╡ 630740d0-4f02-11eb-29af-9580e06bdec1
md"""
The new rule can be called from `check_passwords` as well:
"""

# ╔═╡ 44e2483e-4f02-11eb-2fb8-13c0774d7ecb
md"""
Credit to [@Colin Caine](https://julialang.zulipchat.com/#narrow/stream/265470-advent-of-code-%282020%29/topic/Solutions.20day.202/near/218519027) for char trick
"""

# ╔═╡ d94312e6-4efe-11eb-1b93-59cc0dce4503
# Returns `true` if character exclusively exists in given 1-based index
function rule_part2(rule_str, char_str, passwd)
	char_idx1, char_idx2 = parse.(Int, split(rule_str, '-'))
	(char,) = split(char_str, ":")[1]
	return (passwd[char_idx1] == char) ⊻ (passwd[char_idx2] == char)
end

# ╔═╡ a921cba6-4eff-11eb-169b-8b3054bb6834
check_passwords(input, rule_part2)

# ╔═╡ Cell order:
# ╟─a103d4dc-4e3c-11eb-1fd3-4f98e9c844d1
# ╟─6b250524-4e3d-11eb-30f7-593168bcba2d
# ╟─a6774162-4e3c-11eb-09b6-81007befc95e
# ╟─63f9925c-4e3c-11eb-2447-2d5faca06b5e
# ╠═f9bd0f50-4e3a-11eb-2880-9109dbeffc24
# ╟─a6fbc452-4e49-11eb-34a6-79f5622f7736
# ╟─7f24ae86-4e3c-11eb-1a16-9b7b1f92669d
# ╟─0a3abc22-4e3d-11eb-2d99-3d12d8f667d6
# ╠═667a6ad8-4ef5-11eb-23dd-ab68ef2c9eff
# ╟─3ed4dcba-4e3d-11eb-212d-55e48a789921
# ╠═390d403c-4ef2-11eb-1c53-8533ada4f8d8
# ╠═e99531a6-4ef9-11eb-1abc-5f747b0d6437
# ╟─ecafeac2-4e3e-11eb-1531-a70f0b895e8c
# ╟─630740d0-4f02-11eb-29af-9580e06bdec1
# ╟─44e2483e-4f02-11eb-2fb8-13c0774d7ecb
# ╠═d94312e6-4efe-11eb-1b93-59cc0dce4503
# ╠═a921cba6-4eff-11eb-169b-8b3054bb6834
# ╠═31de7d6c-4dc1-11eb-1590-19a9c961ddb6
