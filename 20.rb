require "set"
input = File.read('20.txt').split("\n\n").map { |chunk| chunk.lines.map(&:chomp) }
@tileSides = {}
@wholeTiles = {}
@matchingSides = Set.new

input.each do |tile|
  key = tile[0].split(' ')[1][0...-1].to_i
  top = tile[1]
  down = tile[tile.length-1]
  left = tile[1..tile.length-1].map{|x|x[0]}.join('')
  right = tile[1..tile.length-1].map{|x|x[x.length-1]}.join('')
  @tileSides[key] = [top, down, left, right]
  @wholeTiles[key] = tile[1..tile.length-1].collect do |i| i.split('') end
end

@possibleMatches = {}
@tileSides.keys.each do |key|
  pm = []
  sides = @tileSides[key]
  sides.each do |side|
    @tileSides.keys.each do |k|
      next if key == k
      if @tileSides[k].any?{ |s| s == side || s.reverse == side }
        pm.push(k)
        @tileSides[k].each do |s|
          @matchingSides << s.split('') if s == side || s.reverse == side
        end
      end
    end
  end
  @possibleMatches[key] = pm
end

@corners = []
x = 1
@tileSides.keys.each do |key|
  if @possibleMatches[key].length == 2
    @corners.push(key)
    x*=key
  end
end
p x

def rotate(tileId, art, row)
  index = art[row].length - 1
  tile = @wholeTiles[tileId]
  top = art[row-1][index+1] if art[row-1] && row-1 >= 0
  left = art[row][index] if art[row][index] && index >=0
  if !top.nil? || !left.nil?
    topRow = top[top.length-1] if top
    leftRow = left.map{|x|x[x.length-1]} if left
    (0..1).each do |f|
      (0..3).each do
        if topRow && leftRow
          return tile if tile[0] == topRow && tile.map{|x|x[0]} == leftRow
        else # just left or top
          if left
            return tile if tile.map{|x|x[0]} == leftRow && !@matchingSides.include?(tile[0])
          else #just top
            return tile if tile[0] == topRow && !@matchingSides.include?(tile[0..tile.length-1].map{|x|x[0]})
          end
        end
        tile = tile.transpose.map(&:reverse)
      end
      f==0 ? tile = tile.reverse : tile = tile.map{ |r| r.reverse }
    end
  else # first corner
    while @matchingSides.include?(tile[0]) || @matchingSides.include?(tile[0..tile.length-1].map{|x|x[0]}) do
      tile = tile.transpose.map(&:reverse)
    end
    return tile
  end
end

def getNextTile(art, row)
  check = art[row].last&.map{|x|x[x.length-1]}
  check = art[row-1][art[row].length][art[row-1][art[row].length].length-1] if check.nil?
  @tileSides.keys.each do |k|
    next if @tilesUsed.include?(k)
    @tileSides[k].each do |l|
      return k if l.split('') == check || l.split('').reverse == check
    end
  end
end

def populateRow(art, row)
  art[row] ||= []
  (0..11).each do |x|
    if art[row].length==0 && row == 0
      tileId = @corners[0]
    else # top, left
      tileId = getNextTile(art, row)
    end
    tile = rotate(tileId, art, row)
    art[row].push(tile)
    @tilesUsed.push(tileId)
  end
end

art = []
@tilesUsed = []
(0..11).each do |x|
  populateRow(art, x)
end

#bring the picture together
finalArt = []
(0..11).each do |r|
  (1..8).each do |tr|
    row = []
    (0..11).each do |t|
      row.push(art[r][t][tr][1..art[r][t][tr].length-2])
    end
    row = row.join.split('')
    finalArt.push(row)
  end
end

poundCount = 0
finalArt.each_with_index do |row,i|
  poundCount += row.count('#')
  p row.join
end

monster = []
monster_coor = ["                  # ", "#    ##    ##    ###", " #  #  #  #  #  #   "]
(0..2).each do |y|
  (0..19).each do |x|
    monster.push([y,x]) if monster_coor[y][x] == '#'
  end
end

fCount = 0
(0..1).each do |f|
  (0..3).each do
    (0..finalArt.length-3).each do |row|
      (0..finalArt.length-20).each do |col|
        monsterCount = 0
        monster.each_with_index do |m, i|
          break if finalArt[row+m[0]][col+m[1]] != '#'
          monsterCount+=1 if finalArt[row+m[0]][col+m[1]] == '#'
          fCount += 1 if monsterCount == 15
        end
      end
    end
    finalArt = finalArt.transpose.map(&:reverse)
    if fCount > 0
      p poundCount-(fCount*monster.length)
      break
    end
  end
  f==0 ? finalArt = finalArt.reverse : finalArt = finalArt.reverse.map{ |r| r.reverse }
end