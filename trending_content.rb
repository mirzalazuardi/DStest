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
    @level_subdir
  end

  def frequency arr
    arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h}
  end

  def show_files
    path = @namedir + pre_suffix(@level_subdir) + '/*'
    Dir[path].select { |node| File.file? node }
  end

  def exec
    count_level_subdir
    files               = show_files
    digests             = files.map { |node| Digest::SHA256.file(node).hexdigest }
    freqs               = frequency(digests)
    digest_trend        = digests.max_by { |v| freqs[v] }
    content_idx         = digests.index(digest_trend)
    freq_of_toptrend    = freqs[digest_trend]
    content_of_toptrend = File.read(files[content_idx])
    "#{content_of_toptrend} #{freq_of_toptrend}"
  end
end

test = TrendingContent.new
test.exec
