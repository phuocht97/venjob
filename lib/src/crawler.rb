class Crawler
  
  def initialize(logger)
    @mylogger = logger
    @NAME_DOMAIN = '192.168.1.156'
    @USERNAME_FTP = 'training'
    @PASSWORD_FTP = 'training'
  end

  def crawl_city
    page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html"))
    get_name = page.search('select#location')
    data_city = get_name.search('option').map(&:text).map(&:strip)
    
    data_city.each do |name_city|
      if City.find_by(id: 70)
       city = City.create!(name: name_city,
        location: 0)
      else
        city = City.create!(name: name_city,
        location: 1)
      end
    end
  end

  def crawl_industry
    page = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html"))
    get_name = page.search('select#industry')
    data_industry = get_name.search('option').map { |p| p.text.strip }

    data_industry.each do |name_industry|
       industry = Industry.create!(name: name_industry)
    end
  end

  def crawl_company
    (1..10).each do |n|
      company_info = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      company_link = company_info.css('div.caption a.company-name').map{ |link| link['href'] }
      company_link.each do |link|  
        next if link == 'javascript:void(0);' 
        company_page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
        if !(company_page.search('p.name').text).nil?
          begin
            name_company = company_page.search('p.name').text
            address_company = company_page.css('div.content p').children[1].text
            introduction_company = company_page.css('div.main-about-us').text
            get_name_company = Company.find_by(name: name_company)
            if get_name_company.nil?
            company = Company.create!(name: name_company,
              address: address_company,
              introduction: introduction_company)
            end
          rescue StandardError => e
            @mylogger.error "#{e.message}"
          end
        end
      end
    end
  end

  def crawl_job_relationships
    (1..10).each do |n|
      page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      get_link = page_access.css('a.job_link').map { |link| link['href'] }
      get_link.each do |link|
        page_job = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
        get_row = page_job.search('div.bg-blue div.row')
        if get_row.present?
          begin
          get_name_company = page_job.search('div.job-desc a.job-company-name').text.strip
          company_table = Company.find_by(name: get_name_company)
          title_job = page_job.search('div.job-desc p').text
          description = page_job.search('div.detail-row')
            next if company_table.nil?
              job_check = Job.find_by(title: title_job, company_id: company_table.id) 
              salary = get_row.at_xpath('//li[./strong/i[contains(@class, "fa fa-usd")]]/p').text.strip
              experience = get_row.at_xpath('//li[./strong/i[contains(@class, "fa fa-briefcase")]]/p').text.strip
              level = get_row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-account")]]/p').text.strip
              expiration_date = get_row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-calendar-check")]]/p').text.strip
              if job_check.blank?
                job = Job.create!(title: title_job,
                                  level: level,
                                  salary: salary,
                                  experience: experience,
                                  expiration_date: expiration_date,
                                  description: description,
                                  company_id: company_table.id)         
              end
            find_job = Job.find_by(title: title_job, company_id: company_table.id)
            puts find_job.title
            if find_job.present?
              location_rel = get_row.css('div.map p a').children.map { |location| location.text.strip }
              location_rel.each do |loc|
                city_table = City.find_by(name: loc)
                next if city_table.nil?
                unless CityJob.exists?(job_id: find_job.id, city_id: city_table.id).nil?
                  puts "Created City: #{find_job.id} - #{city_table.id}.#{loc}"
                  city_jobs = CityJob.create!(job_id: find_job.id, city_id: city_table.id)
                end
              end
              industry_rel = get_row.css('li a').children.map { |industry| industry.text.strip }
              industry_rel.each do |ind|
                industry_table = Industry.find_by(name: ind)
                next if industry_table.nil?
                unless IndustryJob.exists?(job_id: find_job.id, industry_id: industry_table.id)
                  puts "Created Industry: #{find_job.id} - #{industry_table.id}.#{ind}"
                  industry_jobs = IndustryJob.create!(job_id: find_job.id, industry_id: industry_table.id)
                end
              end
            end
          rescue StandardError => e
            @mylogger.error "#{e.message}"
          end
        end
      end
    end
  end

  def get_file_csv
    Net::FTP.open(@NAME_DOMAIN, @USERNAME_FTP, @PASSWORD_FTP) do |ftp|
      ftp.getbinaryfile('jobs.zip')
    end
  end

  def extract_zip(file, destination)
    FileUtils.mkdir_p(destination)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end

  def import_file_csv(file)
    CSV.foreach(file, headers: true) do |row|
      begin
        company_name = row["company name"]
        company_address = row["company address"]
        company_introduction = row["benefit"]
        company_table = Company.find_by(name: company_name)
        if company_table.nil?
          company_table = Company.create!(name: company_name,
                                          address: company_address,
                                          introduction: company_introduction)
        end
        title_job = row["name"]
        description_job = "#{row["description"]} #{row["requirement"]}"
        level = row["level"]
        salary = row["salary"]
        job_table = Job.find_by(title: title_job)
        if !company_table.nil? && job_table.nil?
          job_table = Job.create!(title: title_job,
                                  description: description_job,
                                  level: level,
                                  salary: salary,
                                  company_id: company_table.id)
          puts job_table.id
        end
        industry = row["category"]
        industry_find = Industry.find_by(name: industry)
        if industry_find.nil?
          industry_table = Industry.create!(name: industry)
          industry_job_table = IndustryJob.create!(job_id: job_table.id, industry_id: industry_find.id)
        else
          industry_job_table = IndustryJob.create!(job_id: job_table.id, industry_id: industry_find.id)
        end
        puts job_table.id, title_job, industry, salary
        location_data = row["work place"]
        location = location_data.gsub('["', '').gsub('"]', '')
        location_find = City.find_by(name: location)
        if location_find.nil?
          city_table = City.create!(name: location)
          city_job_table = CityJob.create!(job_id: job_table.id, city_id: location_find.id)
        else
          city_job_table = CityJob.create!(job_id: job_table.id, city_id: location_find.id)
        end
        puts "Location: #{location}"
      rescue StandardError => e
        @mylogger.error "#{e.message}"
      end
    end
  end
end
