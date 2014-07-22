desc 'Extracts TODO tags and the likes'
task :todo do
  pattern = /(NOTE|FIXME|TODO|THINK|@todo)(.+)/
  found   = Hash.new { |hash, key| hash[key] = [] }

  Dir.glob('lib/**/*.{rb,rl,y}').each do |file|
    File.open(file, 'r') do |handle|
      handle.each_line.each_with_index do |line, index|
        if line =~ pattern
          found[file] << [index + 1, $1 + $2]
        end
      end
    end
  end

  found.each do |file, notes|
    puts file

    notes.each do |(nr, line)|
      puts "#{nr}: #{line}"
    end

    puts
  end
end
