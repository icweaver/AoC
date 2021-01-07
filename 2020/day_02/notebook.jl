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

Your puzzle answer was 582.
--- Part Two ---

While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

Given the same example list from above:

    1-3 a: abcde is valid: position 1 contains a and position 3 does not.
    1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
    2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.

How many passwords are valid according to the new interpretation of the policies?

Your puzzle answer was 729.

Both parts of this puzzle are complete! They provide two gold stars: **
```
"""

# ╔═╡ 63f9925c-4e3c-11eb-2447-2d5faca06b5e
md"""
#### Data validation
"""

# ╔═╡ de9ec584-5091-11eb-34ee-61e5147196f6
md"""
Each row should represent data for a given user. Taking a look at the first entry:
"""

# ╔═╡ 02fc4fa0-5092-11eb-0ab5-43749e524ab0
test_line = readline("input.txt")

# ╔═╡ 0c706ec2-5092-11eb-2917-b54b5064ea4e
md"""
we see that each piece is divided by a set amount of white space. The regex pattern might look something like:
"""

# ╔═╡ 7629f8e6-5095-11eb-14d0-139ad1db8fb8
const pattern = r"^(\d+)-(\d+) (\w): (.+)$"

# ╔═╡ 1a5a67ac-5099-11eb-2166-35b462a261ff
match(pattern, test_line).captures

# ╔═╡ 80bc2494-5095-11eb-2367-bf4cc93716f2
md"""
Let's test it out on the rest of our data:
"""

# ╔═╡ f9bd0f50-4e3a-11eb-2880-9109dbeffc24
with_terminal() do
	for (i, line) in enumerate(readlines("input.txt"))
		match(pattern, line) == nothing && println("$i $line")
	end
end

# ╔═╡ a6fbc452-4e49-11eb-34a6-79f5622f7736
md"""
Great, it looks like each line matches the pattern and we can continue with defining our password rules.
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
function check_passwords(input, passes_rule, pattern)
	return sum(passes_rule(line, pattern) for line in readlines(input))
end

# ╔═╡ 45a71624-50a0-11eb-27f1-197d1801062b
ps(pattern, line) = match(pattern, line).captures

# ╔═╡ 3ed4dcba-4e3d-11eb-212d-55e48a789921
md"""
##### Part One
"""

# ╔═╡ 390d403c-4ef2-11eb-1c53-8533ada4f8d8
# Returns `true` if the occurence of the given character is within the given range
function passes_rule_1(line, pattern)
	char_lo, char_hi, char, passwd = ps(pattern, line)
	char_lo, char_hi = parse.(Int, (char_lo, char_hi))
	@show char, passwd
	return count(char, passwd) ∈ UnitRange(char_lo, char_hi)
end

# ╔═╡ d8f138f2-509f-11eb-10e8-5fb003acb687
check_passwords("input.txt", passes_rule_1, pattern)

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
function passes_rule_2(line, pattern)
	char_idx_1, char_idx_2, (char,), passwd = ps(pattern, line)
	char_idx_1, char_idx_2 = parse.(Int, (char_idx_1, char_idx_2))
	return (passwd[char_idx_1] == char) ⊻ (passwd[char_idx_2] == char)
end

# ╔═╡ a921cba6-4eff-11eb-169b-8b3054bb6834
check_passwords("input.txt", passes_rule_2, pattern)

# ╔═╡ 8b5c683e-5093-11eb-26a7-ad6eecba862d
note(text) = Markdown.MD(Markdown.Admonition("note", "Note", [text]))

# ╔═╡ 6b6db236-5092-11eb-1a4e-27558722e03f
note(
md"""	
`(\d+)`: digit equal to [0-9], can match one or more times
	
`(\w)`: any word character
	
`(.+)`: any character, can match one or more times
	
`$`: asserts position at end of line
	
Credit to [@Colin Caine](https://julialang.zulipchat.com/#narrow/stream/265470-advent-of-code-%282020%29/topic/Solutions.20day.202/near/218590290) for the idea to use regex and [@Jordan Cluts](https://julialang.zulipchat.com/#narrow/stream/265470-advent-of-code-%282020%29/topic/Solutions.20day.202/near/218608500) for sharing this awesome [site](https://regex101.com/)!
"""
)

# ╔═╡ Cell order:
# ╟─a103d4dc-4e3c-11eb-1fd3-4f98e9c844d1
# ╟─6b250524-4e3d-11eb-30f7-593168bcba2d
# ╟─a6774162-4e3c-11eb-09b6-81007befc95e
# ╟─63f9925c-4e3c-11eb-2447-2d5faca06b5e
# ╟─de9ec584-5091-11eb-34ee-61e5147196f6
# ╠═02fc4fa0-5092-11eb-0ab5-43749e524ab0
# ╟─0c706ec2-5092-11eb-2917-b54b5064ea4e
# ╠═7629f8e6-5095-11eb-14d0-139ad1db8fb8
# ╠═1a5a67ac-5099-11eb-2166-35b462a261ff
# ╟─6b6db236-5092-11eb-1a4e-27558722e03f
# ╟─80bc2494-5095-11eb-2367-bf4cc93716f2
# ╠═f9bd0f50-4e3a-11eb-2880-9109dbeffc24
# ╟─a6fbc452-4e49-11eb-34a6-79f5622f7736
# ╟─7f24ae86-4e3c-11eb-1a16-9b7b1f92669d
# ╟─0a3abc22-4e3d-11eb-2d99-3d12d8f667d6
# ╠═667a6ad8-4ef5-11eb-23dd-ab68ef2c9eff
# ╠═45a71624-50a0-11eb-27f1-197d1801062b
# ╟─3ed4dcba-4e3d-11eb-212d-55e48a789921
# ╠═390d403c-4ef2-11eb-1c53-8533ada4f8d8
# ╠═d8f138f2-509f-11eb-10e8-5fb003acb687
# ╟─ecafeac2-4e3e-11eb-1531-a70f0b895e8c
# ╟─630740d0-4f02-11eb-29af-9580e06bdec1
# ╟─44e2483e-4f02-11eb-2fb8-13c0774d7ecb
# ╠═d94312e6-4efe-11eb-1b93-59cc0dce4503
# ╠═a921cba6-4eff-11eb-169b-8b3054bb6834
# ╟─8b5c683e-5093-11eb-26a7-ad6eecba862d
# ╠═31de7d6c-4dc1-11eb-1590-19a9c961ddb6
