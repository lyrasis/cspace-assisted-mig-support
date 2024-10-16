# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module CleanedSource
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__orig,
              destination: :authority_extract__cleaned_source,
              lookup: :authority_extract__extract_clean
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            Cams.authority_extract_headers.each do |header|
              cleanheader = "#{header}_clean".to_sym
              transform Merge::MultiRowLookup,
                lookup: authority_extract__extract_clean,
                keycolumn: header,
                fieldmap: {cleanheader => :clean},
                conditions: ->(_r, rows) do
                  rows.select { |row| row[:source] == header.to_s }
                end
            end
          end
        end
      end
    end
  end
end
