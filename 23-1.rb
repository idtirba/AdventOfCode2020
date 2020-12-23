input = [1,8,6,5,2,4,9,7,3]

min = input.min
max = input.max
length = input.length
index = 0

100.times do
  current = input[index]
  pickUp = []
  subIndex = index
  while pickUp.length < 3 do
    subIndex+=1
    subIndex = 0 if subIndex == input.length
    val = input[subIndex]
    pickUp.push(val)
  end

  input -= pickUp

  destination = current - 1
  destination = max if destination < min
  while pickUp.include?(destination) && destination != current do
    destination -= 1
    destination = max if destination < min
  end

  destinationIndex = input.index(destination)
  input = input[0..destinationIndex] + pickUp + input[destinationIndex+1..input.length-1]

  index = input.index(current) + 1
  index = 0 if index == input.length
end

p input[input.index(1)+1..input.length-1] + input[0..input.index(1)-1]