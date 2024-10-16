# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module SplitClean
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__split,
              destination: :authority_extract__split_clean,
              lookup: :authority_extract__norm
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Merge::MultiRowLookup,
              lookup: authority_extract__norm,
              keycolumn: :value,
              fieldmap: {usedform: :usedform}
            transform CombineValues::FromFieldsWithDelimiter,
              sources: %i[full_value usedform],
              target: :combined,
              delete_sources: false,
              delim: " "
            transform Deduplicate::Table,
              field: :combined,
              delete_field: true
          end
        end
      end
    end
  end
end
