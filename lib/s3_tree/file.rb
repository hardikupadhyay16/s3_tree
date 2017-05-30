module S3Tree
  class File
    include ActionView::Helpers::NumberHelper
    attr_reader :path

    def initialize(bucket, path)
      @bucket = bucket
      @path = path
    end

    def name
      @name ||= File.basename(@path[:s3_object].key)
      URI.decode(@name).gsub('+', ' ')
    end

    def extension
      @extension ||= File.extname(@path[:s3_object].key)
    end

    def directory
      @directory ||= begin
        dir = File.dirname(@path[:s3_object].key)
        dir = nil if dir == '.'
        S3Tree::Directory.new(@bucket, dir)
      end
    end

    def size
      number_to_human_size(@path[:s3_object].size)
    end

    def last_modified
      @path[:s3_object].last_modified
    end

    def s3_object
      @s3_object ||= @bucket.object(@path)
    end

    def url
      @bucket.object(URI.decode(@path[:s3_object].key).gsub('+', ' ')).presigned_url(:get)
    end
  end
end