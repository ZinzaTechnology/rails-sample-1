class CsvHandler
  class << self
    def generate_with_bom(data, header=nil)
      bom = "\uFEFF"
      CSV.generate do |csv|
        if header.present?
          header[0] = bom + header[0]
          csv << header
        elsif data.first.present?
          data.first[0] = bom + data.first[0]
        end

        data.each do |record|
          csv << record
        end
      end
    end
  end
end
