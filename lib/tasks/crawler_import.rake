require 'src/crawler.rb'
require 'src/job_parser.rb'
require 'src/csv_importer.rb'

namespace :import do
  desc 'crawler data'
  task crawler: :environment do
    action = Crawler.new(logger, url).crawl_city_industry
  end
  desc 'Crontab'
  task auto: :environment do
    parser = JobParser.new(logger, url)
    csv_importer = CSVImporter.new(logger)
    parser.crawl_all
    csv_importer.import
  end

  def logger
    Logger.new(Rails.root.join('log','crawling.log'))
  end

  def url
    'https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html'.freeze
  end
end
