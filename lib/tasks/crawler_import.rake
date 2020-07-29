require 'src/crawler.rb'
require 'src/crontab.rb'
require 'net/ftp'
require 'csv'
require 'zip'


namespace :import do
  logger ||= Logger.new(Rails.root.join('log','my.log'))

  desc 'crawler data'
  task crawler: :environment do
    action = Crawler.new(logger)
    action.crawl_city
    action.crawl_industry
    action.crawl_company
    action.crawl_job_relationships
  end
  desc 'Crontab'
  task auto: :environment do
    action = Crawler.new(logger)
    crontab = Crontab.new(logger)
    crontab.find_company
    crontab.find_job
    action.get_file_csv
    action.extract_zip('./jobs.zip', 'lib/csv')
    action.import_file_csv('lib/csv/jobs.csv')
  end
end
