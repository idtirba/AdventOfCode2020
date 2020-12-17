input = ".###.#.#
####.#.#
#.....#.
####....
#...##.#
########
..#####.
######.#".split(/\n/).map{ |x| x.split('')}

layers = [input]
cycles = 6

def getCount(l, px, py)
  return 0 unless l
  count = 0
  [-1,0,1].each do |y|
    [-1,0,1].each do |x|
      if py+y>=0 && px+x >=0 && py+y<l.length && px+x<l[0].length
        count+=1 if l[py+y][px+x] == '#'
      end
    end
  end
  return count
end

def convertLayer(b, m, t)
  newLayer = Marshal.load( Marshal.dump(m))
  m.each_with_index do |vy, y|
    vy.each_with_index do |vx, x|
      if m[y][x] == '#'
        count = getCount(b,x,y) + getCount(m,x,y) + getCount(t,x,y) - 1
        newLayer[y][x] = '.' if !count.between?(2,3)
      else
        count = getCount(b,x,y) + getCount(m,x,y) + getCount(t,x,y)
        newLayer[y][x] = '#' if count == 3
      end
    end
  end
  return newLayer
end

def growLayer(l)
  size = l.length
  newLayer = Array.new(size+2){Array.new(size+2,'.')}
  l.each_with_index do |vy, y|
    vy.each_with_index do |vx, x|
      newLayer[y+1][x+1] = l[y][x]
    end
  end
  return newLayer
end

def printLayers(layers)
  layers.each do |layer|
    layer.each do |l|
      p l
    end
    p '------'
  end
end

(1..cycles).each do
  layers.unshift(Array.new(layers[0].length){Array.new(layers[0][0].length,'.')})
  layers.push(Array.new(layers[0].length){Array.new(layers[0][0].length,'.')})
  layers.each_with_index do |l, i|
    layers[i] = growLayer(l)
  end
  newLayers =  Marshal.load( Marshal.dump(layers))
  layers.each_with_index do |l, li|
    bottom = li-1 > -1 ? layers[li-1] : nil
    top = li+1 < layers.length ? layers[li+1] : nil
    convertedLayer = convertLayer(bottom, l, top)
    newLayers[li] = convertedLayer
  end
  layers = newLayers
end

count = 0

layers.each do |l|
  l.each_with_index do |vy, y|
    vy.each do |vx, x|
      count+=1 if vx =='#'
    end
  end
end

p count