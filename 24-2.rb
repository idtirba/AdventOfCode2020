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

hash = {}

input.each do |i|
  tile = getTile(i, directions)
  loc = tile
  if hash[loc]
    hash.delete(loc)
  else
    hash[loc] = 1
  end
end

p hash.keys.length

toFlip = []

# 'e', 'w', 'se', 'sw', 'ne', 'nw'
sixNeighbors = [[0,1],[0,-1],[-1,-1],[-1,0],[1,0],[1,1]]

def adjacentBlackTiles(tile, hash, sixNeighbors)
  tiles = []
  sixNeighbors.each do |n|
    neighbor = [n,tile].transpose.map {|x| x.reduce(:+)}
    tiles.push(neighbor) if hash[neighbor]
  end
  return tiles.length
end

100.times do
  toFlip = []
  hash.keys.each do |k|
    adj = adjacentBlackTiles(k, hash, sixNeighbors)
    toFlip.push(k) if adj == 0 or adj > 2
    sixNeighbors.each do |n|
      neighbor = [n,k].transpose.map {|x| x.reduce(:+)}
      if !hash[neighbor]
        adjW = adjacentBlackTiles(neighbor, hash, sixNeighbors)
        toFlip.push(neighbor) if adjW == 2
      end
    end
  end
  toFlip.uniq!
  toFlip.each do |f|
    if hash[f]
      hash.delete(f)
    else
      hash[f] = 1
    end
  end
end

p hash.keys.length