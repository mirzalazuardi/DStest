# frozen_string_literal: true

require 'digest'
class TrendingContent
  def initialize(path = '.')
    namedir  = path
    @namedir = namedir
    @level_subdir = 0
  end

  def pre_suffix(num)
    '/**' * num
  end

  def count_lvl
    subdirs = ->(str) { Dir[@namedir + str + '/*'].select { |n| Dir.exist? n } }
    comparable_item = ->(num) { subdirs.call(pre_suffix(num)).size }
    curr_subdir_count = nil
    loop do
      if curr_subdir_count.nil? == true
        prev_subdir_count = comparable_item.call(@level_subdir)
      else
        prev_subdir_count = curr_subdir_count
      end
      @level_subdir += 1
      curr_subdir_count = comparable_item.call(@level_subdir)
      break if curr_subdir_count == prev_subdir_count
    end
    @level_subdir
  end

  def frequency(arr)
    arr.inject(Hash.new(0)) do |h, v|
      h[v] += 1
      h
    end
  end

  def show_files
    path = @namedir + pre_suffix(@level_subdir) + '/*'
    Dir[path].select { |node| File.file? node }
  end

  def show_digest(files)
    files.map do |node|
      Digest::SHA256.file(node).hexdigest
    end
  end

  def exec
    count_lvl
    files               = show_files
    digests             = show_digest files
    freqs               = frequency(digests)
    digest_trend        = digests.max_by { |v| freqs[v] }
    content_idx         = digests.index(digest_trend)
    freq_of_toptrend    = freqs[digest_trend]
    content_of_toptrend = File.read(files[content_idx])
    "#{content_of_toptrend} #{freq_of_toptrend}"
  end
end

# USAGE
test = TrendingContent.new
# OR
# test = TrendingContent.new('./DropsuiteTest')
test.exec
