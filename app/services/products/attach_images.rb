module Products
  class AttachImages
    def initialize(record:, files:)
      @record = record
      @files  = Array.wrap(files).compact_blank
    end

    def call
      return if @files.empty?

      @files.each { |f| @record.images.attach(f) }
    end
  end
end
