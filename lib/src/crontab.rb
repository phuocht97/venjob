class Crontab
  attr_accessor
  def initialize(logger)
    @mylogger = logger
  end

  def find_company(url)
    company_info = Nokogiri::HTML(URI.open(url))
    company_links = company_info.css('div.caption a.company-name').map { |link| link['href'] }
    company_links.each do |link|
      next if link == 'javascript:void(0);'
      company_page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      name_company = company_page.search('p.name')&.text
      address_company = company_page.css('div.content p').children[1]&.text
      introduction_company = company_page.css('div.main-about-us').text
      next if name_company.blank?
      begin
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
  
  def create_job(title_job, level, salary, experience, expiration_date, description, company_id)
    Job.create!(title: title_job,
                level: level,
                salary: salary,
                experience: experience,
                expiration_date: expiration_date,
                description: description,
                company_id: company_id)         
  end

  def create_city_rel(get_row, job_find)
    location_rel = get_row.css('div.map p a').children.map { |location| location.text.strip }
    location_rel.each do |loc|
      city_table = City.find_by(name: loc)
      next if city_table.nil?
      unless CityJob.exists?(job_id: job_find.id, city_id: city_table.id)
        puts "Created City: #{job_find.id} - #{city_table.id}.#{loc}"
        city_jobs = CityJob.create!(job_id: job_find.id, city_id: city_table.id)
      end
    end
  end

  def create_industry_rel(get_row, job_find)
    industry_rel = get_row.css('li a').children.map { |industry| industry.text.strip }
    industry_rel.each do |ind|
      industry_table = Industry.find_by(name: ind)
      next if industry_table.nil?
      unless IndustryJob.exists?(job_id: job_find.id, industry_id: industry_table.id)
        puts "Created Industry: #{job_find.id} - #{industry_table.id}.#{ind}"
        industry_jobs = IndustryJob.create!(job_id: job_find.id, industry_id: industry_table.id)
      end
    end
  end

  def find_job(url)
    page_access = Nokogiri::HTML(URI.open(url))
    get_link = page_access.css('a.job_link').map { |link| link['href'] }
    get_link.each do |link|
      link_page_job = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      get_row = link_page_job.search('div.bg-blue div.row')
      if get_row.present?
        begin
          get_name_company = link_page_job.search('div.job-desc a.job-company-name').text.strip
          title_job = link_page_job.search('div.job-desc p').text.strip
          description = link_page_job.search('div.detail-row')
          salary = get_row.at_xpath('//li[./strong/i[contains(@class, "fa fa-usd")]]/p').text.strip
          experience = get_row.at_xpath('//li[./strong/i[contains(@class, "fa fa-briefcase")]]/p')&.text&.strip
          level = get_row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-account")]]/p').text.strip
          expiration_date = get_row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-calendar-check")]]/p').text.strip
          company_table = Company.find_by(name: get_name_company)
          next if company_table.nil?
          job_check = Job.exists?(title: title_job, company_id: company_table.id)
          if job_check == false
            create_job(title_job, level, salary, experience, expiration_date, description, company_table.id)
          end
          next if job_check == false
          job_find = Job.find_by(title: title_job, company_id: company_table.id)
          create_city_rel(get_row, job_find)
          create_industry_rel(get_row, job_find)
          rescue StandardError => e
            @mylogger.error "#{e.message}"
        end
      end
    end
  end
end
