require 's3_tree/version'
require 's3_tree/directory'
require 's3_tree/file'

module S3Tree
  def self.tree(bucket_name,path='')
    path = path + '/' if path.present?
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(bucket_name)
    S3Tree::Directory.new(bucket,path).children
  end

  # def self.list(bucket_name,path='')
  #   tree = {}
  #   path = path + '/' if path.present?
  #   s3 = Aws::S3::Resource.new
  #   bucket = s3.bucket(bucket_name)
  #   objects = bucket.objects.collect(&:key)
  #   objects.each do |object|
  #     length = object.length
  #     array = object.split('/')
  #     value = array.pop
  #     directories = S3Tree::Directory.new(bucket,path).children if array[length - 1] == '/'
  #     h = array.reverse.inject(value) { |a, n| { n => a } }
  #   end
  #
  # end
  #
  # private
  #
  # def generate_tree(bucket,path='')
  #   directories = S3Tree::Directory.new(bucket,path).subdirectories
  #   directories.each do |directory|
  #
  #     #
  #     #   tree[directory.name] = {}
  #     #   directories = S3Tree::Directory.new(bucket,URI.decode(directory.path).gsub('+', ' '))
  #     # else
  #     #   tree[directory.directory.name] = S3Tree::Directory.new(bucket,directory.name + '/').files
  #     # end
  #   end
  # end

end
