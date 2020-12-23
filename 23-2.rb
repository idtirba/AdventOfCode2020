input = [1,8,6,5,2,4,9,7,3]

marker = input.max + 1
while marker <= 1000000 do
  input.push(marker)
  marker+=1
end

rounds = 10000000
min = input.min
max = input.max

class Node
  attr_reader :val, :next_node
  attr_writer :val, :next_node
end

length = input.length

head = Node.new
head.val = input[0]
current = head

nodeHash = {}
nodeHash[head.val] = head

input[1..input.length-1].each do |i|
  node = Node.new
  node.val = i
  nodeHash[i] = node
  current.next_node = node
  current = node
end

current.next_node = head
cursor = head
rounds.times do |i|
  current = cursor
  pick = cursor.next_node
  pickVals = [cursor.next_node.val, cursor.next_node.next_node.val, cursor.next_node.next_node.next_node.val]
  cursor.next_node = cursor.next_node.next_node.next_node.next_node
  destVal = current.val-1
  destVal = max if destVal < min
  while pickVals.include?(destVal) do
    destVal -= 1
    destVal = max if destVal < min
  end
  destNode = nodeHash[destVal]
  after = destNode.next_node
  destNode.next_node = pick
  pick.next_node.next_node.next_node = after
  cursor = cursor.next_node
end

one = nodeHash[1]
a = one.next_node.val
b = one.next_node.next_node.val
p "#{a} * #{b} = #{a*b}"
