require 'net/ftp'
require 'csv'
require 'zip'
class InforJob

  def initialize(logger, url)
    @mylogger = logger
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
      return if name.blank?

      address = page.css('div.content p').children[1]&.text
      introduction = page.css('div.main-about-us').text
      begin
        puts name
        Company.find_or_create_by!(name: name,
                                   address: address,
                                   introduction: introduction)
      rescue StandardError => e
        @mylogger.error e.message
      end
    end
  end

  def create_city_rel(row, info_job)
    location_rel = row.css('div.map p a').children.map { |name_city| name_city.text.strip }
    city_table = City.where(name: location_rel)

    puts "#{info_job.cities << city_table}"
    info_job.cities << city_table
  end

  def create_industry_rel(row, info_job)
    industry_rel = row.css('li a').children.map { |name_industry| name_industry.text.strip }
    industry_table = Industry.where(name: industry_rel)

    puts "#{info_job.industries << industry_table}"
    info_job.industries << industry_table
  end

  def create_job(title, link_page, row, company_table)
    description = link_page.search('div.detail-row').to_s
    salary = row.at_xpath('//li[./strong/i[contains(@class, "fa fa-usd")]]/p').text.strip
    experience = row.at_xpath('//li[./strong/i[contains(@class, "fa fa-briefcase")]]/p')&.text&.strip
    level = row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-account")]]/p').text.strip
    expiration_date = row.at_xpath('//li[./strong/i[contains(@class, "mdi mdi-calendar-check")]]/p').text.strip

    info_job = Job.find_or_create_by!(title: title,
                                      level: level,
                                      salary: salary,
                                      experience: experience,
                                      expiration_date: expiration_date,
                                      description: description,
                                      company_id: company_table.id)

    create_city_rel(row, info_job)
    create_industry_rel(row, info_job)
  end

  def find_job
    info = Nokogiri::HTML(URI.open(@url))
    link = info.css('a.job_link').map { |link| link['href'] }
    link.each do |link|
      link_page = Nokogiri::HTML(URI.open(URI.escape(link)))
      row = link_page.search('div.bg-blue div.row')
      next if row.blank?

      begin
        name_company = link_page.search('div.job-desc a.job-company-name').text.strip
        company_table = Company.find_by(name: name_company)
        next if company_table.blank?

        title = link_page.search('div.job-desc p').text.strip
        next if title.blank?
        create_job(title, link_page, row, company_table)

      rescue StandardError => e
        puts e
        # @mylogger.error e.message
      end

    end
  end
end
