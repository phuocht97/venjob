require 'csv'
class ExportCsvService

  def initialize(objects, attributes)
    @attributes = attributes
    @objects = objects
  end

  def perform
    CSV.generate do |csv|
      csv << attributes
      objects.each do |object|
        info_applied = object.attributes.values_at(*attributes)
        info_applied[0] = object.job.title
        csv << info_applied
      end
    end
  end

  private

  attr_reader :objects, :attributes
end
