# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module ExtractClean
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__extract,
              destination: :authority_extract__extract_clean,
              lookup: :authority_extract__split_clean
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Merge::MultiRowLookup,
              lookup: authority_extract__split_clean,
              keycolumn: :value,
              fieldmap: {clean: :usedform},
              sorter: Lookup::RowSorter.new(
                on: :pos, dir: :asc, as: :to_i, blanks: :last
              ),
              delim: Cams.delim
          end
        end
      end
    end
  end
end
