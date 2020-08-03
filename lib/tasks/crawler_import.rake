require 'src/crawler.rb'
require 'src/jobparser.rb'
require 'src/csvimporter.rb'

namespace :import do
  desc 'crawler data'
  task crawler: :environment do
    action = Crawler.new(logger, url)
    action.crawl_city_industry
  end
  desc 'Crontab'
  task auto: :environment do
    crontab = JobParser.new(logger, url)
    csvimporter = CSVimporter.new(logger)
    crontab.crawl_all
    csvimporter.import
  end

  def logger
    Logger.new(Rails.root.join('log','my.log'))
  end

  def url
    'https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html'
  end
end
