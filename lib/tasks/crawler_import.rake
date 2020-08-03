require 'src/crawler.rb'
require 'src/crontab.rb'

namespace :import do
  desc 'crawler data'
  task crawler: :environment do
    action = Crawler.new(logger)
    action.crawl_city_industry
  end
  desc 'Crontab'
  task auto: :environment do
    action = Crawler.new(logger)
    crontab = InforJob.new(logger, url)
    crontab.crawl_all
    action.get_file_csv
    action.extract_zip('./jobs.zip', 'lib/csv')
    action.import_file_csv(Rails.root.join('lib', 'csv', 'jobs.csv'))
  end

  def logger
    Logger.new(Rails.root.join('log','my.log'))
  end

  def url
    'https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html'
  end
end
