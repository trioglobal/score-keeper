namespace :package do
  task :build => :environment do
    files = {
      :css => ['lib/reset', 'lib/typography', 'lib/grid', 'lib/forms', 'screen'],
      :js => ['jquery-ui', 'jquery-fx', 'jquery.tablesorter', 'application']
    }
    
    file_dirs = {
      :css => File.join(RAILS_ROOT, 'public', 'stylesheets'),
      :js => File.join(RAILS_ROOT, 'public', 'javascripts')
    }
    
    latest_mtime = 0
    files.keys.each do |type|
      temp_file = File.join(RAILS_ROOT, 'tmp', "temp.#{type}")

      File.open(temp_file, 'w') do |f|
        files[type].each do |file|
          filename = File.join(file_dirs[type], "#{file}.#{type}")
          File.open(filename, 'r') do |sf|
            f.write(sf.read)
          end
          
          latest_mtime = File.mtime(filename).to_i if File.mtime(filename).to_i > latest_mtime
        end
      end

      output_file = File.join(file_dirs[type], "base_#{latest_mtime}.#{type}")
      `java -jar lib/yuicompressor.jar --type #{type} -o #{output_file} #{temp_file}`

      File.delete(temp_file)
    end
  end
end