input = [16,11,15,0,1,7]

hash = {}

input.each_with_index do |n, i|
  hash[n] = [1, i]
end

number = input.last
lastIndex = 30000000 - 1

(input.length..lastIndex).each do |index|
  last = hash[number]

  if last[0] == 1
    number = 0
  else
    number = index - last[1] - 1
  end

  hash[number] ||= [1, index]
  hash[number][0] += 1
  
  last[1] = index - 1
  last_num = number

  puts number if index == 2019 # Part 1
end

puts number # Part 2