 class Crawler
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
    data_industry = get_name.search('option').map{ |p| p.text.strip }

    data_industry.each do |name_industry|
       industry = Industry.create!(name: name_industry)
    end
  end
  def crawl_company
    for n in 1..10
      company_info = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      company_link = company_info.css('div.caption a.company-name').map{ |link| link['href'] }
      company_link.each do |link|  
        if link.include?('\u2019')
          link.gsub!('\u2019',"'")
        end
        if link == 'javascript:void(0);'
          next
        elsif link != 'https://careerbuilder.vn/vi/nha-tuyen-dung/hr-vietnam\xE2\x80\x99s-ess-client.35A4EFBA.html'
          company_page = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
          if company_page.search('p.name').text != nil
            begin
              name_company         = company_page.search('p.name').text
              address_company      = company_page.css('div.content p').children[1].text
              introduction_company = company_page.css('div.main-about-us').text
              get_name_company     = Company.find_by(name: "#{name_company}")
              if get_name_company == nil
              company = Company.create!(name: name_company,
                address: address_company,
                introduction: introduction_company)
              end
              rescue StandardError => e
                puts e
            end
          end
        end
      end
    end
  end
  def crawl_job_relationships
    for n in 1..10
      page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      get_link = page_access.css('a.job_link').map{ |link| link['href'] }
      get_link.each do |link|
        if link.include?('\u2013')
          link.gsub!('\u2013','–') 
        end
    page_job = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
    get_row = page_job.search('div.bg-blue div.row')
      if get_row != ""
        get_name_company = page_job.search('div.job-desc a.job-company-name').text.strip
        company_table    = Company.find_by(name: "#{get_name_company}")
        title_job        = page_job.search('div.job-desc p').text
        description      = page_job.search('div.detail-row')
        arr_column = get_row.css('div.has-background').map{ |data| data.text.split(' ').join(' ') }
        arr_column.each_with_index do | val, key |
          if company_table != nil
            if val.include?('Ngày cập nhật')
              arr_data = val.gsub('Ngày cập nhật ','').split(' ')
              date = arr_data.first
            elsif val.include?('Lương') && val.include?('Kinh nghiệm') == true
              arr_sub = ((((val.gsub('Lương ','')).gsub(' Kinh nghiệm ', '*')).gsub(' Cấp bậc ', '*')).gsub(' Hết hạn nộp ', '*')).split('*')
              salary = arr_sub[0]
              experience = arr_sub[1]
              level =arr_sub[2]
              expiration_date = arr_sub[3]
              job = Job.create!(title: title_job,
                                level: level,
                                salary: salary,
                                experience: experience,
                                expiration_date: expiration_date,
                                description: description,
                                company_id: company_table.id)
            elsif val.include?('Lương') && val.include?('Kinh nghiệm') == false
              arr_sub = (((val.gsub('Lương ','')).gsub(' Cấp bậc ', '*')).gsub(' Hết hạn nộp ', '*')).split('*')
              salary = arr_sub[0]
              level =arr_sub[1]
              expiration_date = arr_sub[2]
              job = Job.create!(title: title_job,
                                level: level,
                                salary: salary,
                                experience: 'Không có',
                                expiration_date: expiration_date,
                                description: description,
                                company_id: company_table.id)
            end
          end
        end
          job_table = Job.find_by(title: "#{title_job}")
          if job_table != nil      
            location_rel     = get_row.css('div.map p a').children.map{ |location| location.text.strip }
            location_rel.each do |loc|
              puts "#{job_table.id} - #{loc}"
              city_table     = City.find_by(name: "#{loc}")
              city_jobs      = CityJob.create!(job_id: job_table.id, city_id: city_table.id)
            end
            industry_rel     = get_row.css('li a').children.map{ |industry| industry.text.strip }
            industry_rel.each do |ind|
              puts "#{job_table.id} - #{ind}"
              industry_table = Industry.find_by(name: "#{ind}")
              industry_jobs  = IndustryJob.create!(job_id: job_table.id, industry_id: industry_table.id)
            end
          end
        end
      end
    end
  end
  def get_file_csv
    Net::FTP.open('192.168.1.156', 'training', 'training') do |ftp|
      files = ftp.list
      puts "list out files in root directory:"
      puts files
    end
  end
end