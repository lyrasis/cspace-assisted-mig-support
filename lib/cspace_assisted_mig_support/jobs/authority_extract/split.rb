# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module Split
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__extract,
              destination: :authority_extract__split
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Cams::Transforms::AuthorityExtract::Splitter
          end
        end
      end
    end
  end
end
