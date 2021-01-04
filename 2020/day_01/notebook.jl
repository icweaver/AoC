### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 31de7d6c-4dc1-11eb-1590-19a9c961ddb6
using DelimitedFiles, BenchmarkTools, PlutoUI

# ╔═╡ a103d4dc-4e3c-11eb-1fd3-4f98e9c844d1
md"""
# Day 1
"""

# ╔═╡ 6b250524-4e3d-11eb-30f7-593168bcba2d
TableOfContents(depth=10)

# ╔═╡ a6774162-4e3c-11eb-09b6-81007befc95e
md"""
<https://adventofcode.com/2020/day/1>

```
--- Day 1: Report Repair ---

After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

For example, suppose your expense report contained the following:

1721
979
366
299
675
1456

In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.

Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

Your puzzle answer was 100419.
--- Part Two ---

The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?

Your puzzle answer was 265253940.
```
"""

# ╔═╡ db96bda4-4e3b-11eb-2509-e97b895c759b
md"""
Credit to: [@Eric Hanson]( https://julialang.zulipchat.com/#narrow/stream/265470-advent-of-code-%282020%29/topic/Solutions.20day.201/near/218429827) and [@Colin Caine](https://julialang.zulipchat.com/#narrow/stream/265470-advent-of-code-%282020%29/topic/Solutions.20day.201/near/218459757) for their `Set` and `BitSet` solutions, respectively.
"""

# ╔═╡ 63f9925c-4e3c-11eb-2447-2d5faca06b5e
md"""
#### Load data
"""

# ╔═╡ f9bd0f50-4e3a-11eb-2880-9109dbeffc24
const input = BitSet(readdlm("input.txt", Int))

# ╔═╡ 7f24ae86-4e3c-11eb-1a16-9b7b1f92669d
md"""
#### Implementation
"""

# ╔═╡ 3ed4dcba-4e3d-11eb-212d-55e48a789921
md"""
##### Part One
"""

# ╔═╡ 0a3abc22-4e3d-11eb-2d99-3d12d8f667d6
md"""
The idea is to step through each entry one at a time until the sole match is found. The match is determined by the fact that if ``S - x`` exists in the collection for sum ``S \equiv x + y`` and entries ``x`` and ``y``, then we are done:
"""

# ╔═╡ 3a696636-4e39-11eb-1e15-577c3f7d1035
function part1(input, target)
    for x in input
        y = target - x
		y ∈ input && return x*y, (x, y)
    end
end

# ╔═╡ ecafeac2-4e3e-11eb-1531-a70f0b895e8c
md"""
##### Part Two
"""

# ╔═╡ fcf2c2ba-4e3e-11eb-255b-557e881d263e
md"""
Similary, for three inputs we are done if ``S - (x + y)`` exists for $S \equiv x +y + z$:
"""

# ╔═╡ 78e21ed8-4e38-11eb-1c77-d5ed37e15179
function part2(input, target)
    for x in input, y in input
        z = target - (x + y)
		z ∈ input && return x*y*z, (x, y, z)
    end
end

# ╔═╡ 3e694d04-4e3f-11eb-0205-cb346f9d4f89
md"""
Finally, we can use a `BitSet` to store our data because it is an efficient and quick storage container/accessor for densely packed integers.
"""

# ╔═╡ 8af86f9a-4e3c-11eb-0710-4f0bd58540ec
md"""
#### Test
"""

# ╔═╡ 285c8c3e-4e3b-11eb-1768-1bb3d269320c
md"""
Let's test our implementation on the sample input first:
"""

# ╔═╡ bc03ee56-4e38-11eb-26fb-2953e1ac4558
v = [
	1721 
	979
	366
	299
	1010
	675
	1456
]

# ╔═╡ 2f6040be-4e3b-11eb-0f7b-5d300b6070d2
part1(v, 2020), part2(v, 2020)

# ╔═╡ c7419e0a-4e3b-11eb-02d6-a5ba289354f2
md"""
Looks good! Now for the main input:
"""

# ╔═╡ 6ac9b524-4e39-11eb-33c4-851c10aadf2c
part1(input, 2020)

# ╔═╡ a8421b5e-4e38-11eb-2b5a-11b852af6247
part2(input, 2020)

# ╔═╡ 30401138-4e38-11eb-1f16-0bd14e4a4267
with_terminal() do
	@btime part1($input, 2020)
	@btime part2($input, 2020)
end

# ╔═╡ 8c0f81ae-4e3f-11eb-0d86-33bb971837d4
md"""
No allocations and very fast 🚀 
"""

# ╔═╡ Cell order:
# ╟─a103d4dc-4e3c-11eb-1fd3-4f98e9c844d1
# ╟─6b250524-4e3d-11eb-30f7-593168bcba2d
# ╟─a6774162-4e3c-11eb-09b6-81007befc95e
# ╟─db96bda4-4e3b-11eb-2509-e97b895c759b
# ╟─63f9925c-4e3c-11eb-2447-2d5faca06b5e
# ╠═f9bd0f50-4e3a-11eb-2880-9109dbeffc24
# ╟─7f24ae86-4e3c-11eb-1a16-9b7b1f92669d
# ╟─3ed4dcba-4e3d-11eb-212d-55e48a789921
# ╟─0a3abc22-4e3d-11eb-2d99-3d12d8f667d6
# ╠═3a696636-4e39-11eb-1e15-577c3f7d1035
# ╟─ecafeac2-4e3e-11eb-1531-a70f0b895e8c
# ╟─fcf2c2ba-4e3e-11eb-255b-557e881d263e
# ╠═78e21ed8-4e38-11eb-1c77-d5ed37e15179
# ╟─3e694d04-4e3f-11eb-0205-cb346f9d4f89
# ╟─8af86f9a-4e3c-11eb-0710-4f0bd58540ec
# ╟─285c8c3e-4e3b-11eb-1768-1bb3d269320c
# ╠═bc03ee56-4e38-11eb-26fb-2953e1ac4558
# ╠═2f6040be-4e3b-11eb-0f7b-5d300b6070d2
# ╟─c7419e0a-4e3b-11eb-02d6-a5ba289354f2
# ╠═6ac9b524-4e39-11eb-33c4-851c10aadf2c
# ╠═a8421b5e-4e38-11eb-2b5a-11b852af6247
# ╠═30401138-4e38-11eb-1f16-0bd14e4a4267
# ╟─8c0f81ae-4e3f-11eb-0d86-33bb971837d4
# ╠═31de7d6c-4dc1-11eb-1590-19a9c961ddb6
