# S3Tree

This gem use to create tree structure or listing of AWS S3 files and directories. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_tree
## Requirements
```ruby
 gem 'aws-sdk', '~> 2'
 ```
 
 Currently this gem support only 'aws-sdk' version 2. See documentation for [aws-sdk-ruby](https://github.com/aws/aws-sdk-ruby).
## Syntax
```ruby
     S3Tree.tree(bucket_name,path_to_directory)
 ```
 Leave `path` option blank for get all listing 
 
## Usage
```ruby
require 's3_tree'
  
class ReportsController < ApplicationController
  def index
    params[:path] ||= ''
    @tree = S3Tree.tree('bucket_name',params[:path])
  end
end
```

 `index.html.erb`
 
 ```ruby
  <table>
    <thead>
      <tr>
        <th>Name</th>
        <th>Last Modified</th>
        <th>Size</th>
      </tr>
    </thead>
    <tbody>
    <% @tree.each do |node| %>
        <tr>
          <td>
            <% if (node.class == S3Tree::File) %>
              <%= link_to  node.name, node.url %>
            <% else %>
              <%= link_to node.name, reports_path(path: node.path)%>
            <% end %>
          </td>
          <td width="25%">
            <%= node.last_modified %>
          </td>
          <td width="15%">
            <%= node.size %>
          </td>
        </tr>
      </tbody>
      <% end %>
    <% end %>
  </table>

 ```
## Useful methods

`Directory Methods`
> name

 It will return name of directory.
  
> parent
   
 It will return parent directory if exist.

> subdirectories
   
 It will return subdirectory of current directory.
    
> files
 
 It will return all files of current directory.
    
> children   
    
 It will return subdirectory and files combination of current directory.
   
> size
   
 It will return size of directory.
   
> last_modified
   
 Last modification date of directory.  
 
`File Methods` 

> name

 It will return name of file.
  
> extension
   
 It will return extension of file.

> directory
   
 It will return container directory.
    
> s3_object
 
 It will return original s3 object for direct use.
      
> size
   
 It will return size of directory.
   
> last_modified
   
 Last modification date of directory.
 
> url
 
 It will return presigned url for one click download file.