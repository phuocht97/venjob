class Crontab
  def initialize(logger)
    @mylogger = logger
  end
  
  def find_company
    company_info = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html"))
    company_link = company_info.css('div.caption a.company-name').map { |link| link['href'] }
    company_link.each do |link|
      next if link == 'javascript:void(0);'
      if link != 'https://careerbuilder.vn/vi/nha-tuyen-dung/hr-vietnam\xE2\x80\x99s-ess-client.35A4EFBA.html'
        company_page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
        unless (company_page.search('p.name').text).nil?
          begin
            name_company         = company_page.search('p.name').text
            address_company      = company_page.css('div.content p').children[1].text
            introduction_company = company_page.css('div.main-about-us').text
            get_name_company     = Company.find_by(name: name_company)
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
  def find_job
    page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-vi.html"))
    get_link = page_access.css('a.job_link').map { |link| link['href'] }
    get_link.each do |link|
      page_job = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      get_row = page_job.search('div.bg-blue div.row')
      if get_row != ""
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
            if job_check.nil?
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
          unless find_job.nil?
            location_rel = get_row.css('div.map p a').children.map { |location| location.text.strip }
            location_rel.each do |loc|
              city_table = City.find_by(name: loc)
              if CityJob.find_by(job_id: find_job.id, city_id: city_table.id).nil?
                puts "Created City: #{find_job.id} - #{city_table.id}.#{loc}"
                city_jobs = CityJob.create!(job_id: find_job.id, city_id: city_table.id)
              end
            end
            industry_rel = get_row.css('li a').children.map { |industry| industry.text.strip }
            industry_rel.each do |ind|
              industry_table = Industry.find_by(name: ind)
              if IndustryJob.find_by(job_id: find_job.id, industry_id: industry_table.id).nil?
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
