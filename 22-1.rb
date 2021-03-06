p1 = %w(28
50
9
11
4
45
19
26
42
43
31
46
21
40
33
20
7
6
17
44
5
39
35
27
10).map{|x|x.to_i}

p2 = %w(18
16
29
41
14
12
30
37
36
24
48
38
47
34
15
8
49
23
1
3
32
25
22
13
2).map{|x|x.to_i}

while p1.length!=0 && p2.length!=0
  p1c = p1.first
  p2c = p2.first
  if p1c < p2c
    p1 = p1[1..p1.length-1]
    p2 = p2[1..p2.length-1] + [p2c, p1c]
  else
    p2 = p2[1..p2.length-1]
    p1 = p1[1..p1.length-1] + [p1c, p2c]
  end
end

winner = p1.length > p2.length ? p1 : p2
winner = winner.reverse

count = 0
winner.each_with_index do |w, i|
  count += w * (i+1)
end

p count