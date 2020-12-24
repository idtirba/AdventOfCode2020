input = File.read('24.txt').split("\n")
directions = ['e', 'w', 'se', 'sw', 'ne', 'nw']

def getTile(i, directions)
  loc = [0,0]
  cursor = 0
  neighbors = []
  # n/s e/w
  while cursor < i.length
    csize = 2
    d = cursor+1 >= i.length ? i[cursor] : i[cursor..cursor+1]
    csize-=1 if !directions.include?(d)
    d = i[cursor] if !directions.include?(d)
    case directions.index(d)
    when 0 # e
      loc[1]=loc[1]+1;
    when 1 # w
      loc[1]= loc[1]-1
    when 2 # se
      loc[0]=loc[0]-1
    when 3 # sw
      loc[0]=loc[0]-1
      loc[1]=loc[1]-1
    when 4 # ne
      loc[0]=loc[0]+1
      loc[1]=loc[1]+1
    else # nw
      loc[0]=loc[0]+1
    end
    cursor+=csize
  end
  return loc
end

tiles = []

input.each do |i|
  tile = getTile(i, directions)
  tiles.include?(tile) ? tiles.delete(tile) : tiles.push(tile)
end

p tiles.length