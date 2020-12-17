input = ".###.#.#
####.#.#
#.....#.
####....
#...##.#
########
..#####.
######.#".split(/\n/).map{ |x| x.split('')}

# key = [layer, bsVal, y, x]
hash = Hash.new('.')

def getCount(l,bs,y,x,hash)
  count = 0
  [-1,0,1].each do |dl|
    [-1,0,1].each do |dbs|
      [-1,0,1].each do |dy|
        [-1,0,1].each do |dx|
          next if dl==0 && dbs==0 && dy==0 && dx == 0
          count+=1 if hash[[l+dl,bs+dbs,y+dy,x+dx]] == '#'
        end
      end
    end
  end
  return count
end

def getNewVal(l,bs,y,x,hash)
  current = hash[[l,bs,y,x]]
  count = getCount(l,bs,y,x,hash)
  newChar = current
  if current == '#'
    newChar = '.' if !count.between?(2,3)
  else
    newChar = '#' if count == 3 
  end
  return newChar
end

input.each_with_index do |row, y|
  row.each_with_index do |val, x|
    hash[[0,0,y,x]] = val
  end
end

(1..6).each do
  newDimensions = hash.dup
  lMin = hash.keys.map { |key| key[0] }.min - 1
  lMax = hash.keys.map { |key| key[0] }.max + 1
  bsMin = hash.keys.map { |key| key[1] }.min - 1
  bsMax = hash.keys.map { |key| key[1] }.max + 1
  yMin = hash.keys.map { |key| key[2] }.min - 1
  yMax = hash.keys.map { |key| key[2] }.max + 1
  xMin = hash.keys.map { |key| key[3] }.min - 1
  xMax = hash.keys.map { |key| key[3] }.max + 1

  (lMin..lMax).each do |l|
    (bsMin..bsMax).each do |bs|
      (yMin..yMax).each do |y|
        (xMin..xMax).each do |x|
          newDimensions[[l,bs,y,x]] = getNewVal(l,bs,y,x,hash)
        end
      end
    end
  end
  hash = newDimensions
end

p hash.values.count { |c| c == '#' }
