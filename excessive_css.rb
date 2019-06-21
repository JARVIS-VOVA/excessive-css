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
      next unless line.include?('.') && line.include?(' {')

      array_classes_on_this_line = line.lstrip.split(' ')

      array_classes_on_this_line.each do |word|
        next unless word.include?('.')

        array_classes_on_this_line = word.split('.')[1].split(Regexp.union(exclusion))[0]

        array_classes << array_classes_on_this_line
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

average_time = all_time.inject(0.0) { |sum, el| sum + el } / number

p average_time
