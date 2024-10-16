# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module Todo
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__extract_clean,
              destination: :authority_extract__todo
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform do |row|
              next if row[:value] == row[:clean]

              row
            end
            transform Rename::Fields, fieldmap: {
              value: :find,
              clean: :replace,
              source: :field
            }
            transform CombineValues::FullRecord
            transform Deduplicate::Table,
              field: :index,
              delete_field: true
          end
        end
      end
    end
  end
end
