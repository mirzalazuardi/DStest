require 'digest'
class TrendingContent
  def initialize(*args)
    namedir  = args[0] || '.'
    @namedir = namedir
    @level_subdir = 0
  end

  def pre_suffix num
    '/**' * num
  end

  def count_level_subdir
    subdirs         = lambda { |str| Dir[@namedir + str + '/*'].select{ |node| Dir.exist? node }}
    comparable_item = lambda { |num| subdirs.call(pre_suffix(num)).size }
    curr_subdir_count = nil
    loop do 
      prev_subdir_count = (curr_subdir_count.nil? == true) ? comparable_item.call(@level_subdir) : curr_subdir_count
      @level_subdir       += 1
      curr_subdir_count = comparable_item.call(@level_subdir)
      break if curr_subdir_count == prev_subdir_count
    end
    p @level_subdir
  end

  def exec
    p @namedir
  end
end

test = TrendingContent.new
test.count_level_subdir
#test.exec
