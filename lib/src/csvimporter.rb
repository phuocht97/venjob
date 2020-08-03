require 'net/ftp'
require 'csv'
require 'zip'

class CSVimporter
  def initialize(logger)
    @logger = logger
    @NAME_DOMAIN = '192.168.1.156'
    @USERNAME_FTP = 'training'
    @PASSWORD_FTP = 'training'
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
    Net::FTP.open(@NAME_DOMAIN, @USERNAME_FTP, @PASSWORD_FTP) do |ftp|
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
        company_name = row["company name"]
        next if company_name.blank?
        company_address = row["company address"]
        company_introduction = row["benefit"]
        company = Company.find_or_create_by!(name: company_name,
                                             address: company_address,
                                             introduction: company_introduction)

        title_job = row["name"]
        next if title_job.blank?
        description_job = "#{row["description"]} #{row["requirement"]}"
        level = row["level"]
        salary = row["salary"]
        job = Job.find_or_create_by!(title: title_job,
                                     description: description_job,
                                     level: level,
                                     salary: salary,
                                     company_id: company.id)

        industry_name = row["category"]
        industries_relationship = Industry.where(name: industry_name)
        if industries_relationship.blank?
          industry = Industry.create!(name: industry_name)
          industries_relationship = Industry.where(name: industry)
          job.industries << industries_relationship
        else
          job.industries << industries_relationship
        end

        location_data = row["work place"]
        location = location_data.gsub('["', '').gsub('"]', '')
        location_relationship = City.where(name: location)
          if location_relationship.blank?
            city = City.create!(name: location)
            location_relationship = City.where(name: city)
            job.cities << location_relationship
          else
            job.cities << location_relationship
          end
      rescue StandardError => e
        @logger.error e.message
      end
    end
  end
end