# frozen_string_literal: true

require 'digest'
# This class created by Mirzalazuardi Hermawan in term of fulfill the job offer
# for Dropsuite Bandung
class TrendingContent
  def initialize(path = '.')
    namedir  = path
    @namedir = namedir
    @lvl_subd = 0
  end

  def pre_suffix(num)
    '/**' * num
  end

  def subdirs(pre_suffix)
    Dir[@namedir + pre_suffix + '/*'].select { |n| Dir.exist? n }
  end

  def count_lvl
    comp_itm = ->(num) { subdirs(pre_suffix(num)).size }
    cur_subd_cnt = nil
    loop do
      prv_subd_cnt = cur_subd_cnt.nil? ? comp_itm.call(@lvl_subd) : cur_subd_cnt
      @lvl_subd += 1
      cur_subd_cnt = comp_itm.call(@lvl_subd)
      break if cur_subd_cnt == prv_subd_cnt
    end
    @lvl_subd
  end

  def frequency(arr)
    arr.each_with_object(Hash.new(0)) do |v, h|
      h[v] += 1
    end
  end

  def show_files
    path = @namedir + pre_suffix(@lvl_subd) + '/*'
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
