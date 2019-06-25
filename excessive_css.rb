FILE_NAME_FOR_EXCESSIVE_CSS = 'excessive_css.txt'
FILES_JS = 'src/js/*.js'
FILES_CSS = 'src/css/*.scss'

class ExcessiveCss
  def call
    # js

    classes_js = get_classes_in_js_files

    # css

    classes_css = get_classes_in_css_files

    # write to file

    file = File.new(FILE_NAME_FOR_EXCESSIVE_CSS, 'a+')
    file.puts(classes_css - classes_js)
    file.close
  end

  private

  def each_line_of(directory)
    Dir.glob(directory) do |file|
      File.open(file) do |styles|
        styles.each do |line|
          yield line
        end
      end
    end
  end

  def get_classes_in_js_files
    array_classes = []

    each_line_of(FILES_JS) do |line|
      next unless line.include?('className')

      array_classes_on_this_line = line.lstrip.scan(/className='(.*?)'/).join(' ').split(' ')

      array_classes_on_this_line.each do |word|
        array_classes << word
      end
    end

    array_classes.uniq
  end

  def get_classes_in_css_files
    exclusion = [':', '::', ',']
    array_classes = []

    each_line_of(FILES_CSS) do |line|
      next unless line.include?('.')

      line.chop!

      line = line.lstrip.split(' ')

      line.each do |word|
        next unless word.include?('.')

        word = word.split('.')[1].split(Regexp.union(exclusion))[0]

        break unless word.match?(/^[a-zA-Z]/)

        array_classes << word
      end
    end

    array_classes.uniq
  end
end

all_time = []
number = 1_000

number.times do |index|
  File.delete(FILE_NAME_FOR_EXCESSIVE_CSS) if File.exist?(FILE_NAME_FOR_EXCESSIVE_CSS)

  excessive_css = ExcessiveCss.new

  begin_time = Time.now

  excessive_css.()

  end_time = Time.now

  all_time << end_time - begin_time
end

min_time = all_time.min
average_time = all_time.inject(0.0) { |sum, el| sum + el } / number
max_time = all_time.max

p "Min: #{min_time * 1_000}"          # "Min: 0.9910859999999999"
p "Average: #{average_time * 1_000}"  # "Average: 1.256173961999"
p "Max: #{max_time * 1_000}"          # "Max: 6.364087"
