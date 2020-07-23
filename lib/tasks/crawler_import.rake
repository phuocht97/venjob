require 'src/crawler.rb'
require 'net/ftp'
crawl = Crawler.new
namespace :import do
  desc "crawler data"
  task crawler: :environment do
    crawl.crawl_city
    crawl.crawl_industry
    crawl.crawl_company
    crawl.crawl_job_relationships
  end
  task csv_get: :environment do
    crawl.get_file_csv
  end
end