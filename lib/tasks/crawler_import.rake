require 'src/crawler.rb'
require 'src/crontab.rb'
require 'net/ftp'
require 'csv'
require 'zip'
action = Crawler.new
crontab = Crontab.new
namespace :import do
  desc "crawler data"
  task crawler: :environment do
    action.crawl_city
    action.crawl_industry
    action.crawl_company
    action.crawl_job_relationships
  end
  desc "get file CSV from server"
  task csv_get: :environment do
    action.get_file_csv
    action.extract_zip('./jobs.zip','.')
  end
  desc "Import data from CSV"
  task data_csv: :environment do
    action.import_file_csv
  end
  desc "Crontab"

  task auto: :environment do
    crontab.find_company
    crontab.find_job
    action.logger
  end

  task log: :environment do
    action.logger
  end
end