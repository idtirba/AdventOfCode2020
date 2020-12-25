keys = [14222596,4057428]
# keys = [5764801, 17807724]
loops = []


def getLoop(key)
  val = 1
  loop = 0
  while val != key do
    val *= 7
    val %= 20201227
    loop+=1
    return loop if val == key
  end
end

keys.each do |k|
  loops.push(getLoop(k))
end

val = 1
key = keys[1]
loops[0].times do 
  val*=key
  val %= 20201227
end

p val