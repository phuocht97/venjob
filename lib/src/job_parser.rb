class JobParser

  def initialize(logger, url)
    @logger = logger
    @url = url
  end

  def crawl_all
    find_company
    find_job
  end

  def find_company
    info = Nokogiri::HTML(URI.open(@url))
    links = info.css('div.caption a.company-name').map { |link| link['href'] }
    links.each do |link|
      next if link == 'javascript:void(0);'

      page = Nokogiri::HTML(URI.open(URI.escape(link)))
      name = page.search('p.name')&.text
      next if name.blank?

      address = page.css('div.content p').children[1]&.text
      introduction = page.css('div.main-about-us').text
      begin
        Company.find_or_create_by!(name: name,
                                   address: address,
                                   introduction: introduction)
      rescue StandardError => e
        @logger.error e.message
      end
    end
  end

  def city_relationship(row, job)
    location_relationship = row.css('div.map p a').children.map { |name_city| name_city.text.strip }
    cities_relationship = City.where(name: location_relationship)

    job.cities << cities_relationship
  end

  def industry_relationship(row, job)
    industry_relationship = row.css('li a').children.map { |name_industry| name_industry.text.strip }
    industries_relationship = Industry.where(name: industry_relationship)

    job.industries << industries_relationship
  end

  def create_job(title, link_page, row, company)
    description = link_page.search('div.detail-row').to_s
    salary = row.at_xpath('//li[./strong/i[contains(@class, "fa fa-usd")]]/p').text.strip
    experience = row.at_xpath('//li[./strong/i[contains(@class, "fa fa-briefcase")]]/p')&.text&.strip
    level = row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-account")]]/p').text.strip
    expiration_date = row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-calendar-check")]]/p').text.strip

    job = Job.find_or_create_by!(title: title,
                                 level: level,
                                 salary: salary,
                                 experience: experience,
                                 expiration_date: expiration_date,
                                 description: description,
                                 company_id: company.id)

    city_relationship(row, job)
    industry_relationship(row, job)
  end

  def find_job
    info = Nokogiri::HTML(URI.open(@url))
    link = info.css('a.job_link').map { |link| link['href'] }
    link.each do |link|
      link_page = Nokogiri::HTML(URI.open(URI.escape(link)))
      row = link_page.search('div.bg-blue div.row')
      next if row.blank?

      begin
        company_name = link_page.search('div.job-desc a.job-company-name').text.strip
        company = Company.find_by(name: company_name)
        next if company.blank?

        title = link_page.search('div.job-desc p').text.strip
        next if title.blank?
        create_job(title, link_page, row, company)

      rescue StandardError => e
        @logger.error e.message
      end
    end

  end
end
