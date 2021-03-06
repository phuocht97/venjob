require 'net/ftp'
require 'csv'
require 'zip'

class CSVImporter
  NAME_DOMAIN = '192.168.1.156'.freeze
  FTP_USERNAME = 'training'.freeze
  FTP_PASSWORD = 'training'.freeze

  def initialize(logger)
    @logger = logger
    @extracting_directory = Rails.root.join('lib', 'csv')
    @zip_directory = Rails.root.join('jobs.zip')
    @importer = Rails.root.join('lib', 'csv', 'jobs.csv')
  end

  def import
    get_file_csv
    extract_zip
    import_file_csv
  end

  def get_file_csv
    Net::FTP.open(NAME_DOMAIN, FTP_USERNAME, FTP_PASSWORD) do |ftp|
      ftp.getbinaryfile('jobs.zip')
    end
  end

  def extract_zip
    FileUtils.mkdir_p(@extracting_directory)
    Zip::File.open(@zip_directory) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(@extracting_directory, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end

  def import_file_csv
    CSV.foreach(@importer, headers: true) do |row|
      begin
        company_name = row["company name"].to_s
        next if company_name.blank?

        company_address = row["company address"]
        company_introduction = row["benefit"]
        company = Company.find_or_create_by!(name: company_name,
                                             address: company_address,
                                             introduction: company_introduction)

        title_job = row["name"].to_s
        next if title_job.blank?

        description_job = "#{row["description"]} #{row["requirement"]}"
        level = row["level"]
        salary = row["salary"]
        job = Job.find_or_create_by!(title: title_job,
                                     description: description_job,
                                     level: level,
                                     salary: salary,
                                     company_id: company.id)

        job = Job.find_or_create_by!(title: title_job,
                                     description: description_job,
                                     level: level,
                                     salary: salary,
                                     company_id: company.id)

        industry_name = row["category"]
        industries_relationship = Industry.where(name: industry_name)
        next if industries_relationship.blank?

        industry_job_relationship = IndustryJob.where(job_id: job.id, industry_id: industries_relationship.ids)
        next if industry_job_relationship.present?

        job.industries << industries_relationship if industry_job_relationship.blank?

        location_data = row["work place"]
        location = location_data.gsub('["', '').gsub('"]', '')
        location_relationship = City.where(name: location)
        next if location_relationship.blank?

        location_job_relationship = CityJob.where(job_id: job.id ,city_id: location_relationship.ids)
        next if location_job_relationship.present?

        job.cities << location_relationship if location_job_relationship.blank?

      rescue StandardError => e
        @logger.error e.message
      end
    end
  end
end
