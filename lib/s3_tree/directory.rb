class S3Tree::Directory
  include ActionView::Helpers::NumberHelper
  attr_reader :path

  def initialize(bucket, path)
    @bucket = bucket
    @path = path
  end

  def name
    URI.decode(path_pieces.last).gsub('+', ' ')
  end

  def parent
    parent_path = path_pieces[0..-2].join('/')
    S3Tree::Directory.new(@bucket, parent_path) unless parent_path.blank?
  end

  def children
    subdirectories + files
  end

  def subdirectories
    @subdirectories ||= list_objects['common_prefixes'].collect do |prefix|
      S3Tree::Directory.new(@bucket, prefix.prefix)
    end
  end

  def files
    @files ||= list_objects['contents'].collect do |object|
      S3Tree::File.new(@bucket, s3_object: object) unless object.key.ends_with?('/')
    end.compact
    (@files.sort_by &:last_modified).reverse!
  end

  def size
    number_to_human_size(@bucket.objects(prefix: @path.gsub('+', ' ')).inject(0) { |sum, s3_object| sum + s3_object.content_length })
  end

  def last_modified
    (@bucket.objects(prefix: @path.gsub('+', ' ')).inject([]) { |date, s3_object| date.push(s3_object.last_modified) }).max
  end
  private

  def path_pieces
    @path_pieces ||= path ? path.split('/') : []
  end

  def list_objects
    @list_objects ||= @bucket.client.list_objects({
                                                      prefix: @path.blank? ? '' : @path,
                                                      delimiter: '/',
                                                      bucket: @bucket.name,
                                                      encoding_type: 'url'
                                                  })
  end

end