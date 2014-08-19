module TranslationIO
  class Client
    class BaseOperation
      class DumpSlimGettextKeysStep
        def initialize(slim_source_files)
          @slim_source_files = slim_source_files
        end

        def run
          if @slim_source_files.any?
            TranslationIO.info "Extracting Gettext entries from SLIM files."

            FileUtils.mkdir_p(File.join('tmp', 'translation'))

            extracted_gettext_entries.each_with_index do |entry, index|
              File.open(File.join('tmp', 'translation', "slim-gettext-#{index.to_s.rjust(8,'0')}.rb"), 'w') do |file|
                file.puts "#{entry}"
              end
            end
          end
        end

        protected

        def extracted_gettext_entries
          entries = []

          @slim_source_files.each do |slim_file_path|
            TranslationIO.info slim_file_path, 2, 2

            slim_data = File.read(slim_file_path)
            entries  += TranslationIO::Extractor.extract(slim_data)
          end

          TranslationIO.info "#{entries.size} entries found", 2, 2

          entries
        end
      end
    end
  end
end
