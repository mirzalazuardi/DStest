require 'digest'
class TrendingContent
  def initialize(*args)
    namedir  = args[0] || '.'
    @namedir = namedir
  end

  def count_level_subdir
    path       = @namedir+'/*'
    pre_result = 0
    subdir     = proc {Dir[path].select{ |x| Dir.exist? x }}
    subdir.call().size
  end

  def exec
    p @namedir
  end
end

test = TrendingContent.new
test.count_level_subdir
#test.exec
