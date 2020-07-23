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
  def crawl_job
    for n in 1..10
      page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      get_link = page_access.css('a.job_link').map{ |link| link['href'] }
      get_link.each do |link|
        if link.include?('\u2013')
          link.gsub!('\u2013','–') 
        end
      pagecompany = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      get_row = pagecompany.search('div.bg-blue div.row')
      if get_row != ""
        length_page      = get_row.css('li p').children.length
        location_length  = get_row.search('div.map a').children.length
        title            = pagecompany.search('div.job-desc p').text
        get_name_company = pagecompany.search('div.job-desc a.job-company-name').text.strip
        description      = pagecompany.search('div.detail-row')
        industry = get_row.css('li a').children.text.split(' ').join(' ')
        company_table    = Company.find_by(name: "#{get_name_company}")
        if length_page.to_i == 11 || length_page.to_i == 9 || length_page.to_i == 13
            if location_length == 3
              date = get_row.css('p').children[(location_length)-1].text
              salary = get_row.css('p').children[(length_page.to_i)-2].text.split(' ').join(' ')
              experience = get_row.css('p').children[(length_page.to_i)-1].text.split(' ').join(' ')
              level = get_row.css('p').children[(length_page.to_i)].text.split(' ').join(' ')
              expiration_date = get_row.css('p').children[(length_page.to_i)+1].text.split(' ').join(' ')
              if company_table != nil
                job = Job.create!(title: title,
                  description: description,
                  level: level,
                  salary: salary,
                  experience: experience,
                  expiration_date: expiration_date,
                  company_id: company_table.id)
              end
            elsif location_length == 2
              date = get_row.css('p').children[(location_length)-1].text          
              salary = get_row.css('p').children[(length_page.to_i)-3].text.split(' ').join(' ')
              experience = get_row.css('p').children[(length_page.to_i)-2].text.split(' ').join(' ')
              level = get_row.css('p').children[(length_page.to_i)-1].text.split(' ').join(' ')
              expiration_date = get_row.css('p').children[(length_page.to_i)].text.split(' ').join(' ')
              if company_table != nil
                job = Job.create!(title: title,
                  description: description,
                  level: level,
                  salary: salary,
                  experience: experience,
                  expiration_date: expiration_date,
                  company_id: company_table.id)
              end
            end

          elsif length_page.to_i == 10 || length_page.to_i == 12 || length_page.to_i == 8
            if location_length == 3
              date = get_row.css('p').children[(location_length)-1].text
              salary = get_row.css('p').children[(length_page.to_i)-1].text.split(' ').join(' ')
              level = get_row.css('p').children[(length_page.to_i)].text.split(' ').join(' ')
              expiration_date = get_row.css('p').children[(length_page.to_i)+1].text.split(' ').join(' ')
              if company_table != nil
                job = Job.create!(title: title,
                  description: description,
                  level: level,
                  salary: salary,
                  experience: experience,
                  expiration_date: expiration_date,
                  company_id: company_table.id)
              end
            elsif location_length == 2
              date = get_row.css('p').children[(location_length)-1].text
              salary = get_row.css('p').children[(length_page.to_i)-2].text.split(' ').join(' ')
              level = get_row.css('p').children[(length_page.to_i)-1].text.split(' ').join(' ')
              expiration_date = get_row.css('p').children[(length_page.to_i)].text.split(' ').join(' ')
              if company_table != nil
                job = Job.create!(title: title,
                  description: description,
                  level: level,
                  salary: salary,
                  experience: experience,
                  expiration_date: expiration_date,
                  company_id: company_table.id)
              end
            end
          end
        end
      end  
    end
  end
  def crawl_city_job
    for n in 1..10
      page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      get_link = page_access.css('a.job_link').map{ |link| link['href'] }
      get_link.each do |link|
        if link.include?('\u2013')
          link.gsub!('\u2013','–') 
        end
      pagecompany = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      get_row = pagecompany.search('div.bg-blue div.row')
      if get_row != ""
        begin
        length_page      = get_row.css('li p').children.length
        location_length  = get_row.search('div.map a').children.length
        title            = pagecompany.search('div.job-desc p').text.strip
        get_name_company = pagecompany.search('div.job-desc a.job-company-name').text.strip
        exp_exist        = get_row.css('div.has-background li strong').text.include?('Kinh nghiệm')
        company_table    = Company.find_by(name: "#{get_name_company}")
        job_table        = Job.find_by(title: "#{title}", company_id: "#{company_table.id}")
        if length_page.to_i == 11 || length_page.to_i == 9 || length_page.to_i == 13 && exp_exist == true && company_table.id != nil
            if location_length == 3
              location    = get_row.search('div.map a').children[0].text.strip
              location1   = get_row.search('div.map a').children[1].text.strip
              city_table  = City.find_by(name: "#{location}")
              city_table1 = City.find_by(name: "#{location1}")
              if city_table != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table.id)
              elsif city_table1 != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table1.id)
              end
            elsif location_length == 2
              location    = get_row.search('div.map a').children.text.strip
              city_table  = City.find_by(name: "#{location}")
              if city_table != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table.id)
              end
            end

          elsif length_page.to_i == 10 || length_page.to_i == 12 || length_page.to_i == 8 && exp_exist == false && company_table.id != nil
            if location_length == 3
              location    = get_row.search('div.map a').children[0].text.strip
              location1   = get_row.search('div.map a').children[1].text.strip
              city_table  = City.find_by(name: "#{location}")
              city_table1 = City.find_by(name: "#{location1}")
              if city_table != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table.id)
              elsif city_table1 != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table1.id)
              end
            elsif location_length == 2
              location    = get_row.search('div.map a').children.text.strip
              city_table  = City.find_by(name: "#{location}")
              if city_table != nil && job_table != nil
                city_job_relationship = CityJob.create!(job_id: job_table.id,
                  city_id: city_table.id)
              end
            end
          end
        rescue StandardError => e
                  puts e
      end 
        end
      end  
    end
  end
  def crawl_industry_job
    for n in 1..10
      page_access = Nokogiri::HTML(URI.open("https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-#{n}-vi.html"))
      get_link = page_access.css('a.job_link').map{ |link| link['href'] }
      get_link.each do |link|
        if link.include?('\u2013')
          link.gsub!('\u2013','–') 
        end
      pagecompany = Nokogiri::HTML(URI.open(URI.parse(URI.escape(link))))
      get_row = pagecompany.search('div.bg-blue div.row')
      if get_row != ""
        begin
        length_page      = get_row.css('li p').children.length
        location_length  = get_row.search('div.map a').children.length
        title            = pagecompany.search('div.job-desc p').text
        exp_exist        = get_row.css('div.has-background li strong').text.include?('Kinh nghiệm')
        industry_length  = get_row.css('li a').children.length
        get_name_company = pagecompany.search('div.job-desc a.job-company-name').text.strip
        company_table    = Company.find_by(name: "#{get_name_company}")
        job_table        = Job.find_by(title: "#{title}", company_id: "#{company_table.id}")
        if company_table.id != nil && job_table.id != nil
          if length_page.to_i == 11 || length_page.to_i == 9 || length_page.to_i == 13 && exp_exist == true 
            if location_length == 3
              if industry_length == 3
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                industry2 = get_row.css('li a').children[2].text.split(' ').join(' ')
                find_ind2  = Industry.find_by(name: "#{industry2}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                elsif find_ind2 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind2.id}")
                end
              elsif industry_length == 2
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: find_ind.id)
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                end
              elsif industry_length == 1
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: find_ind.id)
              end
            elsif location_length == 2
              if industry_length == 3
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                industry2 = get_row.css('li a').children[2].text.split(' ').join(' ')
                find_ind2  = Industry.find_by(name: "#{industry2}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: find_ind.id)
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                elsif find_ind2 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind2.id}")
                end
              elsif industry_length == 2
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: find_ind.id)
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                end
              elsif industry_length == 1
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: find_ind.id)
              end
            end

        elsif length_page.to_i == 10 || length_page.to_i == 12 || length_page.to_i == 8 && exp_exist == false
            if location_length == 3
              if industry_length == 3
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                industry2 = get_row.css('li a').children[2].text.split(' ').join(' ')
                find_ind2  = Industry.find_by(name: "#{industry2}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                elsif find_ind2 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind2.id}")
                end
              elsif industry_length == 2
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                end
              elsif industry_length == 1
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
              end
            elsif location_length == 2
             if industry_length == 3
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                industry2 = get_row.css('li a').children[2].text.split(' ').join(' ')
                find_ind2  = Industry.find_by(name: "#{industry2}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                elsif find_ind2 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind2.id}")
                end
              elsif industry_length == 2
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry1 = get_row.css('li a').children[1].text.split(' ').join(' ')
                find_ind1  = Industry.find_by(name: "#{industry1}")
                if find_ind != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
                elsif find_ind1 != nil
                  industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind1.id}")
                end
              elsif industry_length == 1
                industry  = get_row.css('li a').children[0].text.split(' ').join(' ')
                find_ind  = Industry.find_by(name: "#{industry}")
                industry_job_relationship = IndustryJob.create!(job_id: "#{job_table.id}", industry_id: "#{find_ind.id}")
              end
                end
              end
            end
          end
        end
        rescue StandardError => e
                  puts e
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